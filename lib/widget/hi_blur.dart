import 'dart:ui';

import 'package:flutter/material.dart';

/// 高斯模糊
class HiBlur extends StatelessWidget {
  final Widget? child;
  // 模糊值
  final double? sigma;
  const HiBlur({super.key, this.child, this.sigma = 10});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: sigma!, sigmaY: sigma!),
      child: Container(
        color: Colors.white10,
        child: child,
      ),
    );
  }
}
