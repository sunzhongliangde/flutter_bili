import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bili/util/color.dart';
import 'package:flutter_bili/util/hi_constants.dart';

import '../db/hi_cache.dart';

/// 为了保存上一次选择的app主题模式，扩展枚举，以便保存在本地
/// （枚举值不能直接保存在本地）
extension ThemeModeExtension on ThemeMode {
  String get value => <String>['System', 'Light', 'Dark'][index];
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  // 系统dark mode发生变化
  var platformBrightnes = SchedulerBinding.instance.window.platformBrightness;
  void darkModeChange() {
    if (platformBrightnes != SchedulerBinding.instance.window.platformBrightness) {
      platformBrightnes = SchedulerBinding.instance.window.platformBrightness;
      notifyListeners(); 
    }
  }

  // 判断是否是暗黑模式
  bool isDark() {
    // 获取系统的darkMode模式
    if (getThemeMode() == ThemeMode.system) {
      return SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
    }
    return getThemeMode() == ThemeMode.dark;
  }

  /// 获取主题模式
  ThemeMode getThemeMode() {
    // 取出本地保存的主题
    String? theme = HiCache.getInstance().get(HiConstants.theme);
    switch (theme) {
      case 'Dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'System':
        _themeMode = ThemeMode.system;
        break;
      default:
        _themeMode = ThemeMode.light;
        break;
    }
    return _themeMode;
  }

  /// 设置主题
  void setTheme(ThemeMode themeMode) {
    HiCache.getInstance().setString(HiConstants.theme, themeMode.value);
    // 通知订阅者，发生状态改变
    notifyListeners();
  }

  /// 获取主题值
  ThemeData getTheme({bool isDarkMode = false}) {
    var themeData = ThemeData(
      // 亮度
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      // 错误状态颜色
      // errorColor: isDarkMode ? HiColor.dark_red : HiColor.red,
      // 主色调(比如icon的色调)
      primaryColor: isDarkMode ? HiColor.dark_bg : white, // primaryColor is deprecated
      // 文字的强调色
      // accentColor: isDarkMode ? primary[50] : white, // accentColor is deprecated, not reference
      // Tab指示器的颜色
      indicatorColor: isDarkMode ? primary[50] : white,
      // 页面背景色
      scaffoldBackgroundColor: isDarkMode ? HiColor.dark_bg : white,
    );

    return themeData;
  }
}
