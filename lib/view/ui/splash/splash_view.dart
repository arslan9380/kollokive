import 'package:event_app/view/ui/splash/splash_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: [
            Image.asset("assets/top_image.png"),
            Spacer(),
            Hero(tag: "logo", child: Image.asset("assets/logo.png")),
            Spacer(),
            Image.asset("assets/bottom_image.png"),
          ],
        ),
      ),
      onModelReady: (model) => SchedulerBinding.instance
          .addPostFrameCallback((_) => model.initialise()),
      viewModelBuilder: () => SplashViewModel(),
    );
  }
}
