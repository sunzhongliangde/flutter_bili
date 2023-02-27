import 'package:flutter/material.dart';
import 'package:flutter_bili/http/core/hi_error.dart';
import 'package:flutter_bili/http/dao/home_dao.dart';
import 'package:flutter_bili/model/home_model.dart';
import 'package:flutter_bili/navigator/hi_navigator.dart';
import 'package:flutter_bili/page/home_tab_page.dart';
import 'package:flutter_bili/page/profile_page.dart';
import 'package:flutter_bili/page/video_detail_page.dart';
import 'package:flutter_bili/provider/theme_provider.dart';
import 'package:flutter_bili/util/toast.dart';
import 'package:flutter_bili/util/view_util.dart';
import 'package:provider/provider.dart';

import '../core/hi_state.dart';
import '../util/logger.dart';
import '../widget/hi_tab.dart';
import '../widget/navigation_bar.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onJumpTo;
  const HomePage({super.key, this.onJumpTo});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver {
  RouteChangeListener? listener;
  TabController? _controller;
  List<CategoryMo> categoryList = [];
  List<BannerMo> bannerList = [];

  @override
  void initState() {
    super.initState();
    // 注册路由监听
    HiNavigator.getInstance().addListener(listener = (current, pre) {
      _currentPage = current.widget;
      if (widget == current.widget || current.widget is HomePage) {
        Log.print("首页页面显示");
      } else if (widget == pre?.widget || pre?.widget is HomePage) {
        Log.print("首页页面dismiss");
      }
      // 返回到首页时，恢复状态栏
      if (pre?.widget is VideoDetailPage && current.widget is! ProfilePage) {
        var statusStyle = StatusStyle.darkContent;
        changeStatusBarStyle(color: Colors.white, statusStyle: statusStyle);
      }
    });
    // 注册前后台切换监听
    WidgetsBinding.instance.addObserver(this);
    // 加载数据
    loadData();
    // 创建子视图
    _controller = TabController(length: categoryList.length, vsync: this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (listener != null) {
      HiNavigator.getInstance().removeListener(listener!);
    }
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    context.read<ThemeProvider>().darkModeChange();
    super.didChangePlatformBrightness();
  }

  Widget? _currentPage;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        if (_currentPage != null && (_currentPage is! VideoDetailPage)) {
          changeStatusBarStyle(
              color: Colors.white,
              statusStyle: StatusStyle.darkContent,
              context: context);
        }
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          NavigationStyleBar(
            height: 50,
            color: Colors.white,
            statusStyle: StatusStyle.darkContent,
            child: _appBar(),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            decoration: bottomBoxShadow(context),
            child: _tabBar(),
          ),
          Flexible(
              child: TabBarView(
                  controller: _controller,
                  children: categoryList.map((tab) {
                    return HomeTabPage(
                      categoryName: tab.name,
                      bannerList: tab.name == '推荐' ? bannerList : null,
                    );
                  }).toList()))
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _tabBar() {
    return HiTab(
      categoryList.map<Tab>((tab) {
        return Tab(
          text: tab.name,
        );
      }).toList(),
      controller: _controller!,
      fontSize: 16,
      borderWidth: 2,
      unselectedLabelColor: Colors.black54,
      insets: const EdgeInsets.only(left: 10, right: 10),
    );
  }

  void loadData() async {
    try {
      HomeModel result = await HomeDao.get("推荐");
      if (result.categoryList != null) {
        _controller =
            TabController(length: result.categoryList!.length, vsync: this);
        setState(() {
          categoryList = result.categoryList ?? [];
          bannerList = result.bannerList ?? [];
        });
      }
    } on HiNetError catch (e) {
      showToast(e.message);
    }
  }

  _appBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (widget.onJumpTo != null) {
                widget.onJumpTo!(3);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: const Image(
                height: 46,
                width: 46,
                image: AssetImage("images/avatar.png"),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                height: 32,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(color: Colors.grey[100]),
                child: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
            ),
          )),
          const Icon(
            Icons.explore_outlined,
            color: Colors.grey,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Icon(
              Icons.mail_outline,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
