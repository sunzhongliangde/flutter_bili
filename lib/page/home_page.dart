import 'package:flutter/material.dart';
import 'package:flutter_bili/http/core/hi_error.dart';
import 'package:flutter_bili/http/dao/home_dao.dart';
import 'package:flutter_bili/model/home_model.dart';
import 'package:flutter_bili/navigator/hi_navigator.dart';
import 'package:flutter_bili/page/home_tab_page.dart';
import 'package:flutter_bili/util/color.dart';
import 'package:flutter_bili/util/toast.dart';

import '../model/video_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  RouteChangeListener? listener;
  TabController? _controller;
  List<CategoryMo> categoryList = [];
  List<BannerMo> bannerList = [];

  @override
  void initState() {
    super.initState();
    // 注册路由监听
    HiNavigator.getInstance().addListener(listener = (current, pre) {
      if (widget == current.widget || current.widget is HomePage) {
        print("首页页面显示");
      } else if (widget == pre?.widget || pre?.widget is HomePage) {
        print("首页页面dismiss");
      }
    });
    loadData();
    _controller = TabController(length: categoryList.length, vsync: this);
  }

  @override
  void dispose() {
    if (listener != null) {
      HiNavigator.getInstance().removeListener(listener!);
    }
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 30),
            child: _tabBar(),
          ),
          Flexible(
              child: TabBarView(
                  controller: _controller,
                  children: categoryList.map((tab) {
                    return HomeTabPage(
                      name: tab.name,
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
    return TabBar(
        controller: _controller,
        isScrollable: true,
        labelColor: Colors.black,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: primary, width: 3),
          insets: EdgeInsets.only(left: 15, right: 15),
        ),
        tabs: categoryList.map<Tab>((tab) {
          return Tab(
              child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Text(
              tab.name,
              style: const TextStyle(fontSize: 16),
            ),
          ));
        }).toList());
  }

  void loadData() async {
    try {
      HomeModel result = await HomeDao.get("推荐");
      print(result);
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
}
