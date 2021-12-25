import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RectImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final double cornerRadius;

  RectImage(
      {this.imageUrl = "",
      this.width = 72.0,
      this.height = 92,
      this.cornerRadius = 10});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      color: Theme.of(context).accentColor,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(cornerRadius),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(cornerRadius),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/image-loader.gif"))),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(cornerRadius),
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage("assets/logo.png"))),
      ),
    );
  }
}
