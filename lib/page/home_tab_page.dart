import 'package:flutter/material.dart';
import 'package:flutter_bili/model/home_model.dart';
import 'package:flutter_bili/model/video_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../http/core/hi_error.dart';
import '../http/dao/home_dao.dart';
import '../util/toast.dart';
import '../widget/hi_banner.dart';
import '../widget/video_card.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerMo>? bannerList;
  const HomeTabPage({super.key, required this.categoryName, this.bannerList});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  List<VideoModel> videoList = [];
  int pageIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadData(false);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: StaggeredGrid.count(
          crossAxisCount: 2,
          axisDirection: AxisDirection.down,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            if (widget.bannerList != null)
              StaggeredGridTile.fit(
                crossAxisCellCount: 2, 
                child: _banner()
              ),
            ...videoList.map((video) {
              return StaggeredGridTile.fit(
                crossAxisCellCount: 1,
                child: VideoCard(videoModel: video),
              );
            }),
          ],
        ),
      ),
    );
  }

  _banner() {
    return HiBanner(bannerList: widget.bannerList);
  }

  void _loadData([loadMore = false]) async {
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    try {
      HomeModel result = await HomeDao.get(widget.categoryName, currentIndex);
      setState(() {
        if (loadMore) {
          videoList = [...videoList, ...result.videoList];
          if (result.videoList.isNotEmpty) {
            pageIndex++;
          }
        } else {
          videoList = result.videoList;
        }
      });
    } on HiNetError catch (e) {
      showToast(e.message);
    }
  }
}
