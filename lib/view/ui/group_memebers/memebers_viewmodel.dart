import 'package:injectable/injectable.dart';
import 'package:kollokvie/app/locator.dart';
import 'package:kollokvie/models/user_model.dart';
import 'package:kollokvie/services/common_ui_service.dart';
import 'package:kollokvie/services/friend_service.dart';
import 'package:kollokvie/services/post_service.dart';
import 'package:stacked/stacked.dart';

@singleton
class MemebersViewModel extends IndexTrackingViewModel with CommonUiService {
  PostService postService = locator<PostService>();
  FriendService friendService = locator<FriendService>();

  bool loading = false;
  List<UserModel> allFriends = [];
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
      allFriends = response;
    } else {
      msg = "We're facing some problem.\nPlease try again later";
    }
    setLoading(false);
  }

  // removeFriend(UserModel userModel) async {
  //   setLoading(true);
  //
  //   var response = await friendService.removeFriend(userModel);
  //   if (response != false) {
  //     allFriends.remove(userModel);
  //   } else {
  //     msg = "We're facing some problem.\nPlease try again later";
  //   }
  //   setLoading(false);
  // }
}
