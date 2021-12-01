import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:tajeer/app/locator.dart';
import 'package:tajeer/services/auth_service.dart';
import 'package:tajeer/view/ui/add_item/add_item.dart';
import 'package:tajeer/view/ui/home/home_viewmodel.dart';

class UserHomeViewModel extends IndexTrackingViewModel {
  AuthService authService = locator<AuthService>();

  void logout() {
    authService.logout();
  }

  Future<void> addItem() async {
    var response = await Get.to(() => AddItemView());
    if (response != null) {
      locator<HomeViewModel>().allItems.add(response);
      locator<HomeViewModel>().updateLists();
    }
  }
}
