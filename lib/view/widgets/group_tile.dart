import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class GroupTile extends StatelessWidget {
  final String userName;
  final String groupId;
  final String groupName;

  GroupTile({this.userName, this.groupId, this.groupName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // Navigator.push(
          //     context,
          // MaterialPageRoute(
          //     builder: (context) => GroupChatView(
          //           groupId: groupId,
          //           userName: userName,
          //           groupName: groupName,
          //         )));
        },
        child: Container(
            margin: EdgeInsets.only(
              bottom: 12,
            ),
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              secondaryActions: [
                InkWell(
                  onTap: () {},
                  child: IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () {},
                  ),
                )
              ],
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3fd3d1d8),
                      blurRadius: 45,
                      offset: Offset(18.21, 18.21),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.blueAccent,
                    child: Text(groupName.substring(0, 1).toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white)),
                  ),
                  title: Text(groupName,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Join the conversation as $userName",
                      style: TextStyle(fontSize: 12.0)),
                ),
              ),
            )));
  }
}
