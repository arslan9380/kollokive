import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tajeer/app/locator.dart';
import 'package:tajeer/app/static_info.dart';
import 'package:tajeer/models/user_model.dart';

import 'image_service.dart';

@lazySingleton
class FriendService {
  final _usersKey = 'users';
  final _friendsKey = 'myFriends';

  ImageService imageService = locator<ImageService>();

  Future addFriend(UserModel user) async {
    try {
      await FirebaseFirestore.instance
          .collection(_usersKey)
          .doc(StaticInfo.userModel.id)
          .collection(_friendsKey)
          .doc(user.id)
          .set(user.toMap(), SetOptions(merge: true));
      return user;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future getAllFriends() async {
    List<UserModel> allFriends = [];

    try {
      var result = await FirebaseFirestore.instance
          .collection(_usersKey)
          .doc(StaticInfo.userModel.id)
          .collection(_friendsKey)
          .get();
      for (var doc in result.docs) {
        allFriends.add(UserModel.fromMap(doc.data()));
      }
      return allFriends;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future removeFriend(UserModel user) async {
    try {
      await FirebaseFirestore.instance
          .collection(_usersKey)
          .doc(StaticInfo.userModel.id)
          .collection(_friendsKey)
          .doc(user.id)
          .delete();
      return user;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
