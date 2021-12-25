import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:tajeer/app/locator.dart';
import 'package:tajeer/services/auth_service.dart';
import 'package:tajeer/view/ui/new_post/new_post_view.dart';

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
