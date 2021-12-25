import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tajeer/models/comment_model.dart';
import 'package:tajeer/models/user_model.dart';

class PostModel {
  String id;
  String subject;
  String postDescription;
  String imageUrl;
  List<String> likes;
  int shares;
  List<CommentModel> comments;
  String authorId;
  Timestamp timeOfPost;
  UserModel userModel;
  UserModel sharedOf;

  PostModel(
      {this.id,
      this.authorId,
      this.subject,
      this.postDescription,
      this.imageUrl,
      this.likes,
      this.shares,
      this.comments,
      this.timeOfPost,
      this.userModel});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'subject': this.subject,
      'postDescription': this.postDescription,
      'imageUrl': this.imageUrl,
      'likes': this.likes,
      'shares': this.shares,
      'comments': this.comments == null
          ? []
          : this.comments.map((e) => e.toMap()).toList(),
      'authorId': this.authorId,
      'timeOfPost': this.timeOfPost,
      'userModel': this.userModel.toMap(),
      'sharedOf': this.sharedOf == null ? null : this.sharedOf.toMap(),
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] as String,
      subject: map['subject'] as String,
      postDescription: map['postDescription'] as String,
      imageUrl: map['imageUrl'] as String,
      likes: List.castFrom(map['likes']),
      shares: map['shares'] as int,
      comments: map['comments'].map<CommentModel>((item) {
        return CommentModel.fromMap(item);
      }).toList(),
      authorId: map['authorId'] as String,
      timeOfPost: map['timeOfPost'] as Timestamp,
      userModel:
          map['userModel'] != null ? UserModel.fromMap(map['userModel']) : null,
    );
  }
}
