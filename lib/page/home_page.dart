import 'package:flutter/material.dart';
import 'package:flutter_bili/navigator/hi_navigator.dart';

import '../model/video_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RouteChangeListener? listener;
  @override
  void initState() {
    super.initState();
    // 注册路由监听
    HiNavigator.getInstance().addListener(listener=(current, pre) {
      if (widget == current.widget || current.widget is HomePage) {
        print("页面被打开");
      } else if (widget == pre?.widget || pre?.widget is HomePage) {
        print("页面dismiss");
      }
    });
  }
  @override
  void dispose() {
    if (listener != null) {
      HiNavigator.getInstance().removeListener(listener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Text("首页"),
          MaterialButton(
            onPressed: () {
              HiNavigator.getInstance().onJumpTo(
                RouteStatus.detail, 
                args: {'videoModel': VideoModel(vid: "1231")}
              );
            },
            child: const Text("详情"),
          )
        ],
      ),
    );
  }
}
