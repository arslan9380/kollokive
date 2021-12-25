import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:tajeer/app/constants.dart';
import 'package:tajeer/app/static_info.dart';
import 'package:tajeer/models/group_model.dart';
import 'package:tajeer/models/message.dart';
import 'package:tajeer/services/group_chat_service.dart';
import 'package:tajeer/view/ui/group_chat/group_chat_viewmodel.dart';
import 'package:tajeer/view/widgets/icon_button.dart';
import 'package:tajeer/view/widgets/msg_receive_widget.dart';
import 'package:tajeer/view/widgets/msg_send_widget.dart';

class GroupChatView extends StatefulWidget {
  final GroupModel groupModel;

  GroupChatView({this.groupModel});

  @override
  _GroupChatViewState createState() => _GroupChatViewState();
}

class _GroupChatViewState extends State<GroupChatView> {
  final FocusNode msgFocus = FocusNode();

  TextEditingController msgCon = TextEditingController();

  GroupChatService groupChatService;
  var subscription;

  List<Message> messages;
  bool loading = false;
  String productImg;
  bool image = false;
  DateTime lastMsgTime;

  @override
  void initState() {
    super.initState();
    groupChatService = GroupChatService.withGroupMsgsStreamInitialized(
        widget.groupModel.groupId);
    subscription = groupChatService.messageStream.listen((data) {
      setState(() {
        messages = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GroupChatViewModel>.reactive(
      viewModelBuilder: () => GroupChatViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () => Get.back(),
              child: IconButtonWidget(icon: Icons.arrow_back_ios_sharp)),
          title: Text(
            widget.groupModel.groupName,
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: messages == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      reverse: true,
                      physics: BouncingScrollPhysics(),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: hMargin),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 16,
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: messages.length,
                                reverse: true,
                                itemBuilder: (_, index) {
                                  var message =
                                      messages[messages.length - 1 - index];
                                  return message.senderUid !=
                                          StaticInfo.userModel.id
                                      ? MsgReceiveWidget(
                                          message: message,
                                        )
                                      : MsgSendWidget(
                                          message: message,
                                        );
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(27.5),
                                border: Border.all(
                                    color:
                                        Theme.of(context).primaryColorLight)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 2,
                                ),
                                Flexible(
                                  child: TextField(
                                    maxLines: null,
                                    controller: msgCon,
                                    focusNode: msgFocus,
                                    onTap: () {},
                                    decoration: InputDecoration(
                                      hintText: "Write a message…",
                                      hintStyle: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontSize: 16,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                InkWell(
                                  onTap: () {
                                    {
                                      var picked;
                                      showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Pick one source for image'),
                                              actions: [
                                                FlatButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      picked = await ImagePicker()
                                                          .getImage(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);
                                                      if (picked != null) {
                                                        var cropped =
                                                            await ImageCropper
                                                                .cropImage(
                                                          sourcePath:
                                                              picked.path,
                                                          compressQuality: 70,
                                                          aspectRatio:
                                                              CropAspectRatio(
                                                                  ratioX: 1,
                                                                  ratioY: 1),
                                                        );
                                                        if (cropped != null)
                                                          setState(() {
                                                            image = true;
                                                            productImg =
                                                                cropped.path;
                                                          });
                                                        _sendMsg();
                                                      }
                                                    },
                                                    child: Text(
                                                      'Gallery',
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                    )),
                                                FlatButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      picked = await ImagePicker()
                                                          .getImage(
                                                              source:
                                                                  ImageSource
                                                                      .camera);
                                                      if (picked != null) {
                                                        var cropped =
                                                            await ImageCropper
                                                                .cropImage(
                                                          sourcePath:
                                                              picked.path,
                                                          compressQuality: 40,
                                                          aspectRatio:
                                                              CropAspectRatio(
                                                                  ratioX: 1,
                                                                  ratioY: 1),
                                                        );
                                                        if (cropped != null)
                                                          setState(() {
                                                            image = true;
                                                            productImg =
                                                                cropped.path;
                                                          });

                                                        _sendMsg();
                                                      }
                                                    },
                                                    child: Text('Camera',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor)))
                                              ],
                                            );
                                          });
                                    }
                                  },
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Theme.of(context).primaryColorDark,
                                    size: 30,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        InkWell(
                          onTap: () {
                            _sendMsg();
                          },
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
      ),
    );
  }

  _sendMsg() async {
    if (msgCon.text.isEmpty && image == false) return;
    Message message = Message(
        msgId: DateTime.now().toLocal().millisecondsSinceEpoch.toString(),
        serverTime: FieldValue.serverTimestamp(),
        msgBody: msgCon.text.trim(),
        senderUid: StaticInfo.userModel.id,
        receiverUid: widget.groupModel.groupId,
        image: productImg != null ? true : false,
        senderImageUrl: StaticInfo.userModel.imageUrl,
        url: productImg);
    lastMsgTime = DateTime.fromMicrosecondsSinceEpoch(
            int.parse(DateTime.now().toUtc().microsecondsSinceEpoch.toString()))
        .toLocal();
    setState(() {
      msgCon.clear();
    });

    await groupChatService.sentMessage(message, lastMsgTime);
  }
}
