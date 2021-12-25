import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';
import 'package:tajeer/app/constants.dart';
import 'package:tajeer/app/locator.dart';
import 'package:tajeer/view/ui/home/home_viewmodel.dart';
import 'package:tajeer/view/widgets/post_box.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => locator<HomeViewModel>(),
        disposeViewModel: false,
        createNewModelOnInsert: true,
        initialiseSpecialViewModelsOnce: true,
        fireOnModelReadyOnce: true,
        onModelReady: (model) => SchedulerBinding.instance
            .addPostFrameCallback((_) => model.getData()),
        builder: (context, model, child) => Scaffold(
              body: model.loading
                  ? Center(child: CircularProgressIndicator())
                  : model.msg != ""
                      ? Center(
                          child: Text(
                          model.msg,
                          textAlign: TextAlign.center,
                        ))
                      : SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: hMargin, vertical: vMargin),
                            child: Column(
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: model.allPost.length,
                                    itemBuilder: (_, index) {
                                      return PostBox(
                                        model.allPost[index],
                                        model.allPost[index].id,
                                        model: model,
                                      );
                                    })
                              ],
                            ),
                          ),
                        ),
            ));
  }
}
