import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String id;
  String commentBody;
  String commentImage;
  String commentByName;
  String commentByImage;
  String commentById;
  Timestamp commentTime;

  CommentModel(
      {this.id,
      this.commentBody,
      this.commentImage,
      this.commentByName,
      this.commentByImage,
      this.commentById,
      this.commentTime});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'commentBody': this.commentBody,
      'commentImage': this.commentImage,
      'commentByName': this.commentByName,
      'commentByImage': this.commentByImage,
      'commentById': this.commentById,
      'commentTime': this.commentTime,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as String,
      commentBody: map['commentBody'] as String,
      commentImage: map['commentImage'] as String,
      commentByName: map['commentByName'] as String,
      commentByImage: map['commentByImage'] as String,
      commentById: map['commentById'] as String,
      commentTime: map['commentTime'] as Timestamp,
    );
  }
}
