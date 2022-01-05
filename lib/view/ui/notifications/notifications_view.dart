import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:kollokvie/app/constants.dart';
import 'package:kollokvie/view/widgets/notification_widget.dart';
import 'package:stacked/stacked.dart';

import 'notifications_viewmodel.dart';

class NotificationsView extends StatefulWidget {
  @override
  _NotificationsViewState createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  ScrollController _notificationController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationsViewModel>.reactive(
        viewModelBuilder: () => NotificationsViewModel(),
        onModelReady: (model) => SchedulerBinding.instance
            .addPostFrameCallback((_) => model.initialise()),
        builder: (context, model, child) => Scaffold(
              body: RefreshIndicator(
                onRefresh: () {
                  return model.initialise();
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: Get.height,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: hMargin, vertical: vMargin),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "All Notifications",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Expanded(
                                  child: model.loading
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : model.msg != ""
                                          ? Center(
                                              child: Text(
                                              model.msg,
                                              textAlign: TextAlign.center,
                                            ))
                                          : RefreshIndicator(
                                              onRefresh: () {
                                                return model.initialise();
                                              },
                                              child: RawScrollbar(
                                                thumbColor: Theme.of(context)
                                                    .primaryColor,
                                                isAlwaysShown: true,
                                                controller:
                                                    _notificationController,
                                                child: ListView.builder(
                                                    itemCount: model
                                                        .myNotifications.length,
                                                    controller:
                                                        _notificationController,
                                                    padding: EdgeInsets.all(5),
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemBuilder: (_, index) {
                                                      return NotificationWidget(
                                                        notificationModel: model
                                                                .myNotifications[
                                                            index],
                                                        onDelete: () {
                                                          model
                                                              .deleteNotifiction(
                                                                  index);
                                                        },
                                                      );
                                                    }),
                                              ),
                                            ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
