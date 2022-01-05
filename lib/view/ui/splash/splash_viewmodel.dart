import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kollokvie/app/locator.dart';
import 'package:kollokvie/app/static_info.dart';
import 'package:kollokvie/services/auth_service.dart';
import 'package:kollokvie/view/ui/login/login_view.dart';
import 'package:kollokvie/view/ui/user_home/user_home_view.dart';
import 'package:stacked/stacked.dart';

class SplashViewModel extends BaseViewModel {
  AuthService authService = locator<AuthService>();

  initialise() async {
    await Future.delayed(Duration(microseconds: 800));
    User currentUser = FirebaseAuth.instance.currentUser;
    print(currentUser);
    if (currentUser != null) {
      StaticInfo.userModel.value = await authService.getUser(currentUser.uid);
      Get.offAll(() => UserHomeView());
    } else {
      Get.off(LoginView());
    }
  }
}
