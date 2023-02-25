import 'package:flutter/material.dart';
import 'package:status_bar_control/status_bar_control.dart';

enum StatusStyle { lightContent, darkContent }

/// 沉浸式状态栏
class NavigationStyleBar extends StatelessWidget {
  final StatusStyle? statusStyle;
  final Color? color;
  final double? height;
  final Widget child;

  const NavigationStyleBar(
      {super.key,
      this.statusStyle = StatusStyle.darkContent,
      this.color = Colors.white,
      this.height = 46,
      required this.child});

  @override
  Widget build(BuildContext context) {
    _statusBarInit();
    // 刘海的高度
    var top = MediaQuery.of(context).padding.top;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height! + top,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: color),
      child: child,
    );
  }

  void _statusBarInit() {
    // 沉浸式状态栏样式
    StatusBarControl.setColor(color!);
    var style = statusStyle ?? StatusStyle.darkContent;
    if (style == StatusStyle.darkContent) {
      StatusBarControl.setStyle(StatusBarStyle.DARK_CONTENT);
    } else {
      StatusBarControl.setStyle(StatusBarStyle.LIGHT_CONTENT);
    }
  }
}
