import 'package:kollokvie/app/locator.dart';
import 'package:kollokvie/models/friends_model.dart';
import 'package:kollokvie/services/common_ui_service.dart';
import 'package:kollokvie/services/friend_service.dart';
import 'package:stacked/stacked.dart';

class FriendsRequstViewModel extends BaseViewModel with CommonUiService {
  FriendService friendService = locator<FriendService>();
  List<FriendsModel> friendsRequests = [];
  List<FriendsModel> acceptedFriends = [];

  bool isProcessing = false;

  setProcessing(bool val) {
    isProcessing = val;
    notifyListeners();
  }

  initialise(List<FriendsModel> friends) async {
    friendsRequests.addAll(friends);
    notifyListeners();
  }

  removeFriend(FriendsModel friendsModel) async {
    setProcessing(true);
    var response = await friendService.removeFriend(friendsModel);
    setProcessing(false);
    if (response != false) {
      friendsRequests.remove(friendsModel);
      showSnackBar("Friend Request cancelled");
    } else {
      showSnackBar("We're facing some problem.\nPlease try again later");
    }
  }

  acceptFriendRequest(FriendsModel friendsModel) async {
    setProcessing(true);
    await friendService.acceptFriendRequest(friendsModel);
    setProcessing(false);
    friendsRequests.remove(friendsModel);
    acceptedFriends.add(friendsModel);
    showSnackBar("Friend Request Accepted Successfully");
  }
}
