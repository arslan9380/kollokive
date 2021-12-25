import 'package:stacked/stacked.dart';

class NotificationsViewModel extends BaseViewModel {
  int selectedIndex = 0;

  setSelectedIndex(int i) {
    selectedIndex = i;
    notifyListeners();
  }
}
