import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tajeer/view/widgets/drawer_item.dart';

class DrawerView extends StatefulWidget {
  const DrawerView({Key key}) : super(key: key);

  @override
  _DrawerViewState createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.27,
              color: Theme.of(context).primaryColor),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.06,
                vertical: MediaQuery.of(context).size.height * 0.03),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Image.asset(
                        "assets/menu.png",
                        color: Color.fromRGBO(255, 255, 255, 1),
                        height: 25,
                        width: 25,
                      ),
                    ),
                  ),
                  Container(
                    child: Image.asset(
                      "assets/logo.png",
                      height: MediaQuery.of(context).size.width * 0.2,
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ),
                ]),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.22,
            top: MediaQuery.of(context).size.width * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                InkWell(
                  onTap: () {
                    // Get.to(() => EditProfileView());
                  },
                  child: DrawerItem(
                    icon: Icons.person_pin,
                    title: "Edit Profile",
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                InkWell(
                  onTap: () {},
                  child: DrawerItem(
                    icon: Icons.local_offer_outlined,
                    title: "View Offers",
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                InkWell(
                  onTap: () {},
                  child: DrawerItem(
                    icon: Icons.list_alt_outlined,
                    title: "View Past Owners",
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                InkWell(
                  onTap: () {},
                  child: DrawerItem(
                    icon: Icons.supervised_user_circle_sharp,
                    title: "View Past Renters",
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
              ],
            ),
          ),
        ],
        clipBehavior: Clip.none,
        // overflow: Overflow.visible,
      ),
    );
  }
}
