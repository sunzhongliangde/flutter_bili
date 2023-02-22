import 'package:flutter/material.dart';

import '../model/video_model.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<VideoModel>? onJumpToDetail;
  const HomePage({super.key, this.onJumpToDetail});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Text("首页"),
          MaterialButton(
            onPressed: () {
              if (widget.onJumpToDetail != null) {
                print("点击了按钮");
                widget.onJumpToDetail!(VideoModel(vid: "1231"));
              }
            },
            child: const Text("详情"),
          )
        ],
      ),
    );
  }
}
