import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kollokvie/app/constants.dart';
import 'package:kollokvie/app/static_info.dart';
import 'package:kollokvie/view/ui/edit_profile/edit_profile_viewmodel.dart';
import 'package:kollokvie/view/widgets/icon_button.dart';
import 'package:kollokvie/view/widgets/inputfield_widget.dart';
import 'package:kollokvie/view/widgets/round_image.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  TextEditingController schoolCon = TextEditingController();
  TextEditingController cityCon = TextEditingController();
  TextEditingController degreeCon = TextEditingController();
  TextEditingController fieldOfStudyCon = TextEditingController();
  TextEditingController semesterCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController ageCon = TextEditingController();
  TextEditingController bioCon = TextEditingController();

  TextEditingController subject1 = TextEditingController();
  TextEditingController subject2 = TextEditingController();
  TextEditingController subject3 = TextEditingController();
  TextEditingController subject4 = TextEditingController();
  TextEditingController subject5 = TextEditingController();

  @override
  void initState() {
    presetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditProfileViewModel>.reactive(
        viewModelBuilder: () => EditProfileViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                leading: InkWell(
                    onTap: () => Get.back(),
                    child: IconButtonWidget(icon: Icons.arrow_back_ios_sharp)),
                title: Text(
                  "Edit Profile",
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                centerTitle: true,
                actions: [
                  InkWell(
                      onTap: () {
                        model.updateProfile(
                            nameCon.text,
                            ageCon.text,
                            schoolCon.text,
                            cityCon.text,
                            degreeCon.text,
                            fieldOfStudyCon.text,
                            semesterCon.text,
                            bioCon.text,
                            subject1.text,
                            subject2.text,
                            subject3.text,
                            subject4.text,
                            subject5.text);
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 12),
                          child: Center(
                            child: Text(
                              "Save",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorDark),
                            ),
                          ))),
                ],
              ),
              body: SafeArea(
                child: ModalProgressHUD(
                  inAsyncCall: model.isProcessing,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: hMargin),
                      child: Column(
                        children: [
                          SizedBox(
                            height: Get.height * 0.05,
                          ),
                          InkWell(
                            onTap: () {
                              model.pickImage();
                            },
                            child: model.profileImage != null
                                ? Container(
                                    height: Get.width * 0.3,
                                    width: Get.width * 0.3,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(color: Colors.black),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(
                                                File(model.profileImage)))),
                                  )
                                : (StaticInfo.userModel.value.imageUrl == "" ||
                                        StaticInfo.userModel.value.imageUrl ==
                                            null)
                                    ? Container(
                                        height: Get.width * 0.3,
                                        width: Get.width * 0.3,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0x4cd3d1d8),
                                                blurRadius: 6,
                                                spreadRadius: 1,
                                                offset: Offset(0, 0),
                                              ),
                                            ],
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            image: DecorationImage(
                                                fit: BoxFit.fitHeight,
                                                image: AssetImage(
                                                    "assets/person_placeholder.png"))),
                                      )
                                    : Obx(
                                        () => RoundImage(
                                          radius: Get.width * 0.3,
                                          imageUrl: StaticInfo
                                              .userModel.value.imageUrl,
                                        ),
                                      ),
                          ),
                          SizedBox(
                            height: Get.height * 0.05,
                          ),
                          InputFieldWidget(
                            hint: "Name",
                            controller: nameCon,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputFieldWidget(
                            hint: "Age",
                            controller: ageCon,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputFieldWidget(
                            hint: "School",
                            controller: schoolCon,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputFieldWidget(
                            hint: "City",
                            controller: cityCon,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputFieldWidget(
                            hint: "Degree",
                            controller: degreeCon,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputFieldWidget(
                            hint: "Field of study",
                            controller: fieldOfStudyCon,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputFieldWidget(
                            hint: "Semester",
                            controller: semesterCon,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputFieldWidget(
                            hint: "Your Short bio",
                            controller: bioCon,
                            maxLines: 4,
                          ),
                          SizedBox(
                            height: Get.height * 0.04,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Subjects',
                              style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputFieldWidget(
                            hint: "Fill in Subject",
                            controller: subject2,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputFieldWidget(
                            hint: "Fill in Subject",
                            controller: subject3,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputFieldWidget(
                            hint: "Fill in Subject",
                            controller: subject4,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputFieldWidget(
                            hint: "Fill in Subject",
                            controller: subject5,
                          ),
                          SizedBox(
                            height: Get.height * 0.04,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  width: Get.width * 0.42,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(28.50),
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Back",
                                      style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.28,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  model.updateProfile(
                                      nameCon.text,
                                      ageCon.text,
                                      schoolCon.text,
                                      cityCon.text,
                                      degreeCon.text,
                                      fieldOfStudyCon.text,
                                      semesterCon.text,
                                      bioCon.text,
                                      subject1.text,
                                      subject2.text,
                                      subject3.text,
                                      subject4.text,
                                      subject5.text);
                                },
                                child: Container(
                                  width: Get.width * 0.42,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(28.50),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Save",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.28,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.04,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }

  void presetData() {
    schoolCon.text = StaticInfo.userModel.value.school;
    cityCon.text = StaticInfo.userModel.value.city;
    degreeCon.text = StaticInfo.userModel.value.degree;
    fieldOfStudyCon.text = StaticInfo.userModel.value.fieldOfStudy;
    semesterCon.text = StaticInfo.userModel.value.semester;
    nameCon.text = StaticInfo.userModel.value.name;
    ageCon.text = StaticInfo.userModel.value.age;
    bioCon.text = StaticInfo.userModel.value.bio;

    subject1.text = StaticInfo.userModel.value.subjects[0];
    subject2.text = StaticInfo.userModel.value.subjects[1];
    subject3.text = StaticInfo.userModel.value.subjects[2];
    subject4.text = StaticInfo.userModel.value.subjects[3];
    subject5.text = StaticInfo.userModel.value.subjects[4];
  }
}
