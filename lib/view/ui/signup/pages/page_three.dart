import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kollokvie/app/constants.dart';
import 'package:kollokvie/app/locator.dart';
import 'package:kollokvie/view/ui/signup/signup_viewmodel.dart';
import 'package:kollokvie/view/widgets/inputfield_widget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class PageThree extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<PageThree> {
  SignUpViewModel model = locator<SignUpViewModel>();
  TextEditingController nameCon = TextEditingController();
  TextEditingController ageCon = TextEditingController();
  TextEditingController bioCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: model.loading,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: hMargin),
                    child: Column(
                      children: [
                        SizedBox(
                          height: Get.height * 0.05,
                        ),
                        // Container(
                        //     margin: EdgeInsets.symmetric(
                        //         horizontal: Get.width * 0.2),
                        //     child: Image.asset(
                        //       "assets/logo.png",
                        //       color: Theme.of(context).primaryColor,
                        //     )),
                        // SizedBox(
                        //   height: Get.height * 0.05,
                        // ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Register Step 3/4',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.04,
                        ),
                        InkWell(
                            onTap: () async {
                              await model.pickImage();
                              setState(() {});
                            },
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                model.profileImage != null
                                    ? Container(
                                        height: Get.width * 0.4,
                                        width: Get.width * 0.4,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            border:
                                                Border.all(color: Colors.black),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: FileImage(
                                                    File(model.profileImage)))),
                                      )
                                    : Container(
                                        height: Get.width * 0.4,
                                        width: Get.width * 0.4,
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
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                    "assets/person_placeholder.png"))),
                                      ),
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: Get.height * 0.04,
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
                          hint: "Your Short bio",
                          controller: bioCon,
                          maxLines: 4,
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
                                model.moveToPageFour(
                                    nameCon.text, ageCon.text, bioCon.text);
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
                                    "Continue",
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
            ],
          ),
        ),
      ),
    );
  }
}
