import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:tajeer/app/locator.dart';
import 'package:tajeer/app/static_info.dart';
import 'package:tajeer/models/chat.dart';
import 'package:tajeer/models/user_model.dart';
import 'package:tajeer/services/auth_service.dart';
import 'package:tajeer/services/common_ui_service.dart';
import 'package:tajeer/services/friend_service.dart';
import 'package:tajeer/view/ui/chat/chat_view.dart';
import 'package:tajeer/view/ui/edit_profile/edit_profile_view.dart';
import 'package:tajeer/view/ui/friends/friends_viewmodel.dart';

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
      userModel = StaticInfo.userModel;
    }
    showEditProfile = userModel.id == StaticInfo.userModel.id;
    showFriendsMenu = locator<FriendsViewModel>()
        .allFriends
        .where((element) => element.id == userModel?.id)
        .toList()
        .isNotEmpty;
    setLaoding(false);
  }

  addAsFriend() async {
    setProcessing(true);
    var response = await friendService.addFriend(userModel);
    if (response != false) {
      locator<FriendsViewModel>().allFriends.add(response);
      showFriendsMenu = true;
      showSnackBar("Friend added successfully");
    } else {
      showSnackBar("Please try again later");
    }
    setProcessing(false);
  }

  Future<void> removeFriend() async {
    setProcessing(true);
    await locator<FriendsViewModel>().removeFriend(userModel);
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
      StaticInfo.userModel = userModel;
    }
    notifyListeners();
  }
}
