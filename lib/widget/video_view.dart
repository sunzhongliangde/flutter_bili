import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart' hide MaterialControls;
import 'package:flutter_bili/util/color.dart';
import 'package:flutter_bili/util/view_util.dart';
import 'package:video_player/video_player.dart';

import 'hi_video_control.dart';

/// 视频播放器
class VideoView extends StatefulWidget {
  final String url;
  final String? cover;
  final bool? autoPlay;
  final bool? loop;
  final double? aspectRatio;

  const VideoView(
      {super.key,
      required this.url,
      this.cover,
      this.autoPlay = false,
      this.loop = false,
      this.aspectRatio = 16 / 9});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  // 封面
  get _placeholder => FractionallySizedBox(
    widthFactor: 1,
    child: cachedImage(widget.cover ??''),
  );
  // 进度条颜色
  get _progressColors => ChewieProgressColors(
    playedColor: primary,
    handleColor: primary,
    backgroundColor: Colors.grey,
    bufferedColor: primary[50]!
  );
  @override
  void initState() {
    super.initState();
    // 初始化播放器
    _videoPlayerController = VideoPlayerController.network(widget.url);   
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      aspectRatio: widget.aspectRatio,
      autoPlay: widget.autoPlay!,
      looping: widget.loop!,
      allowMuting: true,
      allowPlaybackSpeedChanging: false,
      placeholder: _placeholder,
      materialProgressColors: _progressColors,
      customControls: const MaterialControls(
        showLoadingOnInitialize: false,
        showBigPlayIcon: false,
      )
    );
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
    
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = screenWidth/widget.aspectRatio!;
    return Container(
      width: screenWidth,
      height: screenHeight,
      color: Colors.grey,
      child: Chewie(
        controller: _chewieController!
      ),
    );
  }
}
