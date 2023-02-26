import 'package:flutter/material.dart';
import 'package:flutter_bili/model/video_detail_model.dart';
import 'package:flutter_bili/model/video_model.dart';
import 'package:flutter_bili/util/color.dart';
import 'package:flutter_bili/util/format_util.dart';

import '../util/view_util.dart';

/// 视频点赞、收藏工具栏
class VideoToolbar extends StatelessWidget {
  final VideoDetailModel? detailModel;
  final VideoModel? videoModel;
  final VoidCallback? onLike;
  final VoidCallback? onUnLike;
  final VoidCallback? onCoin;
  final VoidCallback? onFavorite;
  final VoidCallback? onShare;

  const VideoToolbar(
      {super.key,
      this.detailModel,
      this.videoModel,
      this.onLike,
      this.onUnLike,
      this.onCoin,
      this.onFavorite,
      this.onShare});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        border: borderLine(context),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText(Icons.thumb_up_alt_rounded, videoModel?.like,
              onclick: onLike, tint: detailModel?.isLike ?? false),
          _buildIconText(Icons.thumb_down_alt_rounded, '不喜欢',
              onclick: onUnLike),
          _buildIconText(Icons.monetization_on, videoModel?.coin,
              onclick: onCoin),
          _buildIconText(Icons.grade_rounded, videoModel?.favorite,
              onclick: onFavorite, tint: detailModel?.isFavorite ?? false),
          _buildIconText(Icons.share_rounded, videoModel?.share,
              onclick: onShare),
        ],
      ),
    );
  }

  // 上面图标，下面文字
  _buildIconText(IconData iconData, dynamic text,
      {VoidCallback? onclick, bool tint = false}) {
    String textStr = '';
    if (text is int) {
      textStr = countFormat(text);
    } else if (text != null) {
      textStr = text;
    }

    return InkWell(
      onTap: onclick,
      child: Column(
        children: [
          Icon(
            iconData,
            color: tint ? primary : Colors.grey,
            size: 20,
          ),
          hiSpace(height: 5),
          Text(
            textStr,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
