import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../navigator/hi_navigator.dart';
import '../provider/theme_provider.dart';
import '../util/view_util.dart';

class DarkModelItem extends StatelessWidget {
  const DarkModelItem({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var icon = themeProvider.isDark()
        ? Icons.nightlight_round
        : Icons.wb_sunny_rounded;
    return InkWell(
      onTap: () {
        HiNavigator.getInstance().onJumpTo(RouteStatus.darkModePage);
      },
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 15, bottom: 15),
        margin: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(border: borderLine(context)),
        child: Row(
          children: [
            const Text('夜间模式',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Padding(
                padding: const EdgeInsets.only(top: 2, left: 10),
                child: Icon(icon))
          ],
        ),
      ),
    );
  }
}
