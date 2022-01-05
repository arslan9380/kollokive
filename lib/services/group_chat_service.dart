import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:kollokvie/app/locator.dart';
import 'package:kollokvie/app/static_info.dart';
import 'package:kollokvie/models/group_model.dart';
import 'package:kollokvie/models/message.dart';
import 'package:kollokvie/models/notification_model.dart';
import 'package:kollokvie/models/user_model.dart';
import 'package:kollokvie/services/image_service.dart';
import 'package:kollokvie/services/notification_service.dart';

@lazySingleton
class GroupChatService {
  StreamSubscription _groupsSubscription, _msgSubscription;

  StreamController<List<Message>> _msgStreamController;
  StreamController<List<GroupModel>> groupsStreamController;

  Sink<List<Message>> _msgSink;
  Sink<List<GroupModel>> _groupsSink;

  Stream<List<Message>> _messageStream;
  Stream<List<GroupModel>> _groupsStream;

  Stream<List<Message>> get messageStream => _messageStream;

  Stream<List<GroupModel>> get groupsStream => _groupsStream;

  GroupChatService();

  GroupChatService.withGroupStreamInitialized() {
    groupsStreamController = StreamController<List<GroupModel>>();
    _groupsSink = groupsStreamController.sink;
    _groupsStream = groupsStreamController.stream;
    _readMyGroupsData();
  }

  GroupChatService.withGroupMsgsStreamInitialized(String uid) {
    _msgStreamController = StreamController<List<Message>>();
    _msgSink = _msgStreamController.sink;
    _messageStream = _msgStreamController.stream;

    _readMsgData(uid);
  }

  _readMsgData(String groupId) {
    _msgSubscription = FirebaseFirestore.instance
        .collection(_groupsCollection)
        .doc(groupId)
        .collection("messages")
        .orderBy('msgId')
        .snapshots()
        .listen((event) {
      List<Message> data = [];
      for (var doc in event.docs) {
        data.add(Message.fromMap(doc.data()));
      }
      _msgSink.add(data);
    });
  }

  _readMyGroupsData() {
    _groupsSubscription = FirebaseFirestore.instance
        .collection(_groupsCollection)
        .where("memebers", arrayContains: StaticInfo.userModel.value.id)
        .snapshots()
        .listen((event) async {
      List<GroupModel> allGroups = [];
      for (var doc in event.docs) {
        allGroups.add(GroupModel.fromMap(doc.data()));
      }
      _groupsSink.add(allGroups);
    });
  }

