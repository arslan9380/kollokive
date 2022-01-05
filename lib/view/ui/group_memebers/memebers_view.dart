import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kollokvie/app/constants.dart';
import 'package:kollokvie/models/user_model.dart';
import 'package:kollokvie/view/widgets/friend_widget.dart';
import 'package:kollokvie/view/widgets/icon_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';

import 'memebers_viewmodel.dart';

class MemebersView extends StatelessWidget {
  final List<UserModel> groupMemebers;

  MemebersView({@required this.groupMemebers});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MemebersViewModel>.reactive(
        viewModelBuilder: () => MemebersViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                leading: InkWell(
                    onTap: () => Get.back(),
                    child: IconButtonWidget(icon: Icons.arrow_back_ios_sharp)),
                title: Text(
                  "Group Memebers",
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
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: groupMemebers.length,
                                      itemBuilder: (_, index) {
                                        return FriendWidget(
                                          userModel: groupMemebers[index],
                                          showMenu: false,
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
