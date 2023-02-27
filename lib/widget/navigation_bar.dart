import 'package:flutter/material.dart';
import 'package:flutter_bili/provider/theme_provider.dart';
import 'package:flutter_bili/util/color.dart';
import 'package:flutter_bili/util/view_util.dart';
import 'package:provider/provider.dart';

enum StatusStyle { lightContent, darkContent }

/// 沉浸式状态栏
class NavigationStyleBar extends StatefulWidget {
  final StatusStyle statusStyle;
  final Color color;
  final double height;
  final Widget? child;

  const NavigationStyleBar(
      {Key? key,
      this.statusStyle = StatusStyle.darkContent,
      this.color = Colors.white,
      this.height = 46,
      this.child})
      : super(key: key);

  @override
  State<NavigationStyleBar> createState() => _NavigationStyleBarState();
}

class _NavigationStyleBarState extends State<NavigationStyleBar> {
  StatusStyle? _statusStyle;
  Color? _color;

  @override
  Widget build(BuildContext context) {
    // 读取provider数据
    var themeProvider = context.watch<ThemeProvider>();
    if (themeProvider.isDark()) {
      _color = HiColor.dark_bg;
      _statusStyle = StatusStyle.lightContent;
    } else {
      _color = widget.color;
      _statusStyle = widget.statusStyle;
    }
    // 重置主题
    _statusBarInit();
    // 状态栏高度
    var top = MediaQuery.of(context).padding.top;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: top + widget.height,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: _color),
      child: widget.child,
    );
  }

  void _statusBarInit() {
    //沉浸式状态栏
    changeStatusBarStyle(color: _color, statusStyle: _statusStyle!);
  }
}
