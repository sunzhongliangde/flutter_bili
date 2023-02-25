import 'package:flutter/material.dart';
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
      appBar: AppBar(),
      body: Column(
        children: [
          Text("视频详情页, vid:${widget.videoModel.vid}"),
          Text("视频详情页, title:${widget.videoModel.title}"),
          _videoView(),
        ],
      ),
    );
  }
  
  _videoView() {
    var model = widget.videoModel;
    return VideoView(
      url: model.url!,
      cover: model.cover,
    );
  }
}