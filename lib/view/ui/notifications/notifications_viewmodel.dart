import 'package:kollokvie/app/locator.dart';
import 'package:kollokvie/models/notification_model.dart';
import 'package:kollokvie/services/notification_service.dart';
import 'package:stacked/stacked.dart';

class NotificationsViewModel extends BaseViewModel {
  NotificationService notificationService = locator<NotificationService>();
  List<NotificationModel> myNotifications = [];

  String msg = "";
  bool isProcessing = false;
  bool loading = true;

  setProcessing(bool val) {
    isProcessing = val;
    notifyListeners();
  }

  setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  initialise() async {
    setLoading(true);
    var response = await notificationService.getAllNotifications();
    setLoading(false);
    if (response != false) {
      myNotifications = response;
    } else {
      msg = "We're facing some problem.\nPlease try again later";
    }
  }

  Future<void> deleteNotifiction(int index) async {
    setProcessing(true);
    var response =
        await notificationService.deleteNotification(myNotifications[index]);
    setProcessing(false);
    if (response != false) {
      myNotifications.removeAt(index);
      notifyListeners();
    } else {
      msg = "We're facing some problem.\nPlease try again later";
    }
  }
}
