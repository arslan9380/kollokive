import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kollokvie/app/constants.dart';
import 'package:kollokvie/app/locator.dart';
import 'package:kollokvie/view/ui/signup/signup_viewmodel.dart';
import 'package:kollokvie/view/widgets/profile_card.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SummaryView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SummaryView> {
  SignUpViewModel model = locator<SignUpViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Summary',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: model.loading,
        child: SingleChildScrollView(
          physics: ScrollPhysics(parent: BouncingScrollPhysics()),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: hMargin),
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.05,
                ),
                ProfileCard(
                  userModel: model.userModel,
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'List of Subjects',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: model.userModel.subjects.length,
                    itemBuilder: (_, index) {
                      return RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                            text: "${index + 1}: ",
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                            children: <TextSpan>[
                              TextSpan(
                                text: model.userModel.subjects[index],
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.5),
                                    fontSize: 14),
                              ),
                            ]),
                      );
                    }),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                SizedBox(
                  height: 10,
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
                      onTap: () async {
                        setState(() {
                          model.setLoading(true);
                        });
                        await model.signUpUser();
                        setState(() {
                          model.setLoading(false);
                        });
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
                            "Create User",
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
    );
  }
}
