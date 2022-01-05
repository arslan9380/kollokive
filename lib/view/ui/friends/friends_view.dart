import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:kollokvie/app/constants.dart';
import 'package:kollokvie/app/locator.dart';
import 'package:kollokvie/app/static_info.dart';
import 'package:kollokvie/view/widgets/friend_widget.dart';
import 'package:kollokvie/view/widgets/inputfield_widget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';

import 'friends_viewmodel.dart';

class FriendsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FriendsViewModel>.reactive(
        viewModelBuilder: () => locator<FriendsViewModel>(),
        onModelReady: (model) => SchedulerBinding.instance
            .addPostFrameCallback((_) => model.initialise()),
        builder: (context, model, child) => Scaffold(
              body: RefreshIndicator(
                onRefresh: () {
                  return model.initialise();
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: Get.height,
                    child: ModalProgressHUD(
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
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Container(
                                                height: 50,
                                                child: InputFieldWidget(
                                                  hint: "Search Friends",
                                                  prefixIcon: Icons.search,
                                                  textAlignVertical:
                                                      TextAlignVertical.bottom,
                                                  onChange: model.searchFriend,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            GestureDetector(
                                              onTap: model.addFriends,
                                              child: Icon(
                                                Icons.add_circle,
                                                size: 36,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            GestureDetector(
                                              onTap: model.goToFriendRequest,
                                              child: Icon(
                                                Icons.group_add,
                                                size: 36,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount:
                                                model.filterFriends.length,
                                            itemBuilder: (_, index) {
                                              return FriendWidget(
                                                userModel: model
                                                            .filterFriends[
                                                                index]
                                                            .requestSendById !=
                                                        StaticInfo
                                                            .userModel.value.id
                                                    ? model.filterFriends[index]
                                                        .sendByUser
                                                    : model.filterFriends[index]
                                                        .sendToUser,
                                                model: model,
                                              );
                                            })
                                      ],
                                    ),
                                  ),
                                ),
                    ),
                  ),
                ),
              ),
            ));
  }
}
