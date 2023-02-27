import 'package:flutter/material.dart';
import 'package:flutter_bili/provider/theme_provider.dart';
import 'package:provider/provider.dart';

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
    var themeProvider = context.watch<ThemeProvider>();
    var noSelectedColor = themeProvider.isDark() ? Colors.white70 : unselectedLabelColor;

    return TabBar(
        controller: controller,
        isScrollable: true,
        labelColor: primary,
        unselectedLabelColor: noSelectedColor,
        labelStyle: TextStyle(fontSize: fontSize),
        indicator: UnderlineTabIndicator(
          borderRadius: BorderRadius.circular(borderWidth! / 2),
          borderSide: BorderSide(color: primary, width: borderWidth!),
          insets: insets!,
        ),
        tabs: tabs);
  }
}
