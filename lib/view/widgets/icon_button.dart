import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final double margin;

  IconButtonWidget({this.icon, this.margin = 8.0});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(9),
        margin: EdgeInsets.all(margin),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Color(0x4cd3d1d8),
              blurRadius: 6,
              spreadRadius: 1,
              offset: Offset(0, 0),
            ),
          ],
          color: Colors.white,
        ),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColorDark,
        ));
  }
}
