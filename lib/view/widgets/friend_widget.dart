import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajeer/models/chat.dart';
import 'package:tajeer/models/user_model.dart';
import 'package:tajeer/view/ui/chat/chat_view.dart';
import 'package:tajeer/view/ui/friends/friends_viewmodel.dart';
import 'package:tajeer/view/ui/my_groups/my_groups_view.dart';
import 'package:tajeer/view/ui/profile/profile_view.dart';
import 'package:tajeer/view/widgets/round_image.dart';

class FriendWidget extends StatelessWidget {
  final UserModel userModel;
  final FriendsViewModel model;
  final bool showMenu;

  FriendWidget({@required this.userModel, this.model, this.showMenu = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => ProfileView(
              userId: userModel.id,
            ));
      },
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Color(0x4cd3d1d8),
                blurRadius: 6,
                spreadRadius: 1,
                offset: Offset(0, 0),
              ),
            ],
            border: Border.all(color: Theme.of(context).primaryColor),
            color: Colors.white),
        child: Row(
          children: [
            RoundImage(
              imageUrl: userModel.imageUrl,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          userModel.name.toUpperCase(),
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
                      if (showMenu)
                        PopupMenuButton(
                          onSelected: (String value) async {
                            if (value == "Send message") {
                              Get.to(() => ChatView(
                                    chat: Chat(
                                        userModel.id,
                                        userModel.name,
                                        Timestamp.now(),
                                        false,
                                        "",
                                        userModel.imageUrl),
                                  ));
                            } else if (value == 'Add to group') {
                              Get.to(() => MyGroupsView(
                                    user: userModel,
                                  ));
                            } else if (value == 'Remove friend') {
                              model.removeFriend(userModel);
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Send message',
                              child: Text('Send Message'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Add to group',
                              child: Text('Add to group'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Remove friend',
                              child: Text('Remove friend'),
                            ),
                          ],
                          child: Icon(Icons.more_horiz),
                        )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        userModel.fieldOfStudy + " , " + userModel.semester,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: const Color(0xff7b7b7b),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
