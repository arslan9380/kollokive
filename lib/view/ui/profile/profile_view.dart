import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';
import 'package:tajeer/app/constants.dart';
import 'package:tajeer/app/locator.dart';
import 'package:tajeer/app/static_info.dart';
import 'package:tajeer/view/ui/friends/friends_viewmodel.dart';
import 'package:tajeer/view/ui/profile/profile_viewmodel.dart';
import 'package:tajeer/view/widgets/icon_button.dart';
import 'package:tajeer/view/widgets/profile_card.dart';

class ProfileView extends StatelessWidget {
  final String userId;

  ProfileView({this.userId});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(),
        onModelReady: (model) => SchedulerBinding.instance
            .addPostFrameCallback((_) => model.getMyData(userId)),
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              leading: InkWell(
                  onTap: () => Get.back(),
                  child: IconButtonWidget(icon: Icons.arrow_back_ios_sharp)),
              title: Text(
                "Profile",
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              centerTitle: true,
              actions: [
                if (model.showEditProfile)
                  InkWell(
                      onTap: model.editProfile,
                      child: Container(
                        margin: EdgeInsets.only(right: 6),
                        padding: EdgeInsets.all(12),
                        child: Image.asset(
                          "assets/edit_icon.png",
                          color: Theme.of(context).primaryColor,
                        ),
                      )),
                if (model.showFriendsMenu)
                  PopupMenuButton(
                    onSelected: (String value) async {
                      if (value == "Send message") {
                        model.goToChat();
                      } else if (value == 'Add to group') {
                      } else if (value == 'Remove friend') {
                        model.removeFriend();
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Send message',
                        child: Text('Send Message'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Add to group',
                        child: Text('Add to group'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Remove friend',
                        child: Text('Remove friend'),
                      ),
                    ],
                    child: Container(
                        margin: EdgeInsets.only(right: 12),
                        child: Icon(
                          Icons.more_horiz,
                          color: Theme.of(context).primaryColorDark,
                        )),
                  )
              ],
            ),
            body: ModalProgressHUD(
              inAsyncCall: model.proccesing,
              child: model.loading
                  ? Center(child: CircularProgressIndicator())
                  : model.msg != ""
                      ? Center(
                          child: Text(
                          model.msg,
                          textAlign: TextAlign.center,
                        ))
                      : Container(
                          margin: EdgeInsets.symmetric(
                              vertical: vMargin, horizontal: hMargin),
                          child: Column(
                            children: [
                              ProfileCard(
                                userModel: model.userModel,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Subjects',
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
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: model
                                                  .userModel.subjects[index],
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
                                height: Get.height * 0.02,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Bio',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  model.userModel.bio ?? "",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Get.height * 0.05,
                              ),
                              if (StaticInfo.userModel.id != model.userModel.id)
                                if (locator<FriendsViewModel>()
                                    .allFriends
                                    .where((element) =>
                                        element.id == model.userModel.id)
                                    .toList()
                                    .isEmpty)
                                  InkWell(
                                    onTap: model.addAsFriend,
                                    child: Container(
                                      width: Get.width * 0.46,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(28.50),
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Add as a friend",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.28,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                            ],
                          )),
            )

            // Container(
            //             margin: EdgeInsets.symmetric(horizontal: hMargin),
            //             child: NestedScrollView(
            //               headerSliverBuilder: (BuildContext context,
            //                   bool innerBoxIsScrolled) {
            //                 return <Widget>[
            //                   SliverAppBar(
            //                       pinned: false,
            //                       floating: false,
            //                       expandedHeight: 410 + vMargin,
            //                       collapsedHeight: 410,
            //                       backgroundColor: Colors.white,
            //                       automaticallyImplyLeading: false,
            //                       flexibleSpace: Container(
            //                           margin: EdgeInsets.symmetric(
            //                               vertical: vMargin),
            //                           child: Column(
            //                             children: [
            //                               ProfileCard(
            //                                 userModel: model.userModel,
            //                               ),
            //                               SizedBox(
            //                                 height: 12,
            //                               ),
            //                               Align(
            //                                 alignment: Alignment.centerLeft,
            //                                 child: Text(
            //                                   'Subjects',
            //                                   style: TextStyle(
            //                                     color: Theme.of(context)
            //                                         .primaryColor,
            //                                     fontSize: 18,
            //                                     fontWeight: FontWeight.w500,
            //                                   ),
            //                                 ),
            //                               ),
            //                               ListView.builder(
            //                                   shrinkWrap: true,
            //                                   physics:
            //                                       NeverScrollableScrollPhysics(),
            //                                   itemCount: model.userModel
            //                                       .subjects.length,
            //                                   itemBuilder: (_, index) {
            //                                     return RichText(
            //                                       textAlign:
            //                                           TextAlign.start,
            //                                       text: TextSpan(
            //                                           text:
            //                                               "${index + 1}: ",
            //                                           style: TextStyle(
            //                                               color: Theme.of(
            //                                                       context)
            //                                                   .primaryColorDark,
            //                                               fontWeight:
            //                                                   FontWeight
            //                                                       .w700,
            //                                               fontSize: 16),
            //                                           children: <TextSpan>[
            //                                             TextSpan(
            //                                               text: model
            //                                                       .userModel
            //                                                       .subjects[
            //                                                   index],
            //                                               style: TextStyle(
            //                                                   color: Theme.of(
            //                                                           context)
            //                                                       .primaryColorDark
            //                                                       .withOpacity(
            //                                                           0.5),
            //                                                   fontSize: 14),
            //                                             ),
            //                                           ]),
            //                                     );
            //                                   }),
            //                             ],
            //                           ))),
            //                 ];
            //               },
            //               body: Column(
            //                 children: [
            //                   SizedBox(
            //                     height: 12,
            //                   ),
            //                   Row(
            //                     children: [
            //                       Expanded(
            //                         child: Container(
            //                           height: 2,
            //                           color: Theme.of(context).primaryColor,
            //                         ),
            //                       ),
            //                       SizedBox(
            //                         width: 6,
            //                       ),
            //                       Text(
            //                         'Post',
            //                         style: TextStyle(
            //                           color: Theme.of(context).primaryColor,
            //                           fontSize: 20,
            //                           fontWeight: FontWeight.w700,
            //                         ),
            //                       ),
            //                       SizedBox(
            //                         width: 6,
            //                       ),
            //                       Expanded(
            //                         child: Container(
            //                           height: 2,
            //                           color: Theme.of(context).primaryColor,
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                   SizedBox(
            //                     height: 12,
            //                   ),
            //                   Expanded(
            //                     child: SingleChildScrollView(
            //                       physics: BouncingScrollPhysics(),
            //                       child: model.publishedItem.length == 0
            //                           ? NoEventWidget(false)
            //                           : ListView.builder(
            //                               itemCount:
            //                                   model.publishedItem.length,
            //                               physics:
            //                                   NeverScrollableScrollPhysics(),
            //                               shrinkWrap: true,
            //                               padding: EdgeInsets.all(5),
            //                               itemBuilder: (_, index) {
            //                                 return InkWell(
            //                                     onTap: () {},
            //                                     child: ItemWidget(
            //                                       isFromPublish: true,
            //                                       itemModel: model
            //                                           .publishedItem[index],
            //                                       model: model,
            //                                     ));
            //                               }),
            //                     ),
            //                   )
            //                 ],
            //               ),
            //             ),
            //           ),
            ));
  }
}
