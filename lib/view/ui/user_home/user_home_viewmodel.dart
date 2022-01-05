import 'package:get/get.dart';
import 'package:kollokvie/app/locator.dart';
import 'package:kollokvie/services/auth_service.dart';
import 'package:kollokvie/view/ui/new_post/new_post_view.dart';
import 'package:stacked/stacked.dart';

class UserHomeViewModel extends IndexTrackingViewModel {
  AuthService authService = locator<AuthService>();

  void logout() {
    authService.logout();
  }

  Future<void> addNewPost() async {
    await Get.to(() => NewPost());
    notifyListeners();
  }
}
