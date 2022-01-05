import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:kollokvie/app/locator.dart';
import 'package:kollokvie/models/user_model.dart';
import 'package:kollokvie/services/auth_service.dart';
import 'package:kollokvie/services/common_ui_service.dart';
import 'package:kollokvie/view/ui/signup/pages/page_four.dart';
import 'package:kollokvie/view/ui/signup/pages/page_three.dart';
import 'package:kollokvie/view/ui/signup/pages/page_two.dart';
import 'package:kollokvie/view/ui/signup/pages/summary_view.dart';
import 'package:kollokvie/view/ui/user_home/user_home_view.dart';
import 'package:stacked/stacked.dart';

@singleton
class SignUpViewModel extends IndexTrackingViewModel {
  AuthService authService = locator<AuthService>();
  CommonUiService commonUiService = locator<CommonUiService>();
  bool loading = false;
  UserModel userModel = UserModel();
  String userPassword;

  String profileImage;

  setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  moveToPageTwo(String email, String password, String confirmPassword) {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      commonUiService.showSnackBar("Please fill all the details");
      return;
    } else if (password.length < 6) {
      commonUiService.showSnackBar("Password should be at least 6 character");
      return;
    } else if (password != confirmPassword) {
      commonUiService.showSnackBar("Password does not match.");
      return;
    } else if (!GetUtils.isEmail(email)) {
      commonUiService.showSnackBar("Invalid Email Address");
      return;
    }
    userModel.email = email;
    userPassword = password;
    Get.to(() => PageTwo());
  }

  moveToPageThree(String school, String city, String degree,
      String fieldOfStudy, String semester) {
    if (school.isEmpty ||
        city.isEmpty ||
        degree.isEmpty ||
        fieldOfStudy.isEmpty ||
        semester.isEmpty) {
      commonUiService.showSnackBar("Please fill all the details");
      return;
    }
    userModel.school = school;
    userModel.city = city;
    userModel.degree = degree;
    userModel.fieldOfStudy = fieldOfStudy;
    userModel.semester = semester;
    Get.to(() => PageThree());
  }

  signUpUser() async {
    // setLoading(true);
    var result = await authService.signUp(userModel, userPassword);
    // setLoading(false);
    if (result == "success") {
      Get.offAll(() => UserHomeView());
    } else {
      if (result == AuthStatus.ERROR_INVALID_EMAIL) {
        commonUiService.showSnackBar("Email address is invalid");
      } else if (result == AuthStatus.ERROR_WEAK_PASSWORD) {
        commonUiService
            .showSnackBar("Password should be at least 6 characters");
      } else if (result == AuthStatus.ERROR_EMAIL_ALREADY_IN_USE) {
        commonUiService.showSnackBar("Email already in use");
      } else {
        commonUiService.showSnackBar(result);
      }
    }
  }

  Future<void> pickImage() async {
    var picked;
    picked = await ImagePicker().getImage(source: ImageSource.gallery);
    if (picked != null) {
      var cropped = await ImageCropper.cropImage(
        sourcePath: picked.path,
        compressQuality: 50,
        cropStyle: CropStyle.circle,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      if (cropped != null) {
        profileImage = cropped.path;
        notifyListeners();
      }
    }
  }

  void moveToPageFour(String name, String age, String bio) {
    if (profileImage == null) {
      commonUiService.showSnackBar("Please pick your image");
      return;
    } else if (name.isEmpty || age.isEmpty) {
      commonUiService.showSnackBar("Please fill all fields");
      return;
    }

    userModel.imageUrl = profileImage;
    userModel.age = age;
    userModel.name = name;
    userModel.bio = bio;
    Get.to(() => PageFour());
  }

  void moveToSummary(String subject1, String subject2, String subject3,
      String subject4, String subject5) {
    if (subject1.isEmpty ||
        subject2.isEmpty ||
        subject3.isEmpty ||
        subject4.isEmpty ||
        subject5.isEmpty) {
      commonUiService.showSnackBar("Please fill all fields");
      return;
    }
    userModel.subjects = [];
    userModel.subjects.add(subject1);
    userModel.subjects.add(subject2);
    userModel.subjects.add(subject3);
    userModel.subjects.add(subject4);
    userModel.subjects.add(subject5);
    Get.to(() => SummaryView());
  }
}
