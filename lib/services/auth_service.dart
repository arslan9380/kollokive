import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:kollokvie/app/locator.dart';
import 'package:kollokvie/app/static_info.dart';
import 'package:kollokvie/models/user_model.dart';
import 'package:kollokvie/view/ui/login/login_view.dart';

import 'image_service.dart';
import 'notification_service.dart';

class AuthStatus {
  static const String ERROR_WEAK_PASSWORD = 'weak-password';
  static const String ERROR_INVALID_EMAIL = 'invalid-email';
  static const String ERROR_EMAIL_ALREADY_IN_USE = 'email-already-in-use';
  static const String ERROR_WRONG_PASSWORD = 'ERROR_WRONG_PASSWORD';
  static const String ERROR_USER_NOT_FOUND = 'user-not-found';
}

@lazySingleton
class AuthService {
  final _usersKey = 'users';
  ImageService imageService = locator<ImageService>();

  Future<String> signUp(UserModel user, String password) async {
    try {
      print(user.email);
      print(password);
      UserCredential authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email, password: password ?? 123456);
      print(authResult.user.email);
      user.id = authResult.user.uid;
      var saveResult = await saveUser(user);
      if (saveResult != "success") return saveResult;
      StaticInfo.userModel.value = user;
      return "success";
    } on FirebaseAuthException catch (error) {
      print("error in SigningUp the user : ${error?.code}");
      return "${error.code}";
    }
  }

  Future<String> login(String email, String password) async {
    try {
      var responseToBeReturned;
      var authResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      var response = await getUser(authResult.user.uid);
      updateFcm();
      if (response != null) {
        StaticInfo.userModel.value = response;
        responseToBeReturned = "success";
      } else {
        responseToBeReturned = "fail";
      }
      return responseToBeReturned;
    } on FirebaseAuthException catch (error) {
      print("Erro in logging the user : ${error?.message}//////");
      return "${error?.code}";
    }
  }

  Future<dynamic> getCurrentUser() async {
    var result = FirebaseAuth.instance.currentUser;
    var responseToBerReturned;
    if (result == null) {
      responseToBerReturned = false;
    } else {
      var response = await getUser(result.uid);
      print(response);
      if (response != null) {
        StaticInfo.userModel = response;
        responseToBerReturned = true;
      } else {
        print("returning fill details");
        responseToBerReturned = "fill details";
      }
    }
    print(responseToBerReturned);
    return responseToBerReturned;
  }

  Future<String> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      return "success";
    } catch (err) {
      return err.code;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    StaticInfo.userModel = null;
    Get.offAll(() => LoginView());
  }

  Future<String> saveUser(UserModel user) async {
    try {
      if (!user.imageUrl.contains("http")) {
        String url = await imageService.saveFiles(user.imageUrl, "Images");
        if (url == null) return "fail";
        user.imageUrl = url;
      }
      String fcm = await locator<NotificationService>().getFcmToken();
      user.fcm = fcm;
      await FirebaseFirestore.instance
          .collection(_usersKey)
          .doc(user.id)
          .set(user.toMap(), SetOptions(merge: true));
      return "success";
    } catch (e) {
      print("error in Saving user");

      return e;
    }
  }

  Future<dynamic> getUser(String uid) async {
    try {
      UserModel user = UserModel.fromMap((await FirebaseFirestore.instance
              .collection(_usersKey)
              .doc(uid)
              .get())
          .data());
      return user;
    } catch (e) {
      print("Error in assigning static info :$e");
      return e;
    }
  }

  getAllUser() async {
    try {
      List<UserModel> allUsers = [];
      var result = await FirebaseFirestore.instance
          .collection(_usersKey)
          .where("id", isNotEqualTo: StaticInfo.userModel.value.id)
          .get();
      for (var doc in result.docs) {
        allUsers.add(UserModel.fromMap(doc.data()));
      }
      return allUsers;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future updateFcm() async {
    String fcm = await locator<NotificationService>().getFcmToken();
    await FirebaseFirestore.instance
        .collection(_usersKey)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({"fcm": fcm}, SetOptions(merge: true));
    return;
  }
}
