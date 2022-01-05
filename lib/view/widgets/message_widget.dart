import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kollokvie/models/chat.dart';
import 'package:kollokvie/view/widgets/round_image.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

class MessageWidget extends StatelessWidget {
  final Chat chat;
  final Function onDelete;

  MessageWidget({this.chat, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 12,
      ),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: [
          InkWell(
            onTap: onDelete,
            child: IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: onDelete,
            ),
          )
        ],
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x3fd3d1d8),
                blurRadius: 45,
                offset: Offset(18.21, 18.21),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundImage(
                radius: 50,
                imageUrl: chat.imageUrl,
              ),
              SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    chat.name,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  AutoSizeText(
                    chat.lastMsg == "" ? "Image sent" : chat.lastMsg,
                    presetFontSizes: [12, 10],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Timeago(
                builder: (_, value) => Text(
                  value == "now" ? value : value + " ago",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                date: chat.dateTime.toDate(),
                locale: "en_short",
                allowFromNow: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
