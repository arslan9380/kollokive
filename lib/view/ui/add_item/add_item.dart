import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stacked/stacked.dart';
import 'package:tajeer/app/constants.dart';
import 'package:tajeer/models/item_model.dart';
import 'package:tajeer/view/widgets/description_field.dart';
import 'package:tajeer/view/widgets/expand_option_widget.dart';
import 'package:tajeer/view/widgets/expandable_box.dart';
import 'package:tajeer/view/widgets/inputfield_widget.dart';

import 'add_item_viewmodel.dart';

class AddItemView extends StatefulWidget {
  final ItemModel itemModel;

  AddItemView({this.itemModel});

  @override
  _AddItemViewState createState() => _AddItemViewState();
}

class _AddItemViewState extends State<AddItemView> {
  TextEditingController titleCon = TextEditingController();
  TextEditingController locationCon = TextEditingController();
  TextEditingController rentCon = TextEditingController();
  TextEditingController descriptionCon = TextEditingController();

  @override
  void initState() {
    if (widget.itemModel != null) {
      presetData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddItemViewModel>.reactive(
        viewModelBuilder: () => AddItemViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                title: Text(
                  "ADD ITEM FOR RENT",
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
              ),
              body: ModalProgressHUD(
                inAsyncCall: model.loading,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          model.pickImage();
                        },
                        child: Container(
                          height: Get.width * 0.7,
                          width: Get.width,
                          child: model.itemImage != ""
                              ? Image.file(
                                  File(model.itemImage),
                                  fit: BoxFit.cover,
                                )
                              : widget.itemModel?.image != null
                                  ? Image.network(
                                      widget.itemModel.image,
                                      fit: BoxFit.cover,
                                    )
                                  : Center(
                                      child: Image.asset(
                                        "assets/image_placeholder.png",
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                        ),
                      ),
                      Divider(
                        height: 2,
                        thickness: 3,
                        color: Theme.of(context).primaryColor,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: hMargin, vertical: vMargin),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            InputFieldWidget(
                              hint: "Title",
                              controller: titleCon,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InputFieldWidget(
                              hint: "Location",
                              enable: true,
                              controller: locationCon,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InputFieldWidget(
                              hint: "Rent per day",
                              enable: true,
                              controller: rentCon,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                model.setExpanded();
                              },
                              child: InputFieldWidget(
                                hint: "Select Category",
                                enable: false,
                                controller: model.catCon,
                              ),
                            ),
                            Container(
                              constraints: BoxConstraints(maxHeight: 200),
                              margin: EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x26000000),
                                    blurRadius: 16,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              child: ExpandedSection(
                                expand: model.isExpanded,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 8,
                                  ),
                                  child: ListView.builder(
                                      itemCount: model.itemCats.length,
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.only(right: 16),
                                      itemBuilder: (_, index) {
                                        return InkWell(
                                          onTap: () {
                                            model.setEventType(
                                                model.itemCats[index]);
                                          },
                                          child: ExpandOptionWidget(
                                            title: model.itemCats[index],
                                            selectedValue: model.selectedCat,
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: Get.height * 0.3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.5),
                                border:
                                    Border.all(width: 1.0, color: Colors.grey),
                              ),
                              child: DescriptionField(
                                hint: "Description",
                                controller: descriptionCon,
                                maxLines: 1000,
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            InkWell(
                              onTap: () {
                                model.addItem(
                                    titleCon.text,
                                    locationCon.text,
                                    rentCon.text,
                                    descriptionCon.text,
                                    widget.itemModel);
                              },
                              child: Container(
                                width: Get.width * 0.7,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(27.5)),
                                child: Center(
                                  child: Text(
                                    "Publish Item",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  void presetData() {
    titleCon.text = widget.itemModel.title;
    locationCon.text = widget.itemModel.location;
    rentCon.text = widget.itemModel.rentPerDay;
    descriptionCon.text = widget.itemModel.description;
  }
}
