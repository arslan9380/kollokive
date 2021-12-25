import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'icon_button.dart';

class ViewImage extends StatefulWidget {
  final Widget imageWidget;
  final String heroId;

  ViewImage(this.imageWidget, this.heroId);

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              Container(
                // height: Get.height * 0.8,
                width: Get.width,
                child: Center(
                  child: InteractiveViewer(
                    panEnabled: false,
                    boundaryMargin: EdgeInsets.all(100),
                    minScale: 0.5,
                    maxScale: 2.5,
                    child: Hero(tag: widget.heroId, child: widget.imageWidget),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 12, top: 12, bottom: 12),
                        child:
                            IconButtonWidget(icon: Icons.arrow_back_ios_sharp)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
