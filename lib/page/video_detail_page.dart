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
import 'package:flutter_overlay/flutter_overlay.dart';

import '../barrage/barrage_input.dart';
import '../barrage/barrage_switch.dart';
import '../http/dao/like_dao.dart';
import '../model/video_detail_model.dart';
import '../model/video_model.dart';
import '../widget/expandable_content.dart';
import '../widget/video_header.dart';
import '../widget/video_toolbar.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;

  const VideoDetailPage({super.key, required this.videoModel});

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  late TabController _controller;
  List tabs = ["简介", "评论288"];
  VideoDetailModel? videoDetailMo;
  // 初始化的时候先拿外界传入的model，进来页面后加载网络请求，取出数据
  VideoModel? videoModel;
  List<VideoModel> videoList = [];
  final _barrageKey = GlobalKey<HiBarrageState>();
  bool _inoutShowing = false;

  @override
  void initState() {
    super.initState();
    //黑色状态栏，仅Android
    changeStatusBarStyle(
        color: Colors.black, statusStyle: StatusStyle.lightContent);
    _controller = TabController(length: tabs.length, vsync: this);
    videoModel = widget.videoModel;
    _loadDetail();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MediaQuery.removePadding(
      removeTop: Platform.isIOS,
      context: context,
      child: videoModel?.url != null
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
    var model = videoModel;
    return VideoView(
      url: model!.url!,
      cover: model.cover,
      overLayUI: videoAppBar(),
      barrageUI: HiBarrage(key: _barrageKey, vid: model.vid, autoPlay: true),
    );
  }

  _buildTabNavigation() {
    //使用Material实现阴影效果
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
          children: [_tabBar(), _buildBarrageBtn()],
        ),
      ),
    );
  }

  _tabBar() {
    return HiTab(
      tabs.map<Tab>((name) {
        return Tab(
          text: name,
        );
      }).toList(),
      borderWidth: 2,
      controller: _controller,
    );
  }

  _buildDetailList() {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [...buildContents(), ..._buildVideoList()],
    );
  }

  buildContents() {
    return [
      VideoHeader(
        owner: videoModel?.owner,
      ),
      ExpandableContent(
        videoModel: videoModel!,
      ),
      VideoToolbar(
        detailModel: videoDetailMo,
        videoModel: videoModel!,
        onLike: _doLike,
        onUnLike: _onUnLike,
        onFavorite: _onFavorite,
      )
    ];
  }

  void _loadDetail() async {
    try {
      VideoDetailModel result = await VideoDetailDao.get(videoModel!.vid);
      setState(() {
        videoDetailMo = result;
        //更新旧的数据
        videoModel = result.videoInfo;
        videoList = result.videoList;
      });
    } on NeedAuth catch (e) {
      showToast(e.message);
    }
  }

  ///点赞
  _doLike() async {
    try {
      var result = await LikeDao.like(videoModel!.vid, !videoDetailMo!.isLike);
      videoDetailMo!.isLike = !videoDetailMo!.isLike;
      if (videoDetailMo!.isLike) {
        videoModel!.like += 1;
      } else {
        videoModel!.like -= 1;
      }
      setState(() {
        videoDetailMo = videoDetailMo;
        videoModel = videoModel;
      });
      showToast(result['msg']);
    } on NeedAuth catch (e) {
      showToast(e.message);
    }
  }

  ///取消点赞
  void _onUnLike() {}

  ///收藏
  void _onFavorite() async {
    try {
      var result = await FavoriteDao.favorite(
          videoModel!.vid, !videoDetailMo!.isFavorite);
      videoDetailMo!.isFavorite = !videoDetailMo!.isFavorite;
      if (videoDetailMo!.isFavorite) {
        videoModel!.favorite += 1;
      } else {
        videoModel!.favorite -= 1;
      }
      setState(() {
        videoDetailMo = videoDetailMo;
        videoModel = videoModel;
      });
      showToast(result['msg']);
    } on NeedAuth catch (e) {
      showToast(e.message);
    }
  }

  _buildVideoList() {
    return videoList
        .map((VideoModel mo) => VideoLargeCard(videoModel: mo))
        .toList();
  }

  _buildBarrageBtn() {
    return BarrageSwitch(
        inoutShowing: _inoutShowing,
        onShowInput: () {
          setState(() {
            _inoutShowing = true;
          });
          HiOverlay.show(context, child: BarrageInput(
            onTabClose: () {
              setState(() {
                _inoutShowing = false;
              });
            },
          )).then((value) {
            _barrageKey.currentState!.send(value);
          });
        },
        onBarrageSwitch: (open) {
          if (open) {
            _barrageKey.currentState!.play();
          } else {
            _barrageKey.currentState!.pause();
          }
        });
  }
}
