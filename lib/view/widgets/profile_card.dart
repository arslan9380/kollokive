import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kollokvie/models/user_model.dart';
import 'package:kollokvie/view/widgets/round_image.dart';

class ProfileCard extends StatelessWidget {
  final UserModel userModel;

  ProfileCard({@required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 200 + (Get.width * 0.15),
      child: Stack(
        children: [
          Container(
            height: 200,
            margin: EdgeInsets.only(top: 55),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    width: Get.width,
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 16, right: 16),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  // Text(
                  //   userModel.name,
                  //   style: TextStyle(
                  //       color: Color.fromRGBO(51, 51, 51, 1),
                  //       fontSize: 16,
                  //       height: 1.5),
                  // ),
                  // SizedBox(
                  //   height: 4,
                  // ),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                        text: "Name: ",
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                        children: <TextSpan>[
                          TextSpan(
                            text: userModel.name,
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 14),
                          ),
                        ]),
                  ),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                        text: "Age: ",
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                        children: <TextSpan>[
                          TextSpan(
                            text: userModel.age,
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 14),
                          ),
                        ]),
                  ),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                        text: "School: ",
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                        children: <TextSpan>[
                          TextSpan(
                            text: userModel.school,
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 14),
                          ),
                        ]),
                  ),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                        text: "Field of study: ",
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                        children: <TextSpan>[
                          TextSpan(
                            text: userModel.fieldOfStudy,
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 14),
                          ),
                        ]),
                  ),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                        text: "Semester: ",
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                        children: <TextSpan>[
                          TextSpan(
                            text: userModel.semester,
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 14),
                          ),
                        ]),
                  ),
                  // Text(
                  //   userModel.email,
                  //   style: TextStyle(
                  //     color: Color.fromRGBO(114, 112, 112, 1),
                  //     fontSize: 12,
                  //   ),
                  // ),
                  SizedBox(
                    height: 12,
                  ),
                  // Opacity(
                  //   opacity: 0.15,
                  //   child: Container(
                  //     height: 1,
                  //     decoration: BoxDecoration(
                  //         gradient: LinearGradient(
                  //       begin: Alignment.topCenter,
                  //       end: Alignment.bottomCenter,
                  //       colors: [Color(0xff56ccf2), Color(0xff2f80ed)],
                  //     )),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 12,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     // Column(
                  //     //   children: [
                  //     //     Text(
                  //     //       'Published',
                  //     //       style: TextStyle(
                  //     //           color: Color.fromRGBO(114, 112, 112, 1),
                  //     //           fontSize: 14,
                  //     //           height: 1.5 /*PERCENT not supported*/
                  //     //           ),
                  //     //     ),
                  //     //     Row(
                  //     //       crossAxisAlignment: CrossAxisAlignment.center,
                  //     //       children: [
                  //     //         Container(
                  //     //           height: 24,
                  //     //           width: 24,
                  //     //           child: Image.asset(
                  //     //             "assets/likes_icon.png",
                  //     //           ),
                  //     //         ),
                  //     //         SizedBox(
                  //     //           width: 4,
                  //     //         ),
                  //     //         Text(
                  //     //           '1.5k',
                  //     //           textAlign: TextAlign.left,
                  //     //           style: TextStyle(
                  //     //               color: Theme.of(context).primaryColor,
                  //     //               fontSize: 14,
                  //     //               height: 1.5),
                  //     //         )
                  //     //       ],
                  //     //     )
                  //     //   ],
                  //     // ),
                  //     // Column(
                  //     //   children: [
                  //     //     Text(
                  //     //       'Hides',
                  //     //       style: TextStyle(
                  //     //         color: Color.fromRGBO(114, 112, 112, 1),
                  //     //         fontSize: 14,
                  //     //       ),
                  //     //     ),
                  //     //     Row(
                  //     //       crossAxisAlignment: CrossAxisAlignment.center,
                  //     //       children: [
                  //     //         Container(
                  //     //           height: 24,
                  //     //           width: 24,
                  //     //           child: Image.asset(
                  //     //             "assets/followers_icon.png",
                  //     //           ),
                  //     //         ),
                  //     //         SizedBox(
                  //     //           width: 4,
                  //     //         ),
                  //     //         Text(
                  //     //           '0.5k',
                  //     //           textAlign: TextAlign.left,
                  //     //           style: TextStyle(
                  //     //               color: Theme.of(context).primaryColor,
                  //     //               fontSize: 14,
                  //     //               height: 1.5),
                  //     //         )
                  //     //       ],
                  //     //     )
                  //     //   ],
                  //     // ),
                  //     // Column(
                  //     //   children: [
                  //     //     Text(
                  //     //       'Rating',
                  //     //       style: TextStyle(
                  //     //         color: Color.fromRGBO(114, 112, 112, 1),
                  //     //         fontSize: 14,
                  //     //       ),
                  //     //     ),
                  //     //     Row(
                  //     //       crossAxisAlignment: CrossAxisAlignment.center,
                  //     //       children: [
                  //     //         Container(
                  //     //           height: 24,
                  //     //           width: 24,
                  //     //           child: Image.asset(
                  //     //             "assets/star.png",
                  //     //           ),
                  //     //         ),
                  //     //         SizedBox(
                  //     //           width: 4,
                  //     //         ),
                  //     //         Text(
                  //     //           '4.8',
                  //     //           textAlign: TextAlign.left,
                  //     //           style: TextStyle(
                  //     //               color: Theme.of(context).primaryColor,
                  //     //               fontSize: 14,
                  //     //               height: 1.5),
                  //     //         )
                  //     //       ],
                  //     //     )
                  //     //   ],
                  //     // )
                  //   ],
                  // )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: userModel.imageUrl.contains("http") == false
                ? Container(
                    height: Get.width * 0.3,
                    width: Get.width * 0.3,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(userModel.imageUrl)))),
                  )
                : RoundImage(
                    imageUrl: userModel.imageUrl,
                    radius: Get.width * 0.3,
                  ),
          ),
        ],
      ),
    );
  }
}
