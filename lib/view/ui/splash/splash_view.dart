import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:kollokvie/view/ui/splash/splash_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Spacer(),
            Container(
                margin: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
                child: Image.asset(
                  "assets/logo.png",
                  color: Theme.of(context).primaryColor,
                )),
            Spacer(),
          ],
        ),
      ),
      onModelReady: (model) => SchedulerBinding.instance
          .addPostFrameCallback((_) => model.initialise()),
      viewModelBuilder: () => SplashViewModel(),
    );
  }
}
