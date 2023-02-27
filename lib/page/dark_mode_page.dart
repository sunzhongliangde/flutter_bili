import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';
import '../util/color.dart';

///夜间模式页面
class DarkModePage extends StatefulWidget {
  const DarkModePage({super.key});

  @override
  State<DarkModePage> createState() => _DarkModePageState();
}

class _DarkModePageState extends State<DarkModePage> {
  static const items = [
    {"name": '跟随系统', "mode": ThemeMode.system},
    {"name": '开启', "mode": ThemeMode.dark},
    {"name": '关闭', "mode": ThemeMode.light},
  ];
  var _currentTheme;

  @override
  void initState() {
    super.initState();
    var themeMode = context.read<ThemeProvider>().getThemeMode();
    items.forEach((element) {
      if (element['mode'] == themeMode) {
        _currentTheme = element;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('夜间模式')),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return _item(index);
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          itemCount: items.length),
    );
  }

  Widget _item(int index) {
    var theme = items[index];
    return InkWell(
      onTap: () {
        _switchTheme(index);
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 50,
        child: Row(
          children: [
            Expanded(child: Text(theme['name'] as String)),
            Opacity(
                opacity: _currentTheme == theme ? 1 : 0,
                child: const Icon(Icons.done, color: primary))
          ],
        ),
      ),
    );
  }

  void _switchTheme(int index) {
    var theme = items[index];
    context.read<ThemeProvider>().setTheme(theme['mode'] as ThemeMode);
    setState(() {
      _currentTheme = theme;
    });
  }
}
