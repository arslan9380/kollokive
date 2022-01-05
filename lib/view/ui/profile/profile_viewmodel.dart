import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kollokvie/app/locator.dart';
import 'package:kollokvie/app/static_info.dart';
import 'package:kollokvie/models/chat.dart';
import 'package:kollokvie/models/friends_model.dart';
import 'package:kollokvie/models/user_model.dart';
import 'package:kollokvie/services/auth_service.dart';
import 'package:kollokvie/services/common_ui_service.dart';
import 'package:kollokvie/services/friend_service.dart';
import 'package:kollokvie/view/ui/chat/chat_view.dart';
import 'package:kollokvie/view/ui/edit_profile/edit_profile_view.dart';
import 'package:kollokvie/view/ui/friends/friends_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends BaseViewModel with CommonUiService {
  bool loading = true;
  AuthService authService = locator<AuthService>();
  FriendService friendService = locator<FriendService>();
  String msg = "";
  UserModel userModel;
  bool proccesing = false;

  bool showFriendsMenu = false;

  bool showEditProfile = false;

  setProcessing(bool val) {
    proccesing = val;
    notifyListeners();
  }

  setLaoding(bool val) {
    loading = val;
    notifyListeners();
  }

  getMyData(String userId) async {
    if (userId != null) {
      var response = await authService.getUser(userId);
      if (response != false) {
        userModel = response;
      } else {
        msg = "Can't load profile.\nPlease try again later";
      }
    } else {
      userModel = StaticInfo.userModel.value;
    }
    showEditProfile = userModel.id == StaticInfo.userModel.value.id;
    showFriendsMenu = locator<FriendsViewModel>()
        .allFriends
        .where((element) => element.id == userModel?.id)
        .toList()
        .isNotEmpty;
    setLaoding(false);
  }

  addAsFriend() async {
    setProcessing(true);
    FriendsModel friendsModel = FriendsModel(
        id: userModel.id + StaticInfo.userModel.value.id,
        friendsIds: [userModel.id, StaticInfo.userModel.value.id],
        requestSendById: StaticInfo.userModel.value.id,
        sendByUser: StaticInfo.userModel.value,
        sendToUser: userModel);
    var response = await friendService.addFriend(friendsModel);
    if (response != false) {
      locator<FriendsViewModel>().allFriends.add(response);
      showFriendsMenu = true;
      showSnackBar("Request sent successfully");
    } else {
      showSnackBar("Please try again later");
    }
    setProcessing(false);
  }

  Future<void> removeFriend() async {
    setProcessing(true);
    await friendService.removeFriendByUserId(userModel.id);
    setProcessing(false);
  }

  void goToChat() {
    Get.to(() => ChatView(
          chat: Chat(userModel.id, userModel.name, Timestamp.now(), false, "",
              userModel.imageUrl),
        ));
  }

  Future<void> editProfile() async {
    UserModel userModel = await Get.to(() => EditProfileView());
    if (userModel != null) {
      StaticInfo.userModel.value = userModel;
    }
    notifyListeners();
  }
}
