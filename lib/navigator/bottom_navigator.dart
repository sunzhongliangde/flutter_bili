import 'package:flutter/material.dart';
import 'package:flutter_bili/navigator/hi_navigator.dart';
import 'package:flutter_bili/page/favorite_page.dart';
import 'package:flutter_bili/page/home_page.dart';
import 'package:flutter_bili/page/profile_page.dart';
import 'package:flutter_bili/util/color.dart';

import '../page/ranking_page.dart';

/// 底部TabBar
class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final _defaultColor = Colors.grey;
  final _activityColor = primary;
  int _currentIndex = 0;
  static int initialPageIndex = 0;
  final PageController _controller = PageController(initialPage: 0);
  // ignore: prefer_final_fields
  List<Widget>? _pages;
  bool _hasBuild = false;

  @override
  Widget build(BuildContext context) {
    _pages = [
      const HomePage(),
      const RankingPage(),
      const FavoritePage(),
      const ProfilePage()
    ];
    if (!_hasBuild) {
      // 页面第一次打开时，通知打开的是哪个tab
      HiNavigator.getInstance()
          .onBottomTabChange(initialPageIndex, _pages![initialPageIndex]);
      _hasBuild = true;
    }

    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages!,
        onPageChanged: (index) {
          _onJumpTo(index, true);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: _activityColor,
        type: BottomNavigationBarType.fixed,
        items: [
          _bottomItem('首页', Icons.home, 0),
          _bottomItem('排行', Icons.local_fire_department, 1),
          _bottomItem('收藏', Icons.favorite, 2),
          _bottomItem('我的', Icons.live_tv, 3),
        ],
        onTap: (index) {
          _onJumpTo(index, false);
        },
      ),
    );
  }

  _bottomItem(String title, IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _defaultColor,
      ),
      activeIcon: Icon(
        icon,
        color: _activityColor,
      ),
      label: title,
    );
  }

  void _onJumpTo(int index, [pageChange = false]) {
    if (!pageChange) {
      _controller.jumpToPage(index);
    } else {
      HiNavigator.getInstance().onBottomTabChange(index, _pages![index]);
    }
    setState(() {
      _currentIndex = index;
    });
  }
}
