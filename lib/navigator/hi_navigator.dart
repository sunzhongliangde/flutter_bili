import 'package:flutter/material.dart';
import 'package:flutter_bili/page/home_page.dart';
import 'package:flutter_bili/page/login_page.dart';
import 'package:flutter_bili/page/regiatration_page.dart';
import 'package:flutter_bili/page/video_detail_page.dart';

typedef RouteChangeListener(RouteStatusInfo current, RouteStatusInfo? pre);

/// 创建页面
pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}

// 获取routeStatus在页面栈中的位置
int getPageIndex(List<MaterialPage> pages, RouteStatus status) {
  for (var i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == status) {
      return i;
    }
  }
  return -1;
}

// 自定义路由， 路由状态
enum RouteStatus {
  login,
  registration,
  home,
  detail,
  unknow,
}

// 获取page对应的RouteStatus
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  } else if (page.child is HomePage) {
    return RouteStatus.home;
  } else if (page.child is VideoDetailPage) {
    return RouteStatus.detail;
  }
  return RouteStatus.unknow;
}

// 路由信息
class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget widget;

  RouteStatusInfo(this.routeStatus, this.widget);
}

// 监听路由页面状态
// 感知页面是否被压后台
class HiNavigator extends _RouteJumpListener {
  HiNavigator._();

  RouteJumpListener? _routeJump;
  final List<RouteChangeListener> _listeners = [];
  RouteStatusInfo? _current;

  static HiNavigator? _instance;
  static HiNavigator getInstance() {
    _instance ??= HiNavigator._();
    return _instance!;
  }

  // 注册路由跳转逻辑
  void registationRouteJump(RouteJumpListener listener) {
    _routeJump = listener;
  }

  // 监听路由页面跳转
  void addListener(RouteChangeListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  // 移除监听
  void removeListener(RouteChangeListener listener) {
    _listeners.remove(listener);
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    if (_routeJump != null) {
      _routeJump!.onJumpTo(routeStatus, args: args);
    }
  }

  // 通知路由页面变化
  void notify(List<MaterialPage> currentPage, List<MaterialPage> pre) {
    if (currentPage == pre) {
      return;
    }
    var current =
        RouteStatusInfo(getStatus(currentPage.last), currentPage.last.child);
    _notify(current);
  }

  void _notify(RouteStatusInfo current) {
    for (var listener in _listeners) {
      listener(current, _current);
    }
    _current = current;
  }
}

/// 抽象类提供HiNavigator实现
abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map? args});
}

// 定义路由跳转逻辑要实现的功能
typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map? args});

class RouteJumpListener {
  final OnJumpTo onJumpTo;

  RouteJumpListener(this.onJumpTo);
}
