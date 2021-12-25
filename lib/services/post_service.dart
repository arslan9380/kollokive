import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tajeer/app/locator.dart';
import 'package:tajeer/app/static_info.dart';
import 'package:tajeer/models/comment_model.dart';
import 'package:tajeer/models/item_model.dart';
import 'package:tajeer/models/post_model.dart';

import 'image_service.dart';

@lazySingleton
class PostService {
  String _postKey = "posts";
  ImageService imageService = locator<ImageService>();

  Future addPost(PostModel post) async {
    try {
      if (post.imageUrl != null) {
        if (!post.imageUrl.contains("http")) {
          String url = await imageService.saveFiles(post.imageUrl, "Images");
          if (url == null) return;
          post.imageUrl = url;
        }
      }

      await FirebaseFirestore.instance
          .collection(_postKey)
          .doc(post.id)
          .set(post.toMap(), SetOptions(merge: true));
      return post;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future getAllPost() async {
    List<PostModel> allPost = [];
    try {
      var result = await FirebaseFirestore.instance
          .collection(_postKey)
          .orderBy("timeOfPost", descending: true)
          .get();
      for (var doc in result.docs) {
        allPost.add(PostModel.fromMap(doc.data()));
      }
      return allPost;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future getItemsById(String id) async {
    List<ItemModel> allEvents = [];
    try {
      var result = await FirebaseFirestore.instance
          .collection(_postKey)
          .where("addedById", isEqualTo: id)
          .get();
      for (var doc in result.docs) {
        allEvents.add(ItemModel.fromMap(doc.data()));
      }
      print(allEvents.length);
      return allEvents;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future deleteItem(ItemModel itemModel) async {
    try {
      await FirebaseFirestore.instance
          .collection(_postKey)
          .doc(itemModel.id)
          .delete();
      return ItemModel;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> likePost(PostModel post) async {
    try {
      await FirebaseFirestore.instance.collection(_postKey).doc(post.id).set({
        "likes": FieldValue.arrayUnion([StaticInfo.userModel.id])
      }, SetOptions(merge: true));
      return post;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> unlikePost(PostModel post) async {
    try {
      await FirebaseFirestore.instance.collection(_postKey).doc(post.id).set({
        "likes": FieldValue.arrayRemove([StaticInfo.userModel.id])
      }, SetOptions(merge: true));
      return post;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future addComment(PostModel post, CommentModel commentModel) async {
    try {
      if (commentModel.commentImage != null) {
        if (!commentModel.commentImage.contains("http")) {
          String url =
              await imageService.saveFiles(commentModel.commentImage, "Images");
          if (url == null) return;
          commentModel.commentImage = url;
        }
      }

      await FirebaseFirestore.instance.collection(_postKey).doc(post.id).set({
        "comments": FieldValue.arrayUnion([commentModel.toMap()])
      }, SetOptions(merge: true));
      return commentModel;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future addShare(PostModel post) async {
    try {
      await FirebaseFirestore.instance
          .collection(_postKey)
          .doc(post.id)
          .set({"shares": FieldValue.increment(1)}, SetOptions(merge: true));
      return post;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
