import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:tajeer/app/locator.dart';
import 'package:tajeer/models/group_model.dart';
import 'package:tajeer/models/user_model.dart';
import 'package:tajeer/services/common_ui_service.dart';
import 'package:tajeer/services/group_chat_service.dart';

class MyGroupsViewModel extends IndexTrackingViewModel with CommonUiService {
  GroupChatService groupChatService = locator<GroupChatService>();

  bool loading = true;
  List<GroupModel> myGroups = [];
  List<GroupModel> myGroupsWhereUserNotJoined = [];

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

  initialise(UserModel user) async {
    setLoading(true);
    var response = await groupChatService.getMyGroups();
    if (response != false) {
      myGroups = response;
      myGroupsWhereUserNotJoined = myGroups
          .skipWhile((value) => value.memebers.contains(user.id))
          .toList();
    } else {
      msg = "We're facing some problem.\nPlease try again later";
    }
    setLoading(false);
  }

  Future<void> addToGroup(GroupModel myGroup, UserModel user) async {
    setProcessing(true);
    await groupChatService.addToGroup(user, myGroup);
    setProcessing(false);
    Get.back();
    showSnackBar("Hurray! Added to group Successfully");
  }
}
