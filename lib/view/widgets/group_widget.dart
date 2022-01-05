import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:kollokvie/app/static_info.dart';
import 'package:kollokvie/models/group_model.dart';
import 'package:kollokvie/models/user_model.dart';
import 'package:kollokvie/view/ui/group_memebers/memebers_view.dart';
import 'package:kollokvie/view/widgets/round_image.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

class GroupWidget extends StatelessWidget {
  final GroupModel groupModel;
  final Function onDelete;

  GroupWidget({this.groupModel, this.onDelete});

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
              caption: groupModel.adminId == StaticInfo.userModel.value.id
                  ? "Delete"
                  : 'Leave',
              color: groupModel.adminId == StaticInfo.userModel.value.id
                  ? Colors.red
                  : Colors.yellow,
              icon: groupModel.adminId == StaticInfo.userModel.value.id
                  ? Icons.delete
                  : Icons.logout,
              onTap: onDelete,
              closeOnTap: true,
            ),
          ),
          IconSlideAction(
            caption: 'Memebers',
            color: Colors.lightBlueAccent,
            icon: Icons.info_outline,
            onTap: () {
              List<UserModel> otherMembers = groupModel.groupMembers
                  .skipWhile(
                      (element) => element.id == StaticInfo.userModel.value.id)
                  .toList();
              Get.to(() => MemebersView(groupMemebers: otherMembers));
            },
            closeOnTap: true,
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
              groupModel.groupIcon != ""
                  ? RoundImage(
                      radius: 50,
                      imageUrl: groupModel.groupIcon,
                    )
                  : CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                          groupModel.groupName.substring(0, 1).toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white)),
                    ),
              SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    groupModel.groupName,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  AutoSizeText(
                    groupModel.recentMessage == "" &&
                            groupModel.recentMessageSender == ""
                        ? ""
                        : groupModel.recentMessage == ""
                            ? "Image sent"
                            : groupModel.recentMessage,
                    presetFontSizes: [12, 10],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  )
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
                date: groupModel.lastMessageTime.toDate(),
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
