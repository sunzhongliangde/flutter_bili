import 'package:flutter/material.dart';
import 'package:flutter_bili/page/home_page.dart';
import 'package:flutter_bili/page/login_page.dart';
import 'package:flutter_bili/page/regiatration_page.dart';
import 'package:flutter_bili/page/video_detail_page.dart';

/// 创建页面
pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
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