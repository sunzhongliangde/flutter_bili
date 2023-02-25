import 'package:flutter/material.dart';
import 'package:flutter_bili/util/view_util.dart';

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
  @override
  void initState() {
    super.initState();
    _statusBarInit();
  }

  @override
  Widget build(BuildContext context) {
    //状态栏高度
    var top = MediaQuery.of(context).padding.top;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: top + widget.height,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: widget.color),
      child: widget.child,
    );
  }

  void _statusBarInit() {
    //沉浸式状态栏
    changeStatusBarStyle(color: widget.color, statusStyle: widget.statusStyle);
  }
}
