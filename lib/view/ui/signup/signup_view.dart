import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';
import 'package:tajeer/app/constants.dart';
import 'package:tajeer/app/locator.dart';
import 'package:tajeer/view/ui/signup/signup_viewmodel.dart';
import 'package:tajeer/view/widgets/inputfield_widget.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController firstNameCon = TextEditingController();
  TextEditingController lastNameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController phoneCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  TextEditingController confirmPasswordCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
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
                              'Register Step 1/4',
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
                            hint: "Email",
                            prefixIcon: Icons.email,
                            controller: emailCon,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputFieldWidget(
                            hint: "Password",
                            prefixIcon: Icons.lock,
                            obscure: true,
                            controller: passwordCon,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputFieldWidget(
                            hint: "Confirm Password",
                            prefixIcon: Icons.lock,
                            obscure: true,
                            controller: confirmPasswordCon,
                          ),
                          SizedBox(
                            height: Get.height * 0.04,
                          ),
                          InkWell(
                            onTap: () {
                              model.moveToPageTwo(emailCon.text,
                                  passwordCon.text, confirmPasswordCon.text);
                            },
                            child: Container(
                              width: Get.width * 0.45,
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
                          SizedBox(
                            height: Get.height * 0.04,
                          ),
                          Row(
                            children: [
                              Spacer(),
                              Text(
                                'Already have an account?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontSize: 14,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Text(
                                  ' Login',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Spacer(),
                            ],
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
      ),
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      createNewModelOnInsert: true,
      viewModelBuilder: () => locator<SignUpViewModel>(),
    );
  }
}
