import 'package:flutter/material.dart';
import 'package:flutter_bili/model/ranking_model.dart';

import '../core/hi_base_tab_state.dart';
import '../http/dao/favorite_dao.dart';
import '../model/video_model.dart';
import '../navigator/hi_navigator.dart';
import '../util/view_util.dart';
import '../widget/navigation_bar.dart';
import '../widget/video_large_card.dart';
import 'video_detail_page.dart';

///收藏
class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState
    extends HiBaseTabState<RankingModel, VideoModel, FavoritePage> {
  late RouteChangeListener listener;

  @override
  void initState() {
    super.initState();
    HiNavigator.getInstance().addListener(this.listener = (current, pre) {
      if (pre?.widget is VideoDetailPage && current.widget is FavoritePage) {
        loadData();
      }
    });
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(this.listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildNavigationBar(), Expanded(child: super.build(context))],
    );
  }

  _buildNavigationBar() {
    return NavigationStyleBar(
      child: Container(
        decoration: bottomBoxShadow(context),
        alignment: Alignment.center,
        child: const Text('收藏', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  get contentChild => ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemCount: dataList.length,
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) =>
            VideoLargeCard(videoModel: dataList[index]),
      );

  @override
  Future<RankingModel> getData(int pageIndex) async {
    RankingModel result =
        await FavoriteDao.favoriteList(pageIndex: pageIndex, pageSize: 10);
    return result;
  }

  @override
  List<VideoModel> parseList(RankingModel result) {
    return result.list;
  }
}
