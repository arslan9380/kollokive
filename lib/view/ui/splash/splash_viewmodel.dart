import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:tajeer/view/ui/login/login_view.dart';

class SplashViewModel extends BaseViewModel {
  initialise() async {
    await Future.delayed(Duration(seconds: 2));
    Get.off(LoginView());
  }
}
