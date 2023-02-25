// 自定义app导航栏
import 'package:flutter/material.dart';
import 'package:flutter_bili/util/view_util.dart';

appBar(String title, String rightTitle, VoidCallback? rightButtonClick) {
  return AppBar(
    elevation: 0.5, // 这里设置为0就没有阴影了
    centerTitle: true,
    titleSpacing: 0,
    leading: const BackButton(),
    title: Text(
      title,
      style: const TextStyle(fontSize: 18),
    ),
    actions: [
      InkWell(
        onTap: rightButtonClick,
        child: Container(
          padding: const EdgeInsets.only(left: 15, right: 15),
          alignment: Alignment.center,
          child: Text(
            rightTitle,
            style: TextStyle(fontSize: 18, color: Colors.grey[800]),
            textAlign: TextAlign.center,
          ),
        ),
      )
    ],
  );
}

/// 视频详情页appbar
videoAppBar() {
  return Container(
    padding: const EdgeInsets.only(right: 8),
    decoration: BoxDecoration(gradient: blackLinearGradient(fromTop: true)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      const BackButton(
        color: Colors.white,
      ),
      Row(
        children: const [
          Icon(
            Icons.live_tv_rounded,
            color: Colors.white,
            size: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    ]),
  );
}
