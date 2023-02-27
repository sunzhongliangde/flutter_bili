import 'package:flutter/material.dart';
import 'package:flutter_bili/model/video_model.dart';
import 'package:flutter_bili/navigator/hi_navigator.dart';
import 'package:flutter_bili/provider/theme_provider.dart';
import 'package:provider/provider.dart';

import '../util/format_util.dart';
import '../util/view_util.dart';

class VideoCard extends StatelessWidget {
  final VideoModel videoModel;
  const VideoCard({super.key, required this.videoModel});

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    Color textColor = themeProvider.isDark() ? Colors.white70 : Colors.black87;
    if (themeProvider.isDark()) {
    } else {}
    return InkWell(
      onTap: () {
        HiNavigator.getInstance()
            .onJumpTo(RouteStatus.detail, args: {'videoModel': videoModel});
      },
      child: SizedBox(
        height: 200,
        child: Card(
          // 取消卡片边距
          margin: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _itemImage(context),
                _infoText(textColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _itemImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        cachedImage(
          videoModel.cover,
          height: 120,
          width: size.width / 2 - 20,
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 3),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.transparent])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconText(Icons.ondemand_video, videoModel.view),
                  _iconText(Icons.favorite_border, videoModel.favorite),
                  _iconText(null, videoModel.duration),
                ],
              ),
            ))
      ],
    );
  }

  _iconText(IconData? iconData, int count) {
    String views = "";
    if (iconData != null) {
      views = countFormat(count);
    } else {
      views = durationTransform(videoModel.duration);
    }
    return Row(
      children: [
        if (iconData != null)
          Icon(
            iconData,
            color: Colors.white,
            size: 12,
          ),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Text(
            views,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        )
      ],
    );
  }

  _infoText(Color textColor) {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            videoModel.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: textColor),
          ),
          _owner(textColor),
        ],
      ),
    ));
  }

  _owner(Color textColor) {
    var owner = videoModel.owner;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: cachedImage(
                owner?.face ?? '',
                width: 24,
                height: 24,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                owner?.name ?? '',
                style: TextStyle(fontSize: 11, color: textColor),
              ),
            )
          ],
        ),
        const Icon(
          Icons.more_vert_sharp,
          size: 15,
          color: Colors.grey,
        )
      ],
    );
  }
}
