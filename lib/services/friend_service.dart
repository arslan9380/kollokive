import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:kollokvie/app/locator.dart';
import 'package:kollokvie/app/static_info.dart';
import 'package:kollokvie/models/friends_model.dart';
import 'package:kollokvie/models/notification_model.dart';

import 'image_service.dart';
import 'notification_service.dart';

@lazySingleton
class FriendService {
  final _friendsKey = 'myFriends';

  ImageService imageService = locator<ImageService>();

  Future addFriend(FriendsModel friendsModel) async {
    try {
      String title = "Friend Alert";
      String body =
          "${StaticInfo.userModel.value.name} send you a friend request";
      locator<NotificationService>()
          .sendNotification(friendsModel.sendToUser.fcm, body, title);
      NotificationModel notificationModel = NotificationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          notificationBody: body,
          notificationTitle: title,
          notificationTime: Timestamp.now(),
          sentBy: StaticInfo.userModel.value.id,
          sentTo: friendsModel.sendToUser.fcm);
      locator<NotificationService>().addNotification(notificationModel);
      await FirebaseFirestore.instance
          .collection(_friendsKey)
          .doc(friendsModel.id)
          .set(friendsModel.toMap(), SetOptions(merge: true));
      return friendsModel;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future getAllFriends() async {
    List<FriendsModel> allFriends = [];

    try {
      var result = await FirebaseFirestore.instance
          .collection(_friendsKey)
          .where("friendsIds", arrayContains: StaticInfo.userModel.value.id)
          .get();
      for (var doc in result.docs) {
        allFriends.add(FriendsModel.fromMap(doc.data()));
      }
      return allFriends;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future removeFriend(FriendsModel friendsModel) async {
    try {
      await FirebaseFirestore.instance
          .collection(_friendsKey)
          .doc(friendsModel.id)
          .delete();
      return friendsModel;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future removeFriendByUserId(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection(_friendsKey)
          .doc(userId + StaticInfo.userModel.value.id)
          .delete();
      await FirebaseFirestore.instance
          .collection(_friendsKey)
          .doc(StaticInfo.userModel.value.id + userId)
          .delete();
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future acceptFriendRequest(FriendsModel friendsModel) async {
    try {
      String title = "Friend Alert";
      String body =
          "${friendsModel.sendToUser.name} accepted your friend request";
      locator<NotificationService>()
          .sendNotification(friendsModel.sendByUser.fcm, body, title);

      NotificationModel notificationModel = NotificationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          notificationBody: body,
          notificationTitle: title,
          notificationTime: Timestamp.now(),
          sentBy: StaticInfo.userModel.value.id,
          sentTo: friendsModel.sendByUser.id);
      locator<NotificationService>().addNotification(notificationModel);
      await FirebaseFirestore.instance
          .collection(_friendsKey)
          .doc(friendsModel.id)
          .set({"isPending": false}, SetOptions(merge: true));
      return friendsModel;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
