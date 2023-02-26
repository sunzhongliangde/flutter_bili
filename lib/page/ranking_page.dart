import 'package:flutter/material.dart';
import 'package:flutter_bili/http/dao/ranking_dao.dart';
import 'package:flutter_bili/page/ranking_tab_page.dart';
import 'package:flutter_bili/widget/hi_tab.dart';
import 'package:flutter_bili/widget/navigation_bar.dart';

import '../util/view_util.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RangkingPageState();
}

class _RangkingPageState extends State<RankingPage>
    with TickerProviderStateMixin {
  static const rankTab = [
    {
      'key': 'like',
      'name': '最热',
    },
    {
      'key': 'pubdate',
      'name': '最新',
    },
    {
      'key': 'favorite',
      'name': '收藏',
    }
  ];
  TabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: rankTab.length, vsync: this);
    RankingDao.get(rankTab[0]['key'] ?? 'like');
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [_buildNavigationBar(), _buildTabView()],
    ));
  }

  _buildNavigationBar() {
    return NavigationStyleBar(
      child: Container(
        alignment: Alignment.center,
        child: _tabbar(),
        decoration: bottomBoxShadow(),
      ),
    );
  }

  _tabbar() {
    return HiTab(
        rankTab.map<Tab>((tab) {
          return Tab(
            child: Text(tab['name']!),
          );
        }).toList(),
        controller: _controller!);
  }

  _buildTabView() {
    return Flexible(
        child: TabBarView(
      controller: _controller,
      children: [
        ...rankTab.map<Widget>((tab) {
          return RankingTabPage(
            sort: tab['key'] ?? '',
          );
        }).toList(),
      ],
    ));
  }
}
