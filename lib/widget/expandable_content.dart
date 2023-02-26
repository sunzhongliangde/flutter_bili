import 'package:flutter/material.dart';
import 'package:flutter_bili/model/video_model.dart';
import 'package:flutter_bili/util/view_util.dart';

/// 可展开的widget
class ExpandableContent extends StatefulWidget {
  final VideoModel videoModel;
  const ExpandableContent({super.key, required this.videoModel});

  @override
  State<ExpandableContent> createState() => _ExpandableContentState();
}

class _ExpandableContentState extends State<ExpandableContent>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  bool _expand = false;

  // 用来管理动画
  AnimationController? _controller;
  // 生成动画的高度
  Animation<double>? _heightFactor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _heightFactor = _controller?.drive(_easeInTween);
    _controller?.addListener(() {
      // 监听动画值的变化
      print(_heightFactor?.value);
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Column(
        children: [
          // 视频标题
          _buildTitle(),
          const Padding(padding: EdgeInsets.only(bottom: 8)),
          // 视频信息
          _buildInfo(),
          // 描述信息
          _buildDesc(),
        ],
      ),
    );
  }

  _buildTitle() {
    return InkWell(
      onTap: _toggleExpand,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 通过Expanded让Text获得最大宽度，以便显示省略号
          Expanded(
              child: Text(
            widget.videoModel.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
          const Padding(padding: EdgeInsets.only(left: 15)),
          Icon(
            _expand ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.grey,
            size: 16,
          ),
        ],
      ),
    );
  }

  void _toggleExpand() {
    setState(() {
      _expand = !_expand;
      if (_expand) {
        // 执行动画
        _controller!.forward();
      } else {
        _controller!.reverse();
      }
    });
  }

  // 视频信息
  _buildInfo() {
    var style = const TextStyle(fontSize: 12, color: Colors.grey);
    var dateStr = widget.videoModel.createTime.length > 10
        ? widget.videoModel.createTime.substring(5, 10)
        : widget.videoModel.createTime;
    return Row(
      children: [
        ...smallIconText(Icons.ondemand_video, widget.videoModel.view),
        const Padding(padding: EdgeInsets.only(left: 10)),
        ...smallIconText(Icons.list_alt, widget.videoModel.reply),
        Text(
          dateStr,
          style: style,
        ),
      ],
    );
  }

  _buildDesc() {
    var child = _expand
        ? Text(
            widget.videoModel.desc,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          )
        : null;
    // 构建动画
    return AnimatedBuilder(
      animation: _controller!.view, 
      child: child,
      builder: (BuildContext context, Widget? widget) {
        return Align(
          alignment: Alignment.topCenter,
          heightFactor: _heightFactor!.value,
          child: Container(
            // 撑满高度，对齐内容
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 8),
            child: child,
          ),
        );
      }
    );
  }
}
