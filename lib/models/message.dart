import 'package:flutter/foundation.dart';

class Message {
  String msgId, msgBody, senderUid, receiverUid;
  String usersUidsMerge;
  bool image;
  String url;
  String senderImageUrl;
  dynamic serverTime;

  Message({
    @required this.msgId,
    @required this.msgBody,
    @required this.senderUid,
    @required this.receiverUid,
    @required this.usersUidsMerge,
    @required this.image,
    @required this.url,
    @required this.senderImageUrl,
    this.serverTime,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return new Message(
        msgId: map['msgId'] as String,
        msgBody: map['msgBody'] as String,
        senderUid: map['senderUid'] as String,
        receiverUid: map['receiverUid'] as String,
        usersUidsMerge: map['usersUidsMerge'] as String,
        image: map['image'] as bool,
        senderImageUrl: map['senderImageUrl'],
        url: map['url'] as String,
        serverTime: map['serverTime']);
  }

  Map<String, dynamic> toMap() {
    return {
      'msgId': this.msgId,
      'msgBody': this.msgBody,
      'senderUid': this.senderUid,
      'receiverUid': this.receiverUid,
      'usersUidsMerge': this.usersUidsMerge,
      'image': this.image,
      'url': this.url,
      'senderImageUrl': this.senderImageUrl,
      'serverTime': this.serverTime,
    };
  }

  @override
  String toString() {
    return 'Message{msgId: $msgId, msgBody: $msgBody, senderUid: $senderUid, receiverUid: $receiverUid, usersUidsMerge: $usersUidsMerge}';
  }
}