  Future<void> sentMessage(Message msg, DateTime time) async {
    try {
      if (msg.url != null) {
        msg.url =
            await locator<ImageService>().saveFiles(msg.url, "chatImages");
      }

      await FirebaseFirestore.instance
          .collection(_groupsCollection)
          .doc(msg.receiverUid)
          .collection("messages")
          .doc(msg.msgId)
          .set(msg.toMap());

      await FirebaseFirestore.instance
          .collection(_groupsCollection)
          .doc(msg.receiverUid)
          .set({
        "lastMessageTime": Timestamp.fromDate(time),
        "recentMessage": msg.msgBody,
        "recentMessageSender": StaticInfo.userModel.value.name,
        "recentMessageTime": DateTime.now().toString()
      }, SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
    }
  }

  void dispose() {
    _groupsSubscription?.cancel();
    groupsStreamController?.close();
    _msgStreamController?.close();
    _msgSubscription.cancel();
  }

  // Collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');
  final String _groupsCollection = "groups";

  Future createMyGroup(GroupModel groupModel) async {
    try {
      if (groupModel.groupIcon != null) {
        if (!groupModel.groupIcon.contains("http")) {
          String url = await locator<ImageService>()
              .saveFiles(groupModel.groupIcon, "groupImages");
          if (url == null) return;
          groupModel.groupIcon = url;
        }
      }
      await FirebaseFirestore.instance
          .collection(_groupsCollection)
          .doc(groupModel.groupId)
          .set(groupModel.toMap(), SetOptions(merge: true));

      // String group = groupModel.groupId;
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(StaticInfo.userModel.value.id)
      //     .set({
      //   'groups': FieldValue.arrayUnion([group])
      // }, SetOptions(merge: true));
      return groupModel;
    } catch (e) {
      print(e);
      return false;
    }
    // DocumentReference groupDocRef = await groupCollection.add({
    //   'groupName': groupName,
    //   'groupIcon': '',
    //   'admin': userName,
    //   'members': [],
    //   //'messages': ,
    //   'groupId': '',
    //   'recentMessage': '',
    //   'recentMessageSender': ''
    // });
    //
    // await groupDocRef.update({
    //   'members':
    //   FieldValue.arrayUnion([StaticInfo.userModel.value.id + '_' + userName]),
    //   'groupId': groupDocRef.id
    // });
    //
    // DocumentReference userDocRef = userCollection.doc(StaticInfo.userModel.value.id);
    // return await userDocRef.update({
    //   'groups': FieldValue.arrayUnion([groupDocRef.id + '_' + groupName])
    // });
  }

  Future leaveGroup(GroupModel groupModel) async {
    try {
      if (groupModel.adminId == StaticInfo.userModel.value.id) {
        await FirebaseFirestore.instance
            .collection(_groupsCollection)
            .doc(groupModel.groupId)
            .delete();

        await FirebaseFirestore.instance
            .collection(_groupsCollection)
            .doc(groupModel.groupId)
            .collection("messages")
            .get()
            .then((value) {
          for (DocumentSnapshot ds in value.docs) {
            ds.reference.delete();
          }
        });
      } else {
        groupModel.memebers.remove(StaticInfo.userModel.value.id);
        groupModel.groupMembers.removeWhere(
            (element) => element.id == StaticInfo.userModel.value.id);
        groupModel.groupMembers.forEach((element) {
          String title = "Leave Group";
          String body =
              "${StaticInfo.userModel.value.name} leave a group ${groupModel.groupName}";
          locator<NotificationService>()
              .sendNotification(element.fcm, body, title);
          NotificationModel notificationModel = NotificationModel(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              notificationBody: body,
              notificationTitle: title,
              notificationTime: Timestamp.now(),
              sentBy: StaticInfo.userModel.value.id,
              sentTo: element.id);
          locator<NotificationService>().addNotification(notificationModel);
        });

        await FirebaseFirestore.instance
            .collection(_groupsCollection)
            .doc(groupModel.groupId)
            .set(groupModel.toMap(), SetOptions(merge: true));
      }

      return groupModel;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future getMyGroups() async {
    try {
      List<GroupModel> myGroups = [];
      print(StaticInfo.userModel.value.id);
      var result = await FirebaseFirestore.instance
          .collection(_groupsCollection)
          .where("memebers",
              arrayContainsAny: [StaticInfo.userModel.value.id]).get();
      for (var doc in result.docs) {
        myGroups.add(GroupModel.fromMap(doc.data()));
      }
      print(myGroups.length);
      return myGroups;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future addToGroup(UserModel userModel, GroupModel groupModel) async {
    try {
      await FirebaseFirestore.instance
          .collection(_groupsCollection)
          .doc(groupModel.groupId)
          .set({
        'memebers': FieldValue.arrayUnion([userModel.id]),
        'groupMembers': FieldValue.arrayUnion([userModel.toMap()])
      }, SetOptions(merge: true));
      groupModel.groupMembers.forEach((element) {
        String title = "Join Group";
        String body = "${userModel.name} join a group ${groupModel.groupName}";
        locator<NotificationService>()
            .sendNotification(element.fcm, body, title);
        NotificationModel notificationModel = NotificationModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            notificationBody: body,
            notificationTitle: title,
            notificationTime: Timestamp.now(),
            sentBy: StaticInfo.userModel.value.id,
            sentTo: element.id);
        locator<NotificationService>().addNotification(notificationModel);
      });

      String title = "Add in Group";
      String body =
          "${StaticInfo.userModel.value.name} add you in ${groupModel.groupName} group";
      locator<NotificationService>()
          .sendNotification(userModel.fcm, body, title);
      NotificationModel notificationModel = NotificationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          notificationBody: body,
          notificationTitle: title,
          notificationTime: Timestamp.now(),
          sentBy: StaticInfo.userModel.value.id,
          sentTo: userModel.id);
      locator<NotificationService>().addNotification(notificationModel);
      return true;
    } catch (e) {
      print("error in adding user");
      print(e);
      return false;
    }
  }

  ///--------------------------------------------------------------------------

  // toggling the user group join
  Future togglingGroupJoin(
      String groupId, String groupName, String userName) async {
    DocumentReference userDocRef =
        userCollection.doc(StaticInfo.userModel.value.id);
    DocumentSnapshot userDocumentSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.doc(groupId);

    Map<String, dynamic> data =
        userDocumentSnapshot.data() as Map<String, dynamic>;
    List<dynamic> groups = data['groups'];
    if (groups.contains(groupId + '_' + groupName)) {
      await userDocRef.update({
        'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayRemove(
            [StaticInfo.userModel.value.id + '_' + userName])
      });
    } else {
      //print('nay');
      await userDocRef.update({
        'groups': FieldValue.arrayUnion([groupId + '_' + groupName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayUnion(
            [StaticInfo.userModel.value.id + '_' + userName])
      });
    }
  }

  // has user joined the group
  Future<bool> isUserJoined(
      String groupId, String groupName, String userName) async {
    DocumentReference userDocRef =
        userCollection.doc(StaticInfo.userModel.value.id);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();
    Map<String, dynamic> data = userDocSnapshot.data() as Map<String, dynamic>;
    List<dynamic> groups = data['groups'];
    if (groups.contains(groupId + '_' + groupName)) {
      return true;
    } else {
      return false;
    }
  }

  // get user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where('email', isEqualTo: email).get();
    print(snapshot.docs[0].data);
    return snapshot;
  }

  // get user groups
  Future getUserGroups() async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(StaticInfo.userModel.value.id)
        .snapshots();
  }

  // send message
  sendMessage(String groupId, chatMessageData) {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .add(chatMessageData);
    FirebaseFirestore.instance.collection('groups').doc(groupId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });
  }

  // get chats of a particular group
  getChats(String groupId) async {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  // search groups
  searchByName(String groupName) {
    return FirebaseFirestore.instance
        .collection("groups")
        .where('groupName', isEqualTo: groupName)
        .get();
  }
}
