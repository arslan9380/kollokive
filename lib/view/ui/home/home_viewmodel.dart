import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:kollokvie/app/locator.dart';
import 'package:kollokvie/app/static_info.dart';
import 'package:kollokvie/models/post_model.dart';
import 'package:kollokvie/services/common_ui_service.dart';
import 'package:kollokvie/services/post_service.dart';
import 'package:stacked/stacked.dart';

@singleton
class HomeViewModel extends IndexTrackingViewModel with CommonUiService {
  PostService postService = locator<PostService>();

  bool loading = true;
  List<PostModel> allPost = [];
  String msg = "";

  bool isProcessing = false;

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
    var response = await postService.getAllPost();
    if (response != false) {
      allPost = response;
    } else {
      msg = "We're facing some problem.\nPlease try again later";
    }
    setLoading(false);
  }

  getData() async {
    var response = await postService.getAllPost();
    setLoading(false);
    if (response != false) {
      allPost = [];
      allPost.addAll(response);
    } else {
      msg = "We're facing some problem.\nPlease try again later";
    }
  }

  void handleLike(PostModel post) {
    if (post.likes.contains(StaticInfo.userModel.value.id)) {
      post.likes.remove(StaticInfo.userModel.value.id);
      postService.unlikePost(post);
    } else {
      post.likes.add(StaticInfo.userModel.value.id);
      postService.likePost(post);
    }

    int index = allPost.indexWhere((element) => element.id == post.id);
    allPost[index] = post;
    notifyListeners();
  }

  Future<void> sharePost(PostModel post) async {
    setProcessing(true);
    await postService.addShare(post);
    PostModel postModel = PostModel.fromMap(post.toMap());
    postModel.id = uid();
    postModel.comments = [];
    postModel.likes = [];
    postModel.shares = 0;
    postModel.sharedOf = post.userModel;
    postModel.timeOfPost = Timestamp.now();
    postModel.userModel = StaticInfo.userModel.value;
    var response = await postService.addPost(postModel);
    setProcessing(false);
    if (response != false) {
      allPost.insert(0, post);
      notifyListeners();
    } else {
      showSnackBar("Please try again later");
    }
  }
}
