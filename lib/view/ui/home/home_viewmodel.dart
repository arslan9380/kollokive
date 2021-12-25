import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import 'package:tajeer/app/locator.dart';
import 'package:tajeer/app/static_info.dart';
import 'package:tajeer/models/post_model.dart';
import 'package:tajeer/services/common_ui_service.dart';
import 'package:tajeer/services/post_service.dart';

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
    if (post.likes.contains(StaticInfo.userModel.id)) {
      post.likes.remove(StaticInfo.userModel.id);
      postService.likePost(post);
    } else {
      post.likes.add(StaticInfo.userModel.id);
      postService.unlikePost(post);
    }

    int index = allPost.indexWhere((element) => element.id == post.id);
    allPost[index] = post;
    notifyListeners();
  }
}
