import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoEventWidget extends StatelessWidget {
  final bool isFromCompleted;
  final String title;

  NoEventWidget(this.isFromCompleted,
      {this.title = "You haven't make any post"});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: Get.height * 0.12,
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
            child: Image.asset("assets/empty.jfif")),
        SizedBox(
          height: 10,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
