// 自定义app导航栏
import 'package:flutter/material.dart';

appBar(String title, String rightTitle, VoidCallback? rightButtonClick) {
  return AppBar(
    elevation: 0.5,    // 这里设置为0就没有阴影了
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
