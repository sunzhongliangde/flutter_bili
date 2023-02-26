import 'package:flutter/material.dart';

import '../util/view_util.dart';

class HiFlexibleHeader extends StatefulWidget {
  final String name;
  final String face;
  final ScrollController controller;
  const HiFlexibleHeader(
      {super.key,
      required this.name,
      required this.face,
      required this.controller});

  @override
  State<HiFlexibleHeader> createState() => _HiFlexibleHeaderState();
}

class _HiFlexibleHeaderState extends State<HiFlexibleHeader> {
  static const double maxBottom = 40;
  static const double minBottom = 10;
  // 滚动范围
  static const double maxOffset = 80;
  // 滚动中的位移
  double _dyBottom = maxBottom;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      var offset = widget.controller.offset;
      // 计算padding变化0 到 1
      var dyOffset = (maxOffset - offset) / maxOffset;
      // 根据dyOffset计算具体变化的padding值
      var dy = dyOffset * (maxBottom - minBottom);
      // 临界值保护
      if (dy > (maxBottom - minBottom)) {
        dy = (maxBottom - minBottom);
      } else if (dy < 0) {
        dy = 0;
      }

      setState(() {
        // 计算实际的padding
        _dyBottom = minBottom + dy;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(bottom: _dyBottom, left: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: cachedImage(widget.face, width: 46, height: 46),
          ),
          hiSpace(width: 8),
          Text(
            widget.name,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
