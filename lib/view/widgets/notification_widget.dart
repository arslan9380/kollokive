import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:tajeer/view/widgets/rect_image.dart';

class NotificationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(bottom: Get.height * 0.025, right: Get.width * 0.03),
      child: Column(
        children: [
          Opacity(
            opacity: 0.2,
            child: Container(
              height: 2,
              width: Get.width,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          Container(
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              closeOnScroll: true,
              secondaryActions: [
                IconSlideAction(
                  icon: Icons.delete,
                  color: Colors.transparent,
                  foregroundColor: Theme.of(context).primaryColor,
                )
              ],
              child: Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RectImage(
                      width: 42,
                      height: 42,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: Get.width,
                            child: AutoSizeText(
                              "Jhonny Bravo scheduled an event named “Happy Hour” on 08 September. Click to set reminder",
                              presetFontSizes: [14],
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          AutoSizeText(
                            "2 hr",
                            style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                    //styleName: 16px medium;
                  ],
                ),
              ),
            ),
          ),
          Opacity(
            opacity: 0.2,
            child: Container(
              height: 2,
              width: Get.width,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
        ],
      ),
    );
  }
}
