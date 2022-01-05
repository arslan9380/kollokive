import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kollokvie/app/static_info.dart';
import 'package:kollokvie/view/ui/friends/friends_view.dart';
import 'package:kollokvie/view/ui/home/home_view.dart';
import 'package:kollokvie/view/ui/messages/message_view.dart';
import 'package:kollokvie/view/ui/notifications/notifications_view.dart';
import 'package:kollokvie/view/ui/profile/profile_view.dart';
import 'package:kollokvie/view/ui/user_home/user_home_viewmodel.dart';
import 'package:kollokvie/view/widgets/bottom_nav_bar.dart';
import 'package:kollokvie/view/widgets/round_image.dart';
import 'package:stacked/stacked.dart';

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class UserHomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserHomeViewModel>.reactive(
        viewModelBuilder: () => UserHomeViewModel(),
        builder: (context, model, child) => Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                leading: InkWell(
                  onTap: () {
                    Get.to(ProfileView());
                  },
                  child: Container(
                    margin: EdgeInsets.all(6),
                    child: Obx(
                      () => RoundImage(
                        imageUrl: StaticInfo.userModel.value.imageUrl,
                      ),
                    ),
                  ),
                ),
                // InkWell(
                //   onTap: () => scaffoldKey.currentState.openDrawer(),
                //   child: Container(
                //     padding: EdgeInsets.all(15),
                //     child: Image.asset(
                //       "assets/menu.png",
                //       color: Colors.black,
                //     ),
                //   ),
                // ),
                title: Text(
                  "Kollokvie",
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: GoogleFonts.acme().fontFamily,
                      fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                actions: [
                  InkWell(
                      onTap: () {
                        model.logout();
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.logout,
                            color: Colors.black,
                          )))
                ],
              ),
              body:
                  // model.currentIndex == 0
                  //     ? HomeView()
                  //     : model.currentIndex == 1
                  //         ? FriendsView()
                  //         : model.currentIndex == 2
                  //             ? NotificationsView()
                  //             : MessageView(),
                  IndexedStack(
                index: model.currentIndex,
                children: [
                  HomeView(),
                  FriendsView(),
                  NotificationsView(),
                  MessageView(),
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                onPressed: model.addNewPost,
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0.0,
                child: Icon(
                  Icons.add,
                  size: 33,
                ),
              ),
              extendBody: true,
              resizeToAvoidBottomInset: false,
              bottomNavigationBar: BottomNavBar(
                selectedIndex: model.currentIndex,
                onIndexChange: (index) {
                  model.setIndex(index);
                },
              ),
            ));
  }
}
