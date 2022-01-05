import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kollokvie/models/user_model.dart';
import 'package:kollokvie/view/ui/profile/profile_view.dart';
import 'package:kollokvie/view/widgets/round_image.dart';

class FriendsRequestWidget extends StatelessWidget {
  final UserModel userModel;
  final Function onAccept;
  final Function onReject;

  FriendsRequestWidget(
      {@required this.userModel, this.onAccept, this.onReject});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => ProfileView(
              userId: userModel.id,
              viewOnly: true,
            ));
      },
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Color(0x4cd3d1d8),
                blurRadius: 6,
                spreadRadius: 1,
                offset: Offset(0, 0),
              ),
            ],
            border: Border.all(color: Theme.of(context).primaryColorDark),
            color: Colors.white),
        child: Row(
          children: [
            RoundImage(
              imageUrl: userModel.imageUrl,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          userModel.name.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 12,
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            color: const Color(0xff4c3f58),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        userModel.fieldOfStudy + " , " + userModel.semester,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: const Color(0xff7b7b7b),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: onAccept,
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(6)),
                            child: Center(
                              child: Text(
                                "Accept",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: onReject,
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: Theme.of(context).primaryColor)),
                            child: Center(
                              child: Text(
                                "Reject",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
