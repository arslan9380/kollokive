import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tajeer/app/constants.dart';
import 'package:tajeer/view/widgets/notification_widget.dart';

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
        builder: (context, model, child) => Scaffold(
              body: Column(
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
                            child: RawScrollbar(
                              thumbColor: Theme.of(context).primaryColor,
                              isAlwaysShown: true,
                              controller: _notificationController,
                              child: ListView.builder(
                                  itemCount: 8,
                                  controller: _notificationController,
                                  padding: EdgeInsets.all(5),
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (_, index) {
                                    return NotificationWidget();
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
