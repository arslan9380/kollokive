import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajeer/view/ui/new_post/new_post_viewmodel.dart';

class NewPostBottomWidget extends StatelessWidget {
  final NewPostViewModel model;

  NewPostBottomWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              model.pickImage(true);
            },
            child: Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    //                   <--- left side
                    color: Color(0xffA4A4A4),
                    width: 1.0,
                  ),
                  top: BorderSide(
                    //                    <--- top side
                    color: Color(0xffA4A4A4),
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 56,
                    margin: EdgeInsets.all(2),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Capture from Camera",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      color: const Color(0xff4c3f58),
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              model.pickImage(false);

              //   Navigator.push(context, MaterialPageRoute(builder: (context) {
              //     return ImageEditorPro(
              //       appBarColor: Theme.of(context).primaryColor,
              //       bottomBarColor: Theme.of(context).primaryColor,
              //     );
              //   })).then((geteditimage) {
              //     if (geteditimage != null) {
              //       File editedImage = geteditimage;
              //       print(editedImage.path);
              //     }
              //   }).catchError((er) {
              //     print(er);
              //   });
            },
            child: Container(
              width: Get.width,
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 56,
                    margin: EdgeInsets.all(2),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.photo,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Choose From Gallery",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      color: const Color(0xff4c3f58),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
