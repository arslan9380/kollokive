import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kollokvie/app/constants.dart';
import 'package:kollokvie/models/user_model.dart';
import 'package:kollokvie/view/widgets/group_widget.dart';
import 'package:kollokvie/view/widgets/icon_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';

import 'my_groups_viewmodel.dart';

class MyGroupsView extends StatelessWidget {
  final UserModel user;

  MyGroupsView({this.user});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MyGroupsViewModel>.reactive(
        viewModelBuilder: () => MyGroupsViewModel(),
        onModelReady: (model) => SchedulerBinding.instance
            .addPostFrameCallback((_) => model.initialise(user)),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                leading: InkWell(
                    onTap: () => Get.back(),
                    child: IconButtonWidget(icon: Icons.arrow_back_ios_sharp)),
                title: Text(
                  "Add To Group",
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                centerTitle: true,
              ),
              body: ModalProgressHUD(
                inAsyncCall: model.isProcessing,
                child: model.loading
                    ? Center(child: CircularProgressIndicator())
                    : model.msg != ""
                        ? Center(
                            child: Text(
                            model.msg,
                            textAlign: TextAlign.center,
                          ))
                        : SingleChildScrollView(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: hMargin, vertical: vMargin),
                              child: Column(
                                children: [
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Tap to Add".toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: GoogleFonts.aBeeZee()
                                                .fontFamily),
                                      )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: model
                                          .myGroupsWhereUserNotJoined.length,
                                      itemBuilder: (_, index) {
                                        return InkWell(
                                          onTap: () {
                                            model.addToGroup(
                                                model.myGroupsWhereUserNotJoined[
                                                    index],
                                                user);
                                          },
                                          child: IgnorePointer(
                                            ignoring: false,
                                            child: GroupWidget(
                                              groupModel: model
                                                      .myGroupsWhereUserNotJoined[
                                                  index],
                                            ),
                                          ),
                                        );
                                      })
                                ],
                              ),
                            ),
                          ),
              ),
            ));
  }
}
