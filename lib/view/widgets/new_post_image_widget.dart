import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kollokvie/view/ui/new_post/new_post_viewmodel.dart';

class NewPostImageWidget extends StatelessWidget {
  final NewPostViewModel model;

  NewPostImageWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: Get.width,
          child: Image.file(
            File(model.postImage),
            gaplessPlayback: true,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: model.clearImage,
            child: Container(
              height: 60,
              margin: EdgeInsets.all(6),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.clear,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
