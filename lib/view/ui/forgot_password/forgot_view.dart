import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kollokvie/app/constants.dart';
import 'package:kollokvie/view/ui/forgot_password/forgot_viewmodel.dart';
import 'package:kollokvie/view/widgets/filled_button.dart';
import 'package:kollokvie/view/widgets/inputfield_widget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';

class ForgotView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<ForgotView> {
  TextEditingController emailCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForgotViewModel>.reactive(
        viewModelBuilder: () => ForgotViewModel(),
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
                                      horizontal: Get.width * 0.05),
                                  child: Image.asset("assets/logo.png")),
                              SizedBox(
                                height: Get.height * 0.05,
                              ),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Recover Password',
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
                                height: Get.height * 0.04,
                              ),
                              InkWell(
                                onTap: () {
                                  model.forgotPassword(emailCon.text);
                                },
                                child: FilledButton(
                                  title: "Submit",
                                ),
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
