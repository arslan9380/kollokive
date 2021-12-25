import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';
import 'package:tajeer/app/constants.dart';
import 'package:tajeer/models/group_model.dart';
import 'package:tajeer/view/widgets/inputfield_widget.dart';

import 'create_group_viewmodel.dart';

class CreateGroupView extends StatefulWidget {
  final GroupModel groupModel;

  CreateGroupView({this.groupModel});

  @override
  _CreateGroupViewState createState() => _CreateGroupViewState();
}

class _CreateGroupViewState extends State<CreateGroupView> {
  TextEditingController titleCon = TextEditingController();
  TextEditingController descriptionCon = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateGroupViewModel>.reactive(
        viewModelBuilder: () => CreateGroupViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                title: Text(
                  "Create Group",
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
              ),
              body: ModalProgressHUD(
                inAsyncCall: model.loading,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          model.pickImage();
                        },
                        child: Container(
                          height: Get.width * 0.7,
                          width: Get.width,
                          child: model.itemImage != ""
                              ? Image.file(
                                  File(model.itemImage),
                                  fit: BoxFit.cover,
                                )
                              : widget.groupModel?.groupIcon != null
                                  ? Image.network(
                                      widget.groupModel.groupIcon,
                                      fit: BoxFit.cover,
                                    )
                                  : Center(
                                      child: Image.asset(
                                        "assets/image_placeholder.png",
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                        ),
                      ),
                      Divider(
                        height: 2,
                        thickness: 3,
                        color: Theme.of(context).primaryColor,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: hMargin, vertical: vMargin),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            InputFieldWidget(
                              hint: "Group Name",
                              controller: titleCon,
                            ),
                            SizedBox(
                              height: Get.height * 0.1,
                            ),
                            InkWell(
                              onTap: () {
                                model.createGroup(titleCon.text);
                              },
                              child: Container(
                                height: 50,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Center(
                                  child: Text(
                                    "Create Group",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
