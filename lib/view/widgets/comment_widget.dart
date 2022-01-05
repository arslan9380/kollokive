import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:kollokvie/models/comment_model.dart';
import 'package:kollokvie/view/ui/profile/profile_view.dart';
import 'package:kollokvie/view/widgets/round_image.dart';
import 'package:kollokvie/view/widgets/viewImage.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

class CommentWidget extends StatelessWidget {
  final CommentModel commentModel;

  CommentWidget({this.commentModel});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Get.to(() => ProfileView(
                      userId: commentModel.commentById,
                    ));
              },
              child: RoundImage(
                radius: Get.width * 0.12,
                imageUrl: commentModel.commentByImage,
              ),
            ),
            SizedBox(
              width: 6,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (commentModel.commentImage != null &&
                        commentModel.commentImage != "")
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(ViewImage(
                                imageWidget(commentModel.commentImage), "123"));
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                    color: Theme.of(context).accentColor,
                                    width: 2,
                                  ),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(40.0),
                                      child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.28,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.55,
                                          child: SpinKitPulse(
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 150.0,
                                          )),
                                    ),
                                    ClipRRect(
                                        child: imageWidget(
                                            commentModel.commentImage)
                                        // Image.network(
                                        //   message.url,
                                        //   fit: BoxFit.fill,
                                        // ),
                                        // borderRadius: BorderRadius.circular(10),
                                        ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        width: Get.width * 0.75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(4),
                            bottomRight: Radius.circular(20),
                          ),
                          color: Color(0xffeff3fd),
                        ),
                        padding: const EdgeInsets.only(
                          right: 9,
                          left: 9,
                          top: 13,
                          bottom: 15,
                        ),
                        child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: commentModel.commentByName + ": ",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: commentModel.commentBody,
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 16,
                              ),
                            ),
                          ]),
                        ),
                      ),
                Timeago(
                  builder: (_, value) => Text(
                    value == "now" ? value : value + " ago",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  date: commentModel.commentTime.toDate(),
                  locale: "en_short",
                  allowFromNow: true,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget imageWidget(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (context, url) => Image.asset("assets/image-loader.gif"),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
