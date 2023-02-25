import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bili/widget/appbar.dart';
import 'package:flutter_bili/widget/navigation_bar.dart';
import 'package:flutter_bili/widget/video_view.dart';

import '../model/video_model.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;
  const VideoDetailPage({super.key, required this.videoModel});

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MediaQuery.removePadding(
      removeTop: Platform.isIOS,
      context: context,
      child: Column(
        children: [
          NavigationStyleBar(
            color: Colors.black,
            statusStyle: StatusStyle.lightContent,
            height:
                Platform.isAndroid ? 0 : (MediaQuery.of(context).padding.top),
          ),
          _videoView(),
        ],
      ),
    ));
  }

  _videoView() {
    var model = widget.videoModel;
    return VideoView(
      url: model.url!,
      cover: model.cover,
      overLayUI: videoAppBar(),
    );
  }
}
