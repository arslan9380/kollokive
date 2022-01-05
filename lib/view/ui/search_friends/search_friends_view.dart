import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:kollokvie/app/constants.dart';
import 'package:kollokvie/models/user_model.dart';
import 'package:kollokvie/view/ui/search_friends/search_friends_viewmodel.dart';
import 'package:kollokvie/view/widgets/friend_widget.dart';
import 'package:kollokvie/view/widgets/icon_button.dart';
import 'package:kollokvie/view/widgets/inputfield_widget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';

// ignore: must_be_immutable
class SearchFriendsView extends StatelessWidget {
  List<UserModel> myFriends;

  SearchFriendsView({this.myFriends});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchFriendsViewModel>.reactive(
        viewModelBuilder: () => SearchFriendsViewModel(),
        onModelReady: (model) => SchedulerBinding.instance
            .addPostFrameCallback((_) => model.initialise(myFriends)),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                leading: InkWell(
                    onTap: () => Get.back(result: model.addedFriends),
                    child: IconButtonWidget(icon: Icons.arrow_back_ios_sharp)),
                title: Text(
                  "Find Friends",
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
                  Get.back(result: model.addedFriends);
                  return;
                },
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
                                    Container(
                                      height: 50,
                                      child: InputFieldWidget(
                                        hint: "Search Friends",
                                        prefixIcon: Icons.search,
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        onChange: model.searchFriend,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: model.filterUsers.length,
                                        itemBuilder: (_, index) {
                                          return FriendWidget(
                                            userModel: model.filterUsers[index],
                                            showMenu: false,
                                            showAddFriendButton: true,
                                            addFriend: () {
                                              model.addFriend(
                                                  model.filterUsers[index]);
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
