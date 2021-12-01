import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';
import 'package:tajeer/app/constants.dart';
import 'package:tajeer/view/ui/chat/chat_view.dart';
import 'package:tajeer/view/ui/profile/profile_viewmodel.dart';
import 'package:tajeer/view/widgets/icon_button.dart';
import 'package:tajeer/view/widgets/item_widget.dart';
import 'package:tajeer/view/widgets/no_event_widget.dart';
import 'package:tajeer/view/widgets/profile_card.dart';

class ProfileView extends StatelessWidget {
  final String userId;

  ProfileView({this.userId});

  @override
  Widget build(BuildContext context) {
    ScrollController _publishedScrollCon = ScrollController();
    ScrollController _hidesScrollCon = ScrollController();

    return ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(),
        onModelReady: (model) => SchedulerBinding.instance
            .addPostFrameCallback((_) => model.getMyData(userId)),
        builder: (context, model, child) => Scaffold(
              appBar: userId != null
                  ? AppBar(
                      leading: InkWell(
                          onTap: () => Get.back(),
                          child: IconButtonWidget(
                              icon: Icons.arrow_back_ios_sharp)),
                      title: Text(
                        "Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      centerTitle: true,
                      actions: [
                        InkWell(
                            onTap: () {
                              if (model.userModel != null) {
                                return Get.to(() => ChatView());
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 12),
                              child: Icon(
                                Icons.chat_outlined,
                                color: Colors.white,
                              ),
                            ))
                      ],
                    )
                  : null,
              body: model.loading
                  ? Center(child: CircularProgressIndicator())
                  : model.msg != ""
                      ? Center(
                          child: Text(
                          model.msg,
                          textAlign: TextAlign.center,
                        ))
                      : Container(
                          margin: EdgeInsets.symmetric(horizontal: hMargin),
                          child: DefaultTabController(
                            length: 2,
                            child: NestedScrollView(
                              headerSliverBuilder: (BuildContext context,
                                  bool innerBoxIsScrolled) {
                                return <Widget>[
                                  SliverAppBar(
                                      pinned: false,
                                      floating: false,
                                      expandedHeight: 340 + vMargin,
                                      collapsedHeight: 340,
                                      backgroundColor: Colors.white,
                                      automaticallyImplyLeading: false,
                                      flexibleSpace: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: vMargin),
                                          child: ProfileCard(
                                            userModel: model.userModel,
                                          ))),
                                ];
                              },
                              body: Column(
                                children: [
                                  if (userId == null)
                                    TabBar(
                                      indicatorColor:
                                          Theme.of(context).primaryColor,
                                      indicatorWeight: 4,
                                      labelColor:
                                          Theme.of(context).primaryColor,
                                      unselectedLabelColor:
                                          Theme.of(context).primaryColor,
                                      unselectedLabelStyle: TextStyle(
                                        fontSize: 20,
                                      ),
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      enableFeedback: false,
                                      isScrollable: false,
                                      labelStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                      tabs: [
                                        Tab(text: "Published"),
                                        Tab(text: "Hide"),
                                      ],
                                    ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Expanded(
                                    child: ModalProgressHUD(
                                      inAsyncCall: model.proccesing,
                                      child: TabBarView(
                                          physics: BouncingScrollPhysics(),
                                          children: [
                                            RawScrollbar(
                                              thumbColor: Theme.of(context)
                                                  .primaryColor,
                                              isAlwaysShown: true,
                                              controller: _publishedScrollCon,
                                              child: SingleChildScrollView(
                                                controller: _publishedScrollCon,
                                                physics:
                                                    BouncingScrollPhysics(),
                                                child: model.publishedItem
                                                            .length ==
                                                        0
                                                    ? NoEventWidget(false)
                                                    : ListView.builder(
                                                        itemCount: model
                                                            .publishedItem
                                                            .length,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        itemBuilder:
                                                            (_, index) {
                                                          return InkWell(
                                                              onTap: () {},
                                                              child: ItemWidget(
                                                                isFromPublish:
                                                                    true,
                                                                itemModel: model
                                                                        .publishedItem[
                                                                    index],
                                                                model: model,
                                                              ));
                                                        }),
                                              ),
                                            ),

                                            ///--------------------------------
                                            RawScrollbar(
                                              thumbColor: Theme.of(context)
                                                  .primaryColor,
                                              isAlwaysShown: true,
                                              controller: _hidesScrollCon,
                                              child: SingleChildScrollView(
                                                controller: _hidesScrollCon,
                                                physics:
                                                    BouncingScrollPhysics(),
                                                child: model.hideItems.length ==
                                                        0
                                                    ? NoEventWidget(false)
                                                    : ListView.builder(
                                                        itemCount: model
                                                            .hideItems.length,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        itemBuilder:
                                                            (_, index) {
                                                          return InkWell(
                                                              onTap: () {},
                                                              child: ItemWidget(
                                                                isFromHide:
                                                                    true,
                                                                model: model,
                                                                itemModel: model
                                                                        .hideItems[
                                                                    index],
                                                              ));
                                                        }),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
            ));
  }
}
