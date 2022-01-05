import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:kollokvie/app/static_info.dart';
import 'package:kollokvie/models/message.dart';
import 'package:kollokvie/view/widgets/round_image.dart';
import 'package:kollokvie/view/widgets/viewImage.dart';

class MsgReceiveWidget extends StatelessWidget {
  final Message message;

  MsgReceiveWidget({this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoundImage(
              radius: Get.width * 0.12,
              imageUrl: message.senderImageUrl,
            ),
            SizedBox(
              width: 6,
            ),
            message.image
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(ViewImage(imageWidget(message), "123"));
                      },
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: message.senderUid !=
                                        StaticInfo.userModel.value.id
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).accentColor,
                                width: 2,
                              ),
                            ),
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(40.0),
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.28,
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      child: SpinKitPulse(
                                        color: Theme.of(context).primaryColor,
                                        size: 150.0,
                                      )),
                                ),
                                ClipRRect(child: imageWidget(message)
                                    // Image.network(
                                    //   message.url,
                                    //   fit: BoxFit.fill,
                                    // ),
                                    // borderRadius: BorderRadius.circular(10),
                                    ),
                              ],
                            ),
                          ),
                          Text(getTime(message.msgId)
                              .toString()
                              .substring(11, 16)),
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
                    child: Text(
                      message.msgBody,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  getTime(String msg) {
    var s = DateTime.fromMicrosecondsSinceEpoch(int.parse(msg)).toLocal();
    return s;
  }

  Widget imageWidget(Message message) {
    return CachedNetworkImage(
      imageUrl: message.url,
      fit: BoxFit.cover,
      placeholder: (context, url) => Image.asset("assets/image-loader.gif"),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
