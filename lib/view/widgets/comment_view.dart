import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kollokvie/app/locator.dart';
import 'package:kollokvie/app/static_info.dart';
import 'package:kollokvie/models/comment_model.dart';
import 'package:kollokvie/models/post_model.dart';
import 'package:kollokvie/services/common_ui_service.dart';
import 'package:kollokvie/services/post_service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'comment_widget.dart';

class CommentView extends StatefulWidget {
  PostModel postModel;

  CommentView(this.postModel);

  @override
  _CommentViewState createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  TextEditingController msgCon = TextEditingController();
  FocusNode msgFocus = FocusNode();
  String commentImage;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      color: Theme.of(context).primaryColor.withOpacity(0.4),
      child: Column(
        children: [
          SizedBox(
            height: 12,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: ListView.builder(
                    itemCount: widget.postModel.comments.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return CommentWidget(
                        commentModel: widget.postModel.comments[index],
                      );
                    }),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27.5),
                        border: Border.all(
                            color: Theme.of(context).primaryColorLight)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 2,
                        ),
                        Flexible(
                          child: TextField(
                            maxLines: null,
                            controller: msgCon,
                            focusNode: msgFocus,
                            onTap: () {},
                            decoration: InputDecoration(
                              hintText: "Write a Comment…",
                              hintStyle: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 16,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        InkWell(
                          onTap: () {
                            {
                              var picked;
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      title: Text('Pick one source for image'),
                                      actions: [
                                        FlatButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              picked = await ImagePicker()
                                                  .getImage(
                                                      source:
                                                          ImageSource.gallery);
                                              if (picked != null) {
                                                var cropped = await ImageCropper
                                                    .cropImage(
                                                  sourcePath: picked.path,
                                                  compressQuality: 70,
                                                  aspectRatio: CropAspectRatio(
                                                      ratioX: 1, ratioY: 1),
                                                );
                                                if (cropped != null)
                                                  setState(() {
                                                    commentImage = cropped.path;
                                                  });

                                                sendComment();
                                              }
                                            },
                                            child: Text(
                                              'Gallery',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            )),
                                        FlatButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              picked = await ImagePicker()
                                                  .getImage(
                                                      source:
                                                          ImageSource.camera);
                                              if (picked != null) {
                                                var cropped = await ImageCropper
                                                    .cropImage(
                                                  sourcePath: picked.path,
                                                  compressQuality: 40,
                                                  aspectRatio: CropAspectRatio(
                                                      ratioX: 1, ratioY: 1),
                                                );
                                                if (cropped != null)
                                                  setState(() {
                                                    commentImage = cropped.path;
                                                  });
                                                sendComment();
                                              }
                                            },
                                            child: Text('Camera',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor)))
                                      ],
                                    );
                                  });
                            }
                          },
                          child: Icon(
                            Icons.camera_alt,
                            color: Theme.of(context).primaryColorDark,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 5),
                InkWell(
                  onTap: sendComment,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  sendComment() async {
    CommentModel commentModel = CommentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        commentBody: msgCon.text,
        commentImage: commentImage,
        commentById: StaticInfo.userModel.value.id,
        commentByImage: StaticInfo.userModel.value.imageUrl,
        commentByName: StaticInfo.userModel.value.name,
        commentTime: Timestamp.now());
    setState(() {
      loading = true;
    });
    var response =
        await locator<PostService>().addComment(widget.postModel, commentModel);
    setState(() {
      loading = false;
    });
    if (response != false) {
      widget.postModel.comments.add(response);
      commentImage = null;
      msgCon.clear();
      msgFocus?.unfocus();
      setState(() {});
    } else {
      locator<CommonUiService>().showSnackBar("Please try again later");
    }
  }
}

showCommentSheet(BuildContext context, PostModel post) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(6),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: CommentView(post),
        );
      });
}
