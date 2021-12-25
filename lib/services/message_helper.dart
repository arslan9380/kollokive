import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tajeer/app/static_info.dart';
import 'package:tajeer/models/chat.dart';
import 'package:tajeer/models/message.dart';
import 'package:tajeer/models/user_model.dart';

class MessageHelper {
  final _myChats = 'my_chats';
  final _messages = 'messages';
  final _users = 'users';

  StreamSubscription _msgSubscription, _chatSubscription;

  StreamController<List<Message>> _msgStreamController;
  StreamController<List<Chat>> _chatStreamController;

  Sink<List<Message>> _msgSink;
  Sink<List<Chat>> _chatSink;

  Stream<List<Message>> _messageStream;
  Stream<List<Chat>> _chatStream;

  Stream<List<Message>> get messageStream => _messageStream;

  Stream<List<Chat>> get chatStream => _chatStream;

  MessageHelper.withMsgStreamInitialized(String uid) {
    _msgStreamController = StreamController<List<Message>>();
    _msgSink = _msgStreamController.sink;
    _messageStream = _msgStreamController.stream;

    _readMsgData(uid);
  }

  MessageHelper.withChatStreamInitialized() {
    _chatStreamController = StreamController<List<Chat>>();
    _chatSink = _chatStreamController.sink;
    _chatStream = _chatStreamController.stream;

    _readChatData();
  }

  MessageHelper();

  _readMsgData(String uid) {
    _msgSubscription = FirebaseFirestore.instance
        .collection(_messages)
        .where('usersUidsMerge', whereIn: [
          '$uid${StaticInfo.userModel.id}',
          '${StaticInfo.userModel.id}$uid'
        ])
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

  _readChatData() {
    _chatSubscription = FirebaseFirestore.instance
        .collection(_users)
        .doc(StaticInfo.userModel.id)
        .collection(_myChats)
        .snapshots()
        .listen((event) async {
      List<Chat> data = [];
      Timestamp timeStamp;
      bool newMsg = false;
      String lastMsg;
      String imageUrl;

      for (var doc in event.docs) {
        timeStamp = doc.data()['key'];
        newMsg = doc.data()['NewMsg'];
        lastMsg = doc.data()['lastMsg'];
        imageUrl = doc.data()['imageUrl'];
        var userData = (await FirebaseFirestore.instance
                .collection(_users)
                .doc(doc.id)
                .get())
            .data();
        if (userData == null) continue;
        UserModel user = UserModel.fromMap(userData);
        String uid = user.id;
        String name = user.name;

        data.add(Chat(uid, name, timeStamp, newMsg, lastMsg, imageUrl));
      }
      _chatSink.add(data);
    });
  }

  void dispose() {
    _msgSubscription?.cancel();
    _msgStreamController?.close();
    _chatSubscription?.cancel();
    _chatStreamController?.close();
  }

  Future<void> sentMessage(
      Message msg, DateTime time, String profileImageUrl) async {
    try {
      if (msg.url != null) {
        await FirebaseStorage.instance
            .ref()
            .child('message')
            .child(DateTime.now().millisecondsSinceEpoch.toString())
            .putFile(File(msg.url))
            .then((value) async {
          msg.url = await value.ref.getDownloadURL();
        });
      }

      await FirebaseFirestore.instance
          .collection(_messages)
          .doc(msg.msgId)
          .set(msg.toMap());

      await FirebaseFirestore.instance
          .collection(_users)
          .doc(msg.senderUid)
          .collection(_myChats)
          .doc(msg.receiverUid)
          .set({
        'key': time,
        "lastMsg": msg.msgBody,
        "imageUrl": profileImageUrl
      }, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection(_users)
          .doc(msg.receiverUid)
          .collection(_myChats)
          .doc(msg.senderUid)
          .set({
        'key': time,
        "lastMsg": msg.msgBody,
        'NewMsg': true,
        "imageUrl": StaticInfo.userModel.imageUrl
      }, SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
    }
  }

  deleteChat(String uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(StaticInfo.userModel.id)
        .collection('my_chats')
        .doc(uid)
        .delete();
    await FirebaseFirestore.instance
        .collection(_messages)
        .where('usersUidsMerge', whereIn: [
          '$uid${StaticInfo.userModel.id}',
          '${StaticInfo.userModel.id}$uid'
        ])
        .get()
        .then((value) {
          value.docs.forEach((element) {
            element.reference.delete();
          });
        });
  }
}
