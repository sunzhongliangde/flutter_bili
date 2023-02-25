import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/widget/navigation_bar.dart';
import 'package:status_bar_control/status_bar_control.dart';

Widget cachedImage(String url, {double? width, double? height}) {
  return CachedNetworkImage(
    imageUrl: url,
    width: width,
    height: height,
    fit: BoxFit.cover,
    placeholder: (BuildContext context, String url) => Container(
      color: Colors.grey[200],
    ),
    errorWidget: (BuildContext context, String url, dynamic error) =>
        const Icon(Icons.error),
  );
}

///黑色线性渐变
blackLinearGradient({bool fromTop = false}) {
  return LinearGradient(
      begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
      end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
      colors: const [
        Colors.black54,
        Colors.black45,
        Colors.black38,
        Colors.black26,
        Colors.black12,
        Colors.transparent
      ]);
}

void changeStatusBarStyle(
    {color = Colors.white, StatusStyle statusStyle = StatusStyle.darkContent}) {
  StatusBarControl.setColor(color!);
  var style = statusStyle;
  if (style == StatusStyle.darkContent) {
    StatusBarControl.setStyle(StatusBarStyle.DARK_CONTENT);
  } else {
    StatusBarControl.setStyle(StatusBarStyle.LIGHT_CONTENT);
  }
}
