import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserCircularPhoto extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;
  final photo;
  final double size;
  final bool fromFile;

  const UserCircularPhoto(
      {Key key,
      this.animationController,
      this.animation,
      this.photo,
      this.size = 72,
      this.fromFile = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: fromFile
            ? Image.file(
                photo.data,
                fit: BoxFit.fill,
              )
            : CachedNetworkImage(
                imageUrl: photo,
                placeholder: (context, url) => Container(
                  margin: EdgeInsets.all(12),
                  width: 20,
                  height: 20,
                  child: new CircularProgressIndicator(
                    strokeWidth: 1.5,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
      ),
    );
  }
}
