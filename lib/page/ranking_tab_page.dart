import 'package:flutter/material.dart';
import 'package:flutter_bili/core/hi_base_tab_state.dart';
import 'package:flutter_bili/http/dao/ranking_dao.dart';
import 'package:flutter_bili/model/ranking_model.dart';
import 'package:flutter_bili/model/video_model.dart';
import 'package:flutter_bili/widget/video_large_card.dart';

class RankingTabPage extends StatefulWidget {
  final String sort;
  const RankingTabPage({super.key, required this.sort});

  @override
  State<RankingTabPage> createState() => _RankingTabPageState();
}

class _RankingTabPageState
    extends HiBaseTabState<RankingModel, VideoModel, RankingTabPage> {
  @override
  get contentChild => Container(
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 10),
            itemCount: dataList.length,
            controller: scrollController,
            itemBuilder: (BuildContext context, int index) {
              return VideoLargeCard(videoModel: dataList[index]);
            }),
      );

  @override
  Future<RankingModel> getData(int pageIndex) async {
    RankingModel result = await RankingDao.get(widget.sort, pageIndex, 20);
    return result;
  }

  @override
  List<VideoModel> parseList(RankingModel result) {
    return result.list;
  }
}
