import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String id;
  String notificationBody;
  String notificationImage;
  String notificationTitle;
  String sentBy;
  String sentTo;
  Timestamp notificationTime;

  NotificationModel(
      {this.id,
      this.notificationBody,
      this.notificationTitle,
      this.notificationImage,
      this.sentBy,
      this.sentTo,
      this.notificationTime});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'notificationBody': this.notificationBody,
      'notificationImage': this.notificationImage,
      'sentBy': this.sentBy,
      'sentTo': this.sentTo,
      'notificationTime': this.notificationTime,
      'notificationTitle': this.notificationTitle
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      notificationBody: map['notificationBody'] as String,
      notificationTitle: map['notificationTitle'],
      notificationImage: map['notificationImage'] as String,
      sentBy: map['sentBy'] as String,
      sentTo: map['sentTo'] as String,
      notificationTime: map['notificationTime'] as Timestamp,
    );
  }
}
