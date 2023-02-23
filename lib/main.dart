import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bili/db/hi_cache.dart';
import 'package:flutter_bili/http/dao/login_dao.dart';
import 'package:flutter_bili/navigator/hi_navigator.dart';
import 'package:flutter_bili/util/toast.dart';

import 'model/video_model.dart';
import 'page/home_page.dart';
import 'page/login_page.dart';
import 'page/regiatration_page.dart';
import 'page/video_detail_page.dart';
import 'util/color.dart';

void main() {
  runApp(const BiliApp());
}

class BiliApp extends StatefulWidget {
  const BiliApp({super.key});

  @override
  State<BiliApp> createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  final BiliRouteDelegate _routeDelegate = BiliRouteDelegate();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HiCache?>(
      future: HiCache.preInit(),
      builder: (BuildContext context, AsyncSnapshot<HiCache?> snapshop) {
        // 如果路由正在加载中的状态，返回一个loading页面
        var widget = snapshop.connectionState == ConnectionState.done
            ? Router(
                routerDelegate: _routeDelegate,
              )
            : const Scaffold(
                body: Center(
                child: CircularProgressIndicator(),
              ));

        return MaterialApp(
          home: widget,
          theme: ThemeData(
            primarySwatch: white,
          ),
        );
      },
    );
  }
}

class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  // 构造方法
  // 为Navigator设置一个key，
  // 必要的时候可以通过navigationKey.currentState来获取到NavigatorState
  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    // 实现跳转逻辑
    HiNavigator.getInstance().registationRouteJump(
      RouteJumpListener((routeStatus, {args}) {
        _routeStatus = routeStatus;
        if (routeStatus == RouteStatus.detail) {
          videoModel = args!['videoModel'];
        }
        notifyListeners();
      })
    );
  }
  RouteStatus _routeStatus = RouteStatus.home;
  List<MaterialPage> pages = [];
  VideoModel? videoModel;

  // getter
  // 拦截路由状态，如果没有登录，并且不是在注册页面，就打开登录页面

  @override
  Widget build(BuildContext context) {
    // 管理路由堆栈
    var index = getPageIndex(pages, _routeStatus);
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      tempPages = tempPages.sublist(0, index);
    }
    var page;
    if (routeStatus == RouteStatus.home) {
      // 跳转首页时，将栈中其他页面出栈，因为首页无法回退
      pages.clear();
      page = pageWrap(const HomePage());
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(VideoDetailPage(videoModel: videoModel!));
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(const RegistrationPage());
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(const LoginPage());
    }
    tempPages = [...tempPages, page];
    pages = tempPages;

    // 通知路由状态发生变化
    HiNavigator.getInstance().notify(tempPages, pages);

    return WillPopScope(child: Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (router, result) {
        if (router.settings is MaterialPage) {
          // 登录页未登录拦截
          if ((router.settings as MaterialPage).child is LoginPage) {
            if (!LoginDao.isLogin()) {
              showToast("请先登录");
              return false;
            }
          }
        }
        // 执行返回操作
        if (!router.didPop(result)) {
          return false;
        }
        var temp = [...pages];
        pages.removeLast();
        // 通知路由状态变化
        HiNavigator.getInstance().notify(pages, temp);
        return true;
      },
      // 安卓物理键返回，无法返回上一页
    ), onWillPop: () async => !await navigatorKey.currentState!.maybePop(),
    );
  }

  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routeStatus = RouteStatus.detail;
    } else {
      return _routeStatus;
    }
  }

  bool get hasLogin => LoginDao.isLogin();

  @override
  Future<void> setNewRoutePath(BiliRoutePath configuration) async {}
}

// 定义路由数据，path
class BiliRoutePath {
  final String location;
  BiliRoutePath.home() : location = "/";
  BiliRoutePath.detail() : location = "/detail";
}

/// 创建页面
pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}
