import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/navigator/hi_navigator.dart';
import 'package:flutter_bili/page/profile_page.dart';
import 'package:flutter_bili/page/video_detail_page.dart';
import 'package:flutter_bili/provider/theme_provider.dart';
import 'package:flutter_bili/util/color.dart';
import 'package:flutter_bili/util/format_util.dart';
import 'package:flutter_bili/widget/navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:status_bar_control/status_bar_control.dart';

/// 带磁盘缓存的图片
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

/// 黑色线性渐变
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

/// 更改状态栏style
void changeStatusBarStyle(
    {color = Colors.white,
    StatusStyle statusStyle = StatusStyle.darkContent,
    BuildContext? context}) {
  if (context != null) {
    var themeProvider = context.watch<ThemeProvider>();
    if (themeProvider.isDark()) {
      statusStyle = StatusStyle.lightContent;
      color = HiColor.dark_bg;
    }
  }
  var page = HiNavigator.getInstance().getCurrent()?.widget;
  if (page is ProfilePage) {
    color = Colors.transparent;
  } else if (page is VideoDetailPage) {
    color = Colors.black;
  }
  StatusBarControl.setColor(color!);
  var style = statusStyle;
  if (style == StatusStyle.darkContent) {
    StatusBarControl.setStyle(StatusBarStyle.DARK_CONTENT);
  } else {
    StatusBarControl.setStyle(StatusBarStyle.LIGHT_CONTENT);
  }
}

/// 底部阴影
BoxDecoration? bottomBoxShadow(BuildContext context) {
  var themeProvider = context.watch<ThemeProvider>();
  // 暗黑模式，不添加底部阴影
  if (themeProvider.isDark()) {
    return null;
  }

  return BoxDecoration(color: Colors.white, boxShadow: [
    BoxShadow(
      color: Colors.grey[100] ?? Colors.grey,
      offset: const Offset(0, 5),
      blurRadius: 5, // 模糊度
      spreadRadius: 1, // 阴影扩散度
    )
  ]);
}

/// 左边图标，右边文字
smallIconText(IconData iconData, dynamic text) {
  var style = const TextStyle(fontSize: 12, color: Colors.grey);
  var textStr = "";
  if (text is int) {
    textStr = countFormat(text);
  } else {
    textStr = text;
  }
  return [
    Icon(
      iconData,
      color: Colors.grey,
      size: 12,
    ),
    Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        textStr,
        style: style,
      ),
    )
  ];
}

// 生成border线条
borderLine(BuildContext context, {bottom = true, top = false}) {
  BorderSide side = BorderSide(width: 0.5, color: Colors.grey[200]!);
  return Border(
    bottom: bottom ? side : BorderSide.none,
    top: top ? side : BorderSide.none,
  );
}

/// 生成间距
SizedBox hiSpace({double height = 1, double width = 1}) {
  return SizedBox(
    height: height,
    width: width,
  );
}
