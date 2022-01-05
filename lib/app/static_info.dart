import 'package:get/get.dart';
import 'package:kollokvie/models/user_model.dart';

class StaticInfo {
  static Rx<UserModel> userModel = UserModel().obs;
}
