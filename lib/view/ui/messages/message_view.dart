import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:tajeer/app/constants.dart';
import 'package:tajeer/app/locator.dart';
import 'package:tajeer/app/static_info.dart';
import 'package:tajeer/models/chat.dart';
import 'package:tajeer/models/group_model.dart';
import 'package:tajeer/services/auth_service.dart';
import 'package:tajeer/services/group_chat_service.dart';
import 'package:tajeer/services/message_helper.dart';
import 'package:tajeer/view/ui/chat/chat_view.dart';
import 'package:tajeer/view/ui/create_group/create_group_view.dart';
import 'package:tajeer/view/ui/group_chat/group_chat_view.dart';
import 'package:tajeer/view/widgets/group_widget.dart';
import 'package:tajeer/view/widgets/message_widget.dart';

import 'message_viewmodel.dart';

class MessageView extends StatefulWidget {
  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  bool notify = false;
  String s;
  var subscription;
  MessageHelper helper;
  List<Chat> chats;
  List<Chat> filteredList;

  final AuthService _auth = locator<AuthService>();
  String _groupName;
  String _userName = '';
  String _email = '';
  Stream _groups;
  List<GroupModel> myGroups = [];
  GroupChatService groupChatService;

  @override
  void initState() {
    super.initState();
    helper = MessageHelper.withChatStreamInitialized();
    subscription = helper.chatStream.listen((data) {
      setState(() {
        chats = data;
        print(chats);
        chats.sort((b, a) => a.dateTime.compareTo(b.dateTime));
      });
    });
    _email = StaticInfo.userModel.email;
    _userName = StaticInfo.userModel.name;
    groupChatService = GroupChatService.withGroupStreamInitialized();
    groupChatService.groupsStream.listen((updatedGroups) {
      setState(() {
        myGroups = updatedGroups;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MessageViewModel>.reactive(
        viewModelBuilder: () => MessageViewModel(),
        builder: (context, model, child) => Scaffold(
              body: Container(
                margin: EdgeInsets.symmetric(horizontal: hMargin),
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.05,
                    ),
                    CupertinoSlidingSegmentedControl<int>(
                      padding: EdgeInsets.all(5),
                      children: <int, Widget>{
                        0: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.1, vertical: 8),
                          child: Text(
                            "Chats",
                            style: TextStyle(
                                color: model.currentIndex == 0
                                    ? Colors.white
                                    : Theme.of(context).primaryColorDark),
                          ),
                        ),
                        1: Text(
                          "Groups",
                          style: TextStyle(
                              color: model.currentIndex == 1
                                  ? Colors.white
                                  : Theme.of(context).primaryColorDark),
                        ),
                      },
                      thumbColor: Theme.of(context).primaryColor,
                      onValueChanged: model.setIndex,
                      groupValue: model.currentIndex,
                    ),
                    SizedBox(
                      height: Get.height * 0.05,
                    ),
                    Expanded(
                      child: IndexedStack(
                        index: model.currentIndex,
                        children: [
                          chats == null
                              ? Center(child: CircularProgressIndicator())
                              : ListView.builder(
                                  itemCount: chats.length,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (_, index) {
                                    return InkWell(
                                        onTap: () {
                                          Get.to(() => ChatView(
                                                chat: chats[index],
                                              ));
                                        },
                                        child: MessageWidget(
                                          chat: chats[index],
                                          onDelete: () {
                                            Get.defaultDialog(
                                                title:
                                                    "Are you sure you want to delete this chat?",
                                                middleText: "",
                                                buttonColor: Theme.of(context)
                                                    .primaryColor,
                                                confirmTextColor: Colors.white,
                                                onCancel: () {
                                                  Get.back();
                                                },
                                                textConfirm: "  Delete  ",
                                                onConfirm: () {
                                                  Get.back();
                                                  MessageHelper().deleteChat(
                                                      chats[index].uid);
                                                });
                                          },
                                        ));
                                  }),
                          chats == null
                              ? Center(child: CircularProgressIndicator())
                              : Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "My Groups",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(() => CreateGroupView());
                                          },
                                          child: Icon(
                                            Icons.add_circle,
                                            size: 36,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        )
                                      ],
                                    ),
                                    ListView.builder(
                                        itemCount: myGroups.length,
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (_, index) {
                                          return InkWell(
                                            onTap: () {
                                              Get.to(() => GroupChatView(
                                                    groupModel: myGroups[index],
                                                  ));
                                            },
                                            child: GroupWidget(
                                              groupModel: myGroups[index],
                                              onDelete: () {
                                                Get.defaultDialog(
                                                    title:
                                                        "Are you sure you want to Leave this Group?",
                                                    middleText: "",
                                                    buttonColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    confirmTextColor:
                                                        Colors.white,
                                                    onCancel: () {
                                                      Get.back();
                                                    },
                                                    textConfirm: "  Delete  ",
                                                    onConfirm: () {
                                                      Get.back();
                                                      GroupChatService()
                                                          .leaveGroup(
                                                              myGroups[index]);
                                                    });
                                              },
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                          // groupsList()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  String _destructureId(String res) {
    return res.substring(0, res.indexOf('_'));
  }

  String _destructureName(String res) {
    return res.substring(res.indexOf('_') + 1);
  }
}
