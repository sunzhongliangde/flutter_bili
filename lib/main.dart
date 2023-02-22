import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bili/db/hi_cache.dart';
import 'package:flutter_bili/http/core/hi_net.dart';
import 'package:flutter_bili/http/dao/login_dao.dart';
import 'package:flutter_bili/http/request/test_request.dart';

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
  final BiliRouteInformationParser _routeInformationParser =
      BiliRouteInformationParser();
  @override
  Widget build(BuildContext context) {
    var widget = Router(
      routerDelegate: _routeDelegate,
      routeInformationParser: _routeInformationParser,
      routeInformationProvider: PlatformRouteInformationProvider(
          initialRouteInformation: const RouteInformation(location: "/")),
    );

    return MaterialApp(
      home: widget,
    );
  }
}

class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;
  // 构造方法
  // 为Navigator设置一个key，
  // 必要的时候可以通过navigationKey.currentState来获取到NavigatorState
  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>();
  List<MaterialPage> pages = [];
  VideoModel? videoModel;
  late BiliRoutePath path;

  @override
  Widget build(BuildContext context) {
    // 构建路由堆栈
    pages = [
      pageWrap(HomePage(
        onJumpToDetail: (v) {
          videoModel = v;
          notifyListeners();
        },
      )),
      if (videoModel != null) pageWrap(VideoDetailPage(videoModel: videoModel!))
    ];
    
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (router, result) {
        if (!router.didPop(result)) {
          return false;
        }
        return true;
      },
    );
  }

  @override
  void addListener(VoidCallback listener) {
    print(listener);
  }

  @override
  Future<bool> popRoute() {
    // TODO: implement popRoute
    throw UnimplementedError();
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }

  @override
  Future<void> setNewRoutePath(BiliRoutePath configuration) async {
    path = configuration;
    print("===config:${path}");
  }
}

// 主要用于web，持有BiliRouteInformationProvider提供的RouteInformation
// 可以将其解析为我们定义的数据类型
class BiliRouteInformationParser extends RouteInformationParser {
  @override
  Future parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? "");
    print("uri:${uri}===${uri.pathSegments}");
    if (uri.pathSegments.isEmpty) {
      return BiliRoutePath.home();
    }
    return BiliRoutePath.detail();
  }
}

// 定义路由数据，path
class BiliRoutePath {
  final String location;
  BiliRoutePath.home() : location = "/";
  BiliRoutePath.detail() : location = "/detail";
}

/// 创建页面
pageWrap(Widget child) {
  print("===laile s");
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}
