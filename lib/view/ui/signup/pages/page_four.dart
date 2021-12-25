import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tajeer/app/constants.dart';
import 'package:tajeer/app/locator.dart';
import 'package:tajeer/view/ui/signup/signup_viewmodel.dart';
import 'package:tajeer/view/widgets/inputfield_widget.dart';

class PageFour extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<PageFour> {
  SignUpViewModel model = locator<SignUpViewModel>();
  TextEditingController subject1 = TextEditingController();
  TextEditingController subject2 = TextEditingController();
  TextEditingController subject3 = TextEditingController();
  TextEditingController subject4 = TextEditingController();
  TextEditingController subject5 = TextEditingController();

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
                        Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.2),
                            child: Image.asset(
                              "assets/logo.png",
                              color: Theme.of(context).primaryColor,
                            )),
                        SizedBox(
                          height: Get.height * 0.05,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Register Step 4/4',
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
                        InputFieldWidget(
                          hint: "Fill in Subject",
                          controller: subject1,
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
                                model.moveToSummary(
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
