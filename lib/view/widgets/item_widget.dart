import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajeer/models/item_model.dart';
import 'package:tajeer/view/ui/profile/profile_viewmodel.dart';
import 'package:tajeer/view/widgets/rect_image.dart';

class ItemWidget extends StatelessWidget {
  final bool isFavourite;
  final bool isFromPublish;
  final bool isFromHide;
  final ItemModel itemModel;
  final Function onFavouriteTap;
  final ProfileViewModel model;

  ItemWidget(
      {this.isFavourite = false,
      this.isFromPublish = false,
      this.isFromHide = false,
      this.itemModel,
      this.onFavouriteTap,
      this.model});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 327,
        height: 112,
        margin: EdgeInsets.only(
            bottom: Get.height * 0.025, right: Get.width * 0.03),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x4cd3d1d8),
              blurRadius: 6,
              spreadRadius: 5,
              offset: Offset(0, 0),
            ),
          ],
        ),
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RectImage(
              imageUrl: itemModel.image,
            ),
            SizedBox(
              width: 6,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          itemModel.title,
                          presetFontSizes: [18, 16, 14],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (isFavourite)
                        InkWell(
                          onTap: onFavouriteTap,
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        ),
                      if (isFromHide || isFromPublish)
                        PopupMenuButton(
                          onSelected: (String value) async {},
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Edit',
                              child: Text('Edit'),
                            ),
                            PopupMenuItem<String>(
                              value: isFromHide ? "Publish" : 'Hide',
                              child: Text(isFromHide ? "Publish" : 'Hide'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Delete',
                              child: Text('Delete'),
                            ),
                          ],
                          child: Icon(
                            Icons.more_vert,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                    ],
                  ),
                  AutoSizeText(
                    "By " + itemModel.addedByName,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Text(
                    itemModel.location,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Rent/Day : ${itemModel.rentPerDay}\$",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
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
