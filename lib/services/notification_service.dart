import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:kollokvie/app/locator.dart';
import 'package:kollokvie/app/static_info.dart';
import 'package:kollokvie/models/notification_model.dart';

import 'image_service.dart';

@lazySingleton
class NotificationService {
  String _notificationKey = "notifications";
  ImageService imageService = locator<ImageService>();
  static final Client client = Client();

  Future addNotification(NotificationModel notificationModel) async {
    try {
      if (notificationModel.notificationImage != null) {
        if (!notificationModel.notificationImage.contains("http")) {
          String url = await imageService.saveFiles(
              notificationModel.notificationImage, "Images");
          if (url == null) return;
          notificationModel.notificationImage = url;
        }
      }

      await FirebaseFirestore.instance
          .collection(_notificationKey)
          .doc(notificationModel.id)
          .set(notificationModel.toMap(), SetOptions(merge: true));
      return notificationModel;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future getAllNotifications() async {
    List<NotificationModel> myNotifications = [];
    try {
      var result = await FirebaseFirestore.instance
          .collection(_notificationKey)
          .where("sentTo", isEqualTo: StaticInfo.userModel.value.id)
          .orderBy("notificationTime", descending: true)
          .get();
      print(result.docs.length);
      for (var doc in result.docs) {
        myNotifications.add(NotificationModel.fromMap(doc.data()));
      }
      print(myNotifications.length);
      return myNotifications;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future deleteNotification(NotificationModel notificationModel) async {
    try {
      await FirebaseFirestore.instance
          .collection(_notificationKey)
          .doc(notificationModel.id)
          .delete();
      return notificationModel;
    } catch (e) {
      print(e);
      return false;
    }
  }

  sendNotification(String fcmToken, String body, String title) {
    return client.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      body: json.encode({
        'to': '$fcmToken',
        'notification': {
          'body': '$body',
          'title': '$title',
        },
        'priority': 'high',
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done',
        },
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAg5XgLXk:APA91bEG3eNSrbHKJiFDe3IjUkB8xuv25TccjyyUdU_CkDeNeWQUDZnbdouyuYXKq-ILGhaUV5U_dIQfH32GNQp6CJrYKZ4VtoQhE3AWAHoQi3qKbWLQ7OPPXWovOh8d9iNfftr_0t3n',
      },
    );
  }

  getFcmToken() async {
    String fcm = '';
    fcm = await FirebaseMessaging.instance.getToken();
    return fcm;
  }
}
