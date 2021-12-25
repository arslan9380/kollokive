import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:tajeer/app/locator.dart';
import 'package:tajeer/app/static_info.dart';
import 'package:tajeer/models/group_model.dart';
import 'package:tajeer/services/common_ui_service.dart';
import 'package:tajeer/services/group_chat_service.dart';

class CreateGroupViewModel extends BaseViewModel {
  String itemImage = "";
  TextEditingController catCon = TextEditingController();
  CommonUiService commonUiService = locator<CommonUiService>();
  GroupChatService groupChatService = locator<GroupChatService>();
  bool loading = false;

  String selectedCat = "";
  bool isExpanded = false;

  setExpanded() {
    isExpanded = !isExpanded;
    notifyListeners();
  }

  setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  Future<void> pickImage() async {
    var picked;
    picked = await ImagePicker().getImage(source: ImageSource.gallery);
    if (picked != null) {
      var cropped = await ImageCropper.cropImage(
        sourcePath: picked.path,
        compressQuality: 100,
        cropStyle: CropStyle.rectangle,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      if (cropped != null) {
        itemImage = cropped.path;
        notifyListeners();
      }
    }
  }

  Future<void> createGroup(String title) async {
    if (title.isEmpty) {
      commonUiService.showSnackBar("Please Enter Group Name");
      return;
    }

    GroupModel groupModel = GroupModel(
        groupId: DateTime.now().millisecondsSinceEpoch.toString(),
        groupIcon: itemImage,
        groupName: title,
        admin: StaticInfo.userModel.name,
        adminId: StaticInfo.userModel.id,
        memebers: [StaticInfo.userModel.id],
        lastMessageTime: Timestamp.now(),
        recentMessage: "",
        recentMessageSender: "",
        recentMessageTime: "",
        groupMembers: [StaticInfo.userModel]);

    setLoading(true);
    var result = await groupChatService.createMyGroup(groupModel);
    setLoading(false);
    Get.back();
    if (result != false) {
      commonUiService.showSnackBar("Group Created Successfully");
    } else {
      commonUiService.showSnackBar("Please try again later");
    }
  }
}
