import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:kollokvie/app/locator.dart';
import 'package:kollokvie/app/static_info.dart';
import 'package:kollokvie/models/friends_model.dart';
import 'package:kollokvie/models/user_model.dart';
import 'package:kollokvie/services/common_ui_service.dart';
import 'package:kollokvie/services/friend_service.dart';
import 'package:kollokvie/services/post_service.dart';
import 'package:kollokvie/view/ui/friends_request/friends_request_view.dart';
import 'package:kollokvie/view/ui/search_friends/search_friends_view.dart';
import 'package:stacked/stacked.dart';

@singleton
class FriendsViewModel extends IndexTrackingViewModel with CommonUiService {
  PostService postService = locator<PostService>();
  FriendService friendService = locator<FriendService>();

  bool loading = true;
  List<FriendsModel> totalFriends = [];
  List<FriendsModel> pendingFriends = [];
  List<FriendsModel> allFriends = [];
  List<FriendsModel> filterFriends = [];

  String msg = "";

  bool isProcessing = false;

  setProcessing(bool val) {
    isProcessing = val;
    notifyListeners();
  }

  setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  initialise() async {
    setLoading(true);
    var response = await friendService.getAllFriends();
    if (response != false) {
      totalFriends = response;
      pendingFriends =
          totalFriends.where((element) => element.isPending == true).toList();
      allFriends =
          totalFriends.where((element) => element.isPending == false).toList();
      filterFriends = [];
      filterFriends.addAll(allFriends);
      print(totalFriends);
      print(pendingFriends);
      print(allFriends);
      print(filterFriends);
    } else {
      msg = "We're facing some problem.\nPlease try again later";
    }
    setLoading(false);
  }

  removeFriend(FriendsModel friendsModel) async {
    setLoading(true);
    var response = await friendService.removeFriend(friendsModel);
    if (response != false) {
      allFriends.remove(friendsModel);
      filterFriends.remove(friendsModel);
    } else {
      msg = "We're facing some problem.\nPlease try again later";
    }
    setLoading(false);
  }

  searchFriend(String keyword) {
    filterFriends = allFriends.where((element) {
      if (element.sendToUser.id != StaticInfo.userModel.value.id) {
        return element.sendToUser.name
                .toLowerCase()
                .startsWith(keyword.toLowerCase()) ||
            element.sendToUser.fieldOfStudy
                .toLowerCase()
                .startsWith(keyword.toLowerCase());
      } else {
        return element.sendByUser.name
                .toLowerCase()
                .startsWith(keyword.toLowerCase()) ||
            element.sendByUser.fieldOfStudy
                .toLowerCase()
                .startsWith(keyword.toLowerCase());
      }
    }).toList();
    notifyListeners();
  }

  Future<void> addFriends() async {
    List<UserModel> alreadyAddedOrPendingUser = [];
    totalFriends.forEach((element) {
      alreadyAddedOrPendingUser.add(
          element.requestSendById == StaticInfo.userModel.value.id
              ? element.sendToUser
              : element.sendByUser);
    });

    Get.to(() => SearchFriendsView(
          myFriends: alreadyAddedOrPendingUser,
        ));

    notifyListeners();
  }

  Future<void> goToFriendRequest() async {
    List<FriendsModel> newFriends = await Get.to(() => FriendsRequestView(
          allFriendsRequests: pendingFriends
              .where((element) =>
                  element.requestSendById != StaticInfo.userModel.value.id)
              .toList(),
        ));
    updateFriendList(newFriends);
  }

  void updateFriendList(List<FriendsModel> newFriends) {
    print(newFriends);
    newFriends.forEach((newFriend) {
      int index =
          totalFriends.indexWhere((element) => element.id == newFriend.id);
      newFriend.isPending = false;
      totalFriends[index] = newFriend;
    });
    print(totalFriends);
    pendingFriends =
        totalFriends.where((element) => element.isPending == true).toList();
    print(pendingFriends);
    allFriends =
        totalFriends.where((element) => element.isPending == false).toList();
    print(allFriends);
    filterFriends = [];
    filterFriends.addAll(allFriends);
    print(allFriends);

    notifyListeners();
  }
}
