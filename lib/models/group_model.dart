import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kollokvie/models/user_model.dart';

class GroupModel {
  String admin;
  String adminId;
  String groupIcon;
  String groupId;
  String groupName;
  List<String> memebers;
  String recentMessage;
  String recentMessageSender;
  String recentMessageTime;
  Timestamp lastMessageTime;
  List<UserModel> groupMembers;

  GroupModel(
      {this.admin,
      this.adminId,
      this.groupIcon,
      this.groupId,
      this.groupName,
      this.memebers,
      this.recentMessage,
      this.recentMessageSender,
      this.recentMessageTime,
      this.lastMessageTime,
      this.groupMembers});

  Map<String, dynamic> toMap() {
    return {
      'admin': this.admin,
      'adminId': this.adminId,
      'groupIcon': this.groupIcon,
      'groupId': this.groupId,
      'groupName': this.groupName,
      'memebers': this.memebers,
      'recentMessage': this.recentMessage,
      'recentMessageSender': this.recentMessageSender,
      'recentMessageTime': this.recentMessageTime,
      'lastMessageTime': this.lastMessageTime,
      'groupMembers': this.groupMembers == null
          ? null
          : this.groupMembers.map((e) => e.toMap()).toList(),
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      admin: map['admin'] as String,
      adminId: map['adminId'] as String,
      groupIcon: map['groupIcon'] as String,
      groupId: map['groupId'] as String,
      groupName: map['groupName'] as String,
      memebers: List.castFrom(map['memebers']),
      recentMessage: map['recentMessage'] as String,
      recentMessageSender: map['recentMessageSender'] as String,
      recentMessageTime: map['recentMessageTime'] as String,
      lastMessageTime: map['lastMessageTime'] as Timestamp,
      groupMembers: map['groupMembers'] == null
          ? []
          : map['groupMembers'].map<UserModel>((item) {
              return UserModel.fromMap(item);
            }).toList(),
    );
  }
}
