import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tajeer/app/static_info.dart';
import 'package:tajeer/models/message.dart';
import 'package:tajeer/view/widgets/viewImage.dart';

class MsgSendWidget extends StatelessWidget {
  final Message message;

  MsgSendWidget({this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: message.image
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
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          color: message.senderUid != StaticInfo.userModel.id
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
                                    MediaQuery.of(context).size.height * 0.28,
                                width: MediaQuery.of(context).size.width * 0.55,
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
                    Text(getTime(message.msgId)),
                  ],
                ),
              ),
            )
          : Container(
              width: Get.width * 0.75,
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(4),
                  bottomLeft: Radius.circular(20),
                ),
                color: Theme.of(context).primaryColor,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              child: Text(
                message.msgBody,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
    );
  }

  getTime(String msg) {
    DateTime date =
        DateTime.fromMicrosecondsSinceEpoch(int.parse(msg)).toLocal();
    return DateFormat("d MMM hh:mm a").format(date).toString();
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
