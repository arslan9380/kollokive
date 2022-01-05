import 'package:kollokvie/models/user_model.dart';

class FriendsModel {
  String id;
  String requestSendById;
  List<String> friendsIds;
  UserModel sendByUser;
  UserModel sendToUser;
  bool isPending;

  FriendsModel(
      {this.id,
      this.requestSendById,
      this.friendsIds,
      this.sendByUser,
      this.sendToUser,
      this.isPending = true});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'requestSendById': this.requestSendById,
      'friendsIds': this.friendsIds,
      'sendByUser': this.sendByUser.toMap(),
      'sendToUser': this.sendToUser.toMap(),
      'isPending': this.isPending,
    };
  }

  factory FriendsModel.fromMap(Map<String, dynamic> map) {
    return FriendsModel(
      id: map['id'] as String,
      requestSendById: map['requestSendById'] as String,
      friendsIds: List.castFrom(map['friendsIds']),
      sendByUser: UserModel.fromMap(map['sendByUser']),
      sendToUser: UserModel.fromMap(map['sendToUser']),
      isPending: map['isPending'] as bool,
    );
  }
}
