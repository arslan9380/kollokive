import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:tajeer/app/locator.dart';
import 'package:tajeer/app/static_info.dart';
import 'package:tajeer/models/post_model.dart';
import 'package:tajeer/services/common_ui_service.dart';
import 'package:tajeer/services/post_service.dart';
import 'package:tajeer/view/ui/home/home_viewmodel.dart';

class NewPostViewModel extends BaseViewModel with CommonUiService {
  String postImage;
  bool loading = false;
  PostService postService = locator<PostService>();

  setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  Future pickImage(bool isCamera) async {
    var picked = await ImagePicker()
        .getImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
    if (picked != null) {
      var cropped = await ImageCropper.cropImage(
        sourcePath: picked.path,
        compressQuality: 50,
        cropStyle: CropStyle.rectangle,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      if (cropped != null) {
        postImage = cropped.path;
        notifyListeners();
      }
    }
  }

  void clearImage() {
    postImage = null;
    notifyListeners();
  }

  Future<void> savePost(String subject, String description) async {
    if (subject.isEmpty) {
      showSnackBar("Please add subject");
      return;
    } else if (description.isEmpty) {
      showSnackBar("Please add description");
      return;
    }

    setLoading(true);

    PostModel postModel = PostModel(
      id: uid(),
      imageUrl: postImage,
      authorId: StaticInfo.userModel.id,
      comments: [],
      likes: [],
      postDescription: description,
      shares: 0,
      subject: subject,
      timeOfPost: Timestamp.now(),
      userModel: StaticInfo.userModel,
    );
    var response = await postService.addPost(postModel);
    setLoading(false);
    if (response != false) {
      locator<HomeViewModel>().allPost.add(response);
      // locator<HomeViewModel>().setLoading(false);
      Get.back();
      showSnackBar("Post added successfullly");
    } else {
      showSnackBar("Please try again later");
    }
  }

  void setPostImage(String path) {
    postImage = path;
    notifyListeners();
  }
}
