import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:tajeer/app/locator.dart';
import 'package:tajeer/app/static_info.dart';
import 'package:tajeer/models/user_model.dart';
import 'package:tajeer/services/auth_service.dart';
import 'package:tajeer/services/common_ui_service.dart';
import 'package:tajeer/services/image_service.dart';

class EditProfileViewModel extends BaseViewModel {
  bool isEdit = false;
  String profileImage;
  bool isProcessing = false;
  CommonUiService commonUiService = locator<CommonUiService>();
  ImageService imageService = locator<ImageService>();
  AuthService authService = locator<AuthService>();

  setProcesing(bool val) {
    isProcessing = val;
    notifyListeners();
  }

  setIsEdit() {
    isEdit = !isEdit;
    notifyListeners();
  }

  Future<void> pickImage() async {
    var picked;
    picked = await ImagePicker().getImage(source: ImageSource.gallery);
    if (picked != null) {
      var cropped = await ImageCropper.cropImage(
        sourcePath: picked.path,
        compressQuality: 100,
        cropStyle: CropStyle.circle,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      if (cropped != null) {
        profileImage = cropped.path;
        notifyListeners();
      }
    }
  }

  Future<void> updateProfile(
      String name,
      String age,
      String school,
      String city,
      String degree,
      String fieldOfStudy,
      String semester,
      String bio,
      String subject1,
      String subject2,
      String subject3,
      String subject4,
      String subject5) async {
    if (name.isEmpty ||
        age.isEmpty ||
        school.isEmpty ||
        city.isEmpty ||
        degree.isEmpty ||
        fieldOfStudy.isEmpty ||
        semester.isEmpty ||
        bio.isEmpty ||
        subject1.isEmpty ||
        subject2.isEmpty ||
        subject3.isEmpty ||
        subject4.isEmpty ||
        subject5.isEmpty) {
      commonUiService.showSnackBar("Please fill all the fields");
      return;
    }
    setProcesing(true);
    String imgUrl;
    if (profileImage != null) {
      imgUrl = await imageService.saveFiles(profileImage, "images");
    }
    UserModel userModel = UserModel(
      id: StaticInfo.userModel.id,
      imageUrl: imgUrl ?? StaticInfo.userModel.imageUrl,
      email: StaticInfo.userModel.email,
      name: name,
      age: age,
      bio: bio,
      city: city,
      degree: degree,
      fieldOfStudy: fieldOfStudy,
      school: school,
      semester: semester,
      subjects: [subject1, subject2, subject3, subject4, subject5],
    );

    await authService.saveUser(userModel);
    StaticInfo.userModel = userModel;
    setProcesing(false);
    Get.back(result: StaticInfo.userModel);
    commonUiService.showSnackBar("Profile updated successfully");
  }
}
