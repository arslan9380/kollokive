import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kollokvie/view/ui/splash/splash_view.dart';

import 'app/locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());
}

///-------------------------------------------------
///   MyWhatsapp +923039380800
///   My email : mian.arslan9380@gmail.com
///   ping me so i can add you on firebase
///   -----------------------------------------------

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Kollokive",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xfffe724c),
        accentColor: Color(0xff131212),
        primaryColorDark: Colors.black,
        primaryColorLight: Color(0x999796a1),
        appBarTheme: AppBarTheme(
            color: Colors.white,
            iconTheme: IconThemeData(
              color: Color(0xff131212),
            )),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: SplashView(),
    );
  }
}
