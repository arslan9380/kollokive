import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:kollokvie/app/constants.dart';
import 'package:kollokvie/models/friends_model.dart';
import 'package:kollokvie/view/ui/friends_request/friends_request_viewmodel.dart';
import 'package:kollokvie/view/widgets/friend_request_widget.dart';
import 'package:kollokvie/view/widgets/icon_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';

class FriendsRequestView extends StatelessWidget {
  final List<FriendsModel> allFriendsRequests;

  FriendsRequestView({this.allFriendsRequests});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FriendsRequstViewModel>.reactive(
        viewModelBuilder: () => FriendsRequstViewModel(),
        onModelReady: (model) => SchedulerBinding.instance
            .addPostFrameCallback((_) => model.initialise(allFriendsRequests)),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                leading: InkWell(
                    onTap: () => Get.back(result: model.acceptedFriends),
                    child: IconButtonWidget(icon: Icons.arrow_back_ios_sharp)),
                title: Text(
                  "Friend Request",
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                centerTitle: true,
              ),
              body: WillPopScope(
                onWillPop: () {
                  Get.back(result: model.acceptedFriends);
                  return;
                },
                child: ModalProgressHUD(
                  inAsyncCall: model.isProcessing,
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: hMargin, vertical: vMargin),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: model.friendsRequests.length,
                              itemBuilder: (_, index) {
                                return FriendsRequestWidget(
                                  userModel:
                                      model.friendsRequests[index].sendByUser,
                                  onAccept: () {
                                    model.acceptFriendRequest(
                                        allFriendsRequests[index]);
                                  },
                                  onReject: () {
                                    model.removeFriend(
                                        allFriendsRequests[index]);
                                  },
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }
}
