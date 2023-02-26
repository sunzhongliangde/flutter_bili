import 'package:flutter/material.dart';

import '../util/color.dart';

class HiTab extends StatelessWidget {
  final List<Widget> tabs;
  final TabController controller;
  final double? fontSize;
  final double? borderWidth;
  final EdgeInsetsGeometry? insets;
  final Color? unselectedLabelColor;

  const HiTab(this.tabs,
      {super.key,
      required this.controller,
      this.fontSize = 16,
      this.borderWidth = 2,
      this.insets = const EdgeInsets.only(left: 15, right: 15),
      this.unselectedLabelColor = Colors.black54});

  @override
  Widget build(BuildContext context) {
    return TabBar(
        controller: controller,
        isScrollable: true,
        labelColor: primary,
        unselectedLabelColor: unselectedLabelColor,
        labelStyle: TextStyle(fontSize: fontSize),
        indicator: UnderlineTabIndicator(
          borderRadius: BorderRadius.circular(borderWidth! / 2),
          borderSide: BorderSide(color: primary, width: borderWidth!),
          insets: insets!,
        ),
        tabs: tabs);
  }
}
