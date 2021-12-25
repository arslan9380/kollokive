import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_editor_pro_ander/image_editor_pro_ander.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';
import 'package:tajeer/models/post_model.dart';
import 'package:tajeer/view/ui/new_post/new_post_viewmodel.dart';
import 'package:tajeer/view/widgets/new_post_bottom_widget.dart';
import 'package:tajeer/view/widgets/new_post_image_widget.dart';

class NewPost extends StatefulWidget {
  final PostModel post;

  NewPost({this.post});

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  TextEditingController subjectController = TextEditingController();
  TextEditingController descriptionCon = TextEditingController();
  final descriptionNode = FocusNode();
  final titleNode = FocusNode();
  String submitButton = "Post      ";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewPostViewModel>.reactive(
        viewModelBuilder: () => NewPostViewModel(),
        builder: (context, model, child) {
          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: IconTheme.of(context).color,
                    )),
                backgroundColor: Colors.white,
                centerTitle: true,
                title: Text(
                  "New post".toUpperCase(),
                  style: TextStyle(
                      color: IconTheme.of(context).color, fontSize: 24),
                ),
                actions: [
                  Center(
                      child: GestureDetector(
                    onTap: () async {
                      descriptionNode.unfocus();
                      titleNode.unfocus();
                      model.savePost(
                          subjectController.text, descriptionCon.text);
                    },
                    child: Text(
                      submitButton,
                      style: TextStyle(
                          color: IconTheme.of(context).color, fontSize: 13),
                    ),
                  ))
                ],
              ),
              body: ModalProgressHUD(
                inAsyncCall: model.loading,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 20,
                        ),
                        child: Container(
                          margin: EdgeInsets.only(top: Get.width * 0.05),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffA4A4A4),
                                width: 1.0,
                              ),
                              top: BorderSide(
                                color: Color(0xffA4A4A4),
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              TextField(
                                focusNode: titleNode,
                                controller: subjectController,
                                maxLines: null,
                                textAlign: TextAlign.start,
                                maxLength: 20,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(20)
                                ],
                                style: TextStyle(
                                    color: Theme.of(context).iconTheme.color,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "Subject",
                                  hintStyle: TextStyle(
                                      color: Color(0xffA7A0AD),
                                      fontSize: 19,
                                      fontWeight: FontWeight.w800),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: Get.height * 0.35,
                        ),
                        child: Container(
                          margin: EdgeInsets.only(top: Get.width * 0.05),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffA4A4A4),
                                width: 1.0,
                              ),
                              top: BorderSide(
                                color: Color(0xffA4A4A4),
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              TextField(
                                focusNode: descriptionNode,
                                controller: descriptionCon,
                                maxLines: null,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Theme.of(context).iconTheme.color,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                ),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "What's on your mind?",
                                  hintStyle: TextStyle(
                                      color: Color(0xffA7A0AD), fontSize: 18),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                ),
                              ),
                              if (model.postImage != null)
                                NewPostImageWidget(model),
                              SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              resizeToAvoidBottomInset: false,
              floatingActionButton: model.postImage == null
                  ? null
                  : FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.imagesearch_roller),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ImageEditorProAnder(
                            appBarColor: Theme.of(context).primaryColor,
                            bottomBarColor: Theme.of(context).primaryColor,
                            file: File(model.postImage),
                          );
                        })).then((geteditimage) {
                          if (geteditimage != null) {
                            File editedImage = geteditimage;
                            model.setPostImage(editedImage.path);
                          }
                        }).catchError((er) {
                          print(er);
                        });
                      },
                    ),
              bottomNavigationBar: NewPostBottomWidget(model));
        });
  }
}
