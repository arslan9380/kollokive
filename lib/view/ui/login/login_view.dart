import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';
import 'package:tajeer/app/constants.dart';
import 'package:tajeer/view/ui/forgot_password/forgot_view.dart';
import 'package:tajeer/view/ui/signup/signup_view.dart';
import 'package:tajeer/view/widgets/filled_button.dart';
import 'package:tajeer/view/widgets/inputfield_widget.dart';

import 'login_viewmodel.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailCon =
      TextEditingController(text: "test@gmail.com");
  TextEditingController passwordCon = TextEditingController(text: "123456");

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => LoginViewModel(),
        builder: (context, model, child) => Scaffold(
              body: ModalProgressHUD(
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
                                height: Get.height * 0.1,
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
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'LOGIN',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24,
                                    ),
                                  )),
                              SizedBox(
                                height: Get.height * 0.04,
                              ),
                              InputFieldWidget(
                                hint: "Email",
                                prefixIcon: Icons.person,
                                controller: emailCon,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              InputFieldWidget(
                                hint: "Password",
                                prefixIcon: Icons.lock,
                                obscure: true,
                                controller: passwordCon,
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => ForgotView());
                                },
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text("Forgot Password?")),
                              ),
                              SizedBox(
                                height: Get.height * 0.04,
                              ),
                              InkWell(
                                onTap: () {
                                  model.loginUser(
                                      emailCon.text, passwordCon.text);
                                },
                                child: FilledButton(
                                  title: "LOGIN",
                                ),
                              ),
                              SizedBox(
                                height: Get.height * 0.05,
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  Text(
                                    'Don’t have an account?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 14,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => Get.to(SignUpView()),
                                    child: Text(
                                      ' Register now',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w800,
                                        fontFamily:
                                            GoogleFonts.adamina().fontFamily,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
