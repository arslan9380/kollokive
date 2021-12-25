import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';
import 'package:tajeer/app/constants.dart';
import 'package:tajeer/app/locator.dart';
import 'package:tajeer/view/widgets/friend_widget.dart';

import 'friends_viewmodel.dart';

class FriendsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FriendsViewModel>.reactive(
        viewModelBuilder: () => locator<FriendsViewModel>(),
        onModelReady: (model) => SchedulerBinding.instance
            .addPostFrameCallback((_) => model.initialise()),
        builder: (context, model, child) => Scaffold(
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
                                      itemCount: model.allFriends.length,
                                      itemBuilder: (_, index) {
                                        return FriendWidget(
                                          userModel: model.allFriends[index],
                                          model: model,
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
