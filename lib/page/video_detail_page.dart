import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bili/barrage/hi_barrage.dart';
import 'package:flutter_bili/http/core/hi_error.dart';
import 'package:flutter_bili/http/dao/favorite_dao.dart';
import 'package:flutter_bili/http/dao/video_detail_dao.dart';
import 'package:flutter_bili/util/toast.dart';
import 'package:flutter_bili/util/view_util.dart';
import 'package:flutter_bili/widget/appbar.dart';
import 'package:flutter_bili/widget/hi_tab.dart';
import 'package:flutter_bili/widget/navigation_bar.dart';
import 'package:flutter_bili/widget/video_large_card.dart';
import 'package:flutter_bili/widget/video_view.dart';

import '../barrage/hi_socket.dart';
import '../model/video_detail_model.dart';
import '../model/video_model.dart';
import '../widget/expandable_content.dart';
import '../widget/video_detail_author.dart';
import '../widget/video_toolbar.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;
  const VideoDetailPage({super.key, required this.videoModel});

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  TabController? _controller;
  List tabs = ['简介', '评论239'];
  VideoDetailModel? _detailModel;
  // 初始化的时候先拿外界传入的model，进来页面后加载网络请求，取出数据
  VideoModel? _videoModel;
  // 关联视频list
  List<VideoModel> videoList = [];
  final _barrageKey = GlobalKey<HiBarrageState>();

  @override
  void initState() {
    super.initState();
    changeStatusBarStyle(
        color: Colors.black, statusStyle: StatusStyle.lightContent);
    _controller = TabController(length: tabs.length, vsync: this);
    _videoModel = widget.videoModel;
    _loadDetail();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MediaQuery.removePadding(
      removeTop: Platform.isIOS,
      context: context,
      child: _videoModel?.url != null
          ? Column(
              children: [
                NavigationStyleBar(
                  color: Colors.black,
                  statusStyle: StatusStyle.lightContent,
                  height: Platform.isAndroid
                      ? 0
                      : (MediaQuery.of(context).padding.top),
                ),
                _buildVideoView(),
                _buildTabNavigation(),
                Flexible(
                    child: TabBarView(
                  controller: _controller,
                  children: [_buildDetailList(), const Text("敬请期待")],
                )),
              ],
            )
          : Container(),
    ));
  }

  _buildVideoView() {
    var model = _videoModel!;
    return VideoView(
      url: model.url!,
      cover: model.cover,
      overLayUI: videoAppBar(),
      barrageUI: HiBarrage(
        vid: model.vid, 
        key: _barrageKey,
        autoPlay: true,
      ),
    );
  }

  _buildTabNavigation() {
    return Material(
      elevation: 5,
      shadowColor: Colors.grey[100],
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 15),
        height: 39,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _tabbar(),
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.live_tv_rounded,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _tabbar() {
    return HiTab(
      tabs.map<Tab>((title) {
        return Tab(
          text: title,
        );
      }).toList(),
      controller: _controller!,
      borderWidth: 2,
    );
  }

  _buildDetailList() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        ...buildDetailContent(),
        ...buildVideoList(),
      ],
    );
  }

  buildDetailContent() {
    return [
      // 作者
      VideoDetailAuthor(owner: _videoModel!.owner!),
      // 展开内容
      ExpandableContent(
        videoModel: _videoModel!,
      ),
      // 收藏、点赞
      VideoToolbar(
        detailModel: _detailModel,
        videoModel: _videoModel,
        onLike: _doLike,
        onUnLike: _doUnLike,
        onFavorite: _doFavorite,
      ),
    ];
  }

  void _loadDetail() async {
    try {
      VideoDetailModel detail = await VideoDetailDao.get(_videoModel!.vid);
      setState(() {
        _detailModel = detail;
        _videoModel = detail.videoInfo;

        videoList = detail.videoList;
      });
    } on NeedAuth catch (e) {
      showToast(e.message);
    }
  }

  // 点赞
  void _doLike() {}
  // 取消点赞
  void _doUnLike() {}
  // 收藏
  void _doFavorite() async {
    try {
      var result = await FavoriteDao.favorite(
          _videoModel!.vid, !(_detailModel?.isFavorite ?? false));
      if (result['code'] == 0) {
        setState(() {
          _detailModel?.isFavorite = !(_detailModel?.isFavorite ?? false);
          if (_detailModel?.isFavorite == true) {
            _videoModel?.favorite += 1;
          } else {
            _videoModel?.favorite -= 1;
          }
        });
      }
      showToast(result['msg']);
    } on NeedAuth catch (e) {
      showToast(e.message);
    }
  }

  buildVideoList() {
    return videoList.map((e) => VideoLargeCard(videoModel: e));
  }
}
