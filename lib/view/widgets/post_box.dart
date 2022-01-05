import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kollokvie/app/static_info.dart';
import 'package:kollokvie/models/post_model.dart';
import 'package:kollokvie/view/ui/home/home_viewmodel.dart';
import 'package:kollokvie/view/ui/profile/profile_view.dart';
import 'package:kollokvie/view/widgets/round_image.dart';
import 'package:kollokvie/view/widgets/viewImage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

import 'comment_view.dart';

class PostBox extends StatefulWidget {
  final PostModel post;
  final String heroId;
  final HomeViewModel model;

  PostBox(this.post, this.heroId, {this.model});

  @override
  _PostBoxState createState() => _PostBoxState();
}

class _PostBoxState extends State<PostBox> with SingleTickerProviderStateMixin {
  // PostController _controller = Get.put(PostController());
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 4,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xff707070))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RoundImage(
                imageUrl: widget.post.userModel.imageUrl,
                radius: 55,
              ),
              SizedBox(width: 5),
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: Get.width * 0.5,
                          child: AutoSizeText(
                            widget.post.userModel.name.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 12,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: const Color(0xff4c3f58),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          widget.post.userModel.fieldOfStudy +
                              " , " +
                              widget.post.userModel.age,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            color: const Color(0xff7b7b7b),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Timeago(
                              builder: (_, value) => Text(
                                value == "now" ? value : value,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 10,
                                  color: const Color(0xff7b7b7b),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              date: widget.post.timeOfPost.toDate(),
                              locale: "en",
                              allowFromNow: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PopupMenuButton(
                onSelected: (String value) async {
                  if (value == "Delete") {
                    Get.defaultDialog(
                        title: "Are you sure you want to delete this Post?",
                        middleText:
                            "it will be no more visible in your's and others feeds",
                        buttonColor: Theme.of(context).primaryColor,
                        confirmTextColor: Colors.white,
                        onCancel: () {
                          Get.back();
                        },
                        textConfirm: "  Delete  ",
                        onConfirm: () async {
                          Get.back();
                        });
                  } else if (value == 'View Profile') {
                    Get.to(() => ProfileView(
                          userId: widget.post.authorId,
                        ));
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'View Profile',
                    child: Text('View Profile'),
                  ),
                  // const PopupMenuItem<String>(
                  //   value: 'Add Friend',
                  //   child: Text('Add Friend'),
                  // ),
                  // const PopupMenuItem<String>(
                  //   value: 'Delete',
                  //   child: Text('Delete'),
                  // ),
                ],
                child: Container(
                  height: Get.width * 0.18,
                  child: Align(
                      alignment: Alignment.topRight,
                      child: Icon(Icons.more_vert)),
                ),
              )
            ],
          ),
          widget.post.subject != ""
              ? Container(
                  margin: EdgeInsets.only(top: 4),
                  child: ReadMoreText(
                    widget.post.subject,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: const Color(0xff4c3f58),
                      fontWeight: FontWeight.w600,
                    ),
                    trimLines: 1,
                    colorClickableText: Colors.red,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    moreStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ))
              : Container(),
          widget.post.postDescription != ""
              ? Container(
                  margin: EdgeInsets.only(top: 4),
                  child: ReadMoreText(
                    widget.post.postDescription,
                    trimLines: 2,
                    colorClickableText: Colors.red,
                    trimMode: TrimMode.Line,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: const Color(0xff4c3f58),
                    ),
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    moreStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                )
              : Container(),
          widget.post.imageUrl != null
              ? GestureDetector(
                  onTap: () {
                    Get.to(ViewImage(
                        imageWidget(), widget.post.id + widget.heroId));
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 4),
                    height: Get.width * 0.6,
                    width: Get.width,
                    child: Stack(
                      children: [
                        ClipRect(
                          child: Container(
                            color: Colors.white,
                            child: Center(
                              child: Stack(children: <Widget>[
                                Container(
                                  height: Get.width * 0.6,
                                  width: Get.width,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.post.imageUrl,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Positioned.fill(
                                  child: BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                    child: Container(
                                      color: Colors.black.withOpacity(0.4),
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            child: imageWidget(),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  widget.model.handleLike(widget.post);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.thumb_up,
                      color: widget.post.likes
                              .contains(StaticInfo.userModel.value.id)
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      widget.post.likes.length.toString(),
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  showCommentSheet(context, widget.post);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.comment_outlined,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      widget.post.comments.length.toString(),
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Get.defaultDialog(
                      title: "Are you sure you want to Share this Post?",
                      middleText: "",
                      buttonColor: Theme.of(context).primaryColor,
                      confirmTextColor: Colors.white,
                      onCancel: () {
                        Get.back();
                      },
                      textConfirm: "  Share  ",
                      onConfirm: () {
                        Get.back();
                        widget.model.sharePost(widget.post);
                      });
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.share,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      widget.post.shares.toString(),
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget imageWidget() {
    return CachedNetworkImage(
      imageUrl: widget.post.imageUrl,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  Future<void> goToProfile() async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(
      progressWidget: CircularProgressIndicator(),
      message: "Profile loading...",
    );
  }

  profileImage() {
    return CachedNetworkImage(
      fit: BoxFit.fill,
      imageUrl: widget.post.userModel.imageUrl,
      placeholder: (context, url) => Image.asset(
        "assets/image-loader.gif",
        fit: BoxFit.fill,
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
