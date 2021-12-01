import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajeer/view/ui/splash/splash_view.dart';

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
        primaryColorDark: Colors.white,
        primaryColorLight: Color(0x999796a1),
        appBarTheme: AppBarTheme(
          color: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: SplashView(),
    );
  }
}
