import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kollokvie/view/widgets/round_image.dart';

class ProfileImageWidget extends StatelessWidget {
  final String imagePath;

  ProfileImageWidget(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            imagePath != null
                ? RoundImage(
                    radius: Get.width * 0.3,
                    showBorder: false,
                  )
                : Container(
                    height: Get.width * 0.1,
                    width: Get.width * 0.1,
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    child: Icon(
                      Icons.add,
                      size: 33,
                    )),
            Container(
              height: Get.width * 0.1,
              width: Get.width * 0.1,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                color: Theme.of(context).primaryColor,
              ),
              child: Icon(
                Icons.camera_alt_sharp,
                color: Colors.white,
                size: 18,
              ),
            )
          ],
        ));
  }
}
