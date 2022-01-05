import 'package:kollokvie/app/locator.dart';
import 'package:kollokvie/app/static_info.dart';
import 'package:kollokvie/models/friends_model.dart';
import 'package:kollokvie/models/user_model.dart';
import 'package:kollokvie/services/auth_service.dart';
import 'package:kollokvie/services/common_ui_service.dart';
import 'package:kollokvie/services/friend_service.dart';
import 'package:stacked/stacked.dart';

class SearchFriendsViewModel extends BaseViewModel with CommonUiService {
  FriendService friendService = locator<FriendService>();
  AuthService authService = locator<AuthService>();

  bool loading = true;
  List<UserModel> allUsers = [];
  List<UserModel> filterUsers = [];
  List<UserModel> addedFriends = [];

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

  initialise(List<UserModel> myFriends) async {
    print(myFriends[0].name);
    setLoading(true);
    var response = await authService.getAllUser();
    if (response != false) {
      allUsers = response;
      myFriends.forEach((friend) {
        allUsers.removeWhere((user) => user.id == friend.id);
      });

      filterUsers = [];
      filterUsers.addAll(allUsers);
    } else {
      msg = "We're facing some problem.\nPlease try again later";
    }
    setLoading(false);
  }

  searchFriend(String keyword) {
    filterUsers = allUsers
        .where((element) =>
            element.name.toLowerCase().startsWith(keyword.toLowerCase()) ||
            element.fieldOfStudy
                .toLowerCase()
                .startsWith(keyword.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future<void> addFriend(UserModel friend) async {
    setProcessing(true);

    FriendsModel friendsModel = FriendsModel(
        id: friend.id + StaticInfo.userModel.value.id,
        friendsIds: [friend.id, StaticInfo.userModel.value.id],
        requestSendById: StaticInfo.userModel.value.id,
        sendByUser: StaticInfo.userModel.value,
        sendToUser: friend);

    var response = await friendService.addFriend(friendsModel);
    setProcessing(false);
    if (response != false) {
      filterUsers.remove(friend);
      addedFriends.add(friend);
      showSnackBar("Friend added Successfully");
    } else {
      showSnackBar("Please try again later");
    }
  }
}
