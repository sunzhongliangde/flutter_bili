import 'package:flutter/material.dart';
import 'package:flutter_bili/util/logger.dart';

/// 页面状态异常管理
abstract class HiState<T extends StatefulWidget> extends State<T> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    } else {
      Log.print("${toString()}:页面已销毁, 本次setState不执行");
    }
  }
}
