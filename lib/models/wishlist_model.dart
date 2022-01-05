import 'package:kollokvie/models/item_model.dart';

class WishlistModel {
  String id;
  String addedBy;
  String itemId;
  ItemModel itemModel;

  WishlistModel({this.id, this.addedBy, this.itemModel, this.itemId});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'addedBy': this.addedBy,
      'itemModel': this.itemModel.toMap(),
      'itemId': this.itemId
    };
  }

  factory WishlistModel.fromMap(Map<String, dynamic> map) {
    return WishlistModel(
      id: map['id'] as String,
      addedBy: map['addedBy'] as String,
      itemId: map['itemId'] as String,
      itemModel: ItemModel.fromMap(map['itemModel']),
    );
  }
}
