import 'package:flutter/material.dart';
import 'package:flutter_bili/http/core/hi_error.dart';
import 'package:flutter_bili/http/dao/profile_dao.dart';
import 'package:flutter_bili/model/profile_model.dart';
import 'package:flutter_bili/util/toast.dart';
import 'package:flutter_bili/util/view_util.dart';
import 'package:flutter_bili/widget/hi_banner.dart';

import '../widget/benefit_card.dart';
import '../widget/course_card.dart';
import '../widget/hi_blur.dart';
import '../widget/hi_flexible_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  ProfileModel? _profileModel;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: NestedScrollView(
        controller: _controller,
        // 视差
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[_buildAppBar()];
        },
        body: ListView(
          padding: const EdgeInsets.only(top: 10),
          children: [
            ..._buildContentList(),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 160, // 扩展高度
      pinned: true, // 滚动到顶时，标题栏是否固定
      // 滚动空间
      flexibleSpace: FlexibleSpaceBar(
        // 视差滚动效果
        collapseMode: CollapseMode.parallax,
        // 间距
        titlePadding: const EdgeInsets.only(left: 0),
        title: _buildHeader(),
        background: Stack(
          children: [
            // 高斯模糊背景
            Positioned.fill(
                child: cachedImage(
                    'https://www.devio.org/img/beauty_camera/beauty_camera4.jpg')),
            // 高斯模糊数据
            const Positioned.fill(child: HiBlur(sigma: 20)),
            // 用户资产
            Positioned(
              child: _buildProfileTab(),
              bottom: 0,
              left: 0,
              right: 0,
            ),
          ],
        ),
      ),
    );
  }

  void loadData() async {
    try {
      ProfileModel user = await ProfileDao.get();
      setState(() {
        _profileModel = user;
      });
    } on NeedAuth catch (e) {
      showToast(e.message);
    }
  }

  _buildHeader() {
    if (_profileModel == null) {
      return Container();
    }
    return HiFlexibleHeader(
      name: _profileModel!.name,
      controller: _controller,
      face: _profileModel!.face,
    );
  }

  @override
  bool get wantKeepAlive => true;

  _buildContentList() {
    if (_profileModel == null) {
      return [];
    }
    return [
      _buildBanner(),
      CourseCard(
        courseList: _profileModel!.courseList,
      ),
      BenefitCard(
        benefitList: _profileModel!.benefitList,
      ),
    ];
  }

  _buildBanner() {
    return HiBanner(
      bannerList: _profileModel?.bannerList,
      bannerHeight: 120,
      padding: const EdgeInsets.only(left: 10, right: 10),
    );
  }

  /// 用户资产
  _buildProfileTab() {
    if (_profileModel == null) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
      decoration: const BoxDecoration(color: Colors.white54),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText('收藏', _profileModel?.favorite ?? 0),
          _buildIconText('点赞', _profileModel?.like ?? 0),
          _buildIconText('浏览', _profileModel?.browsing ?? 0),
          _buildIconText('金币', _profileModel?.coin ?? 0),
          _buildIconText('粉丝', _profileModel?.fans ?? 0),
        ],
      ),
    );
  }

  _buildIconText(String text, int count) {
    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        Text(
          '$count',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        )
      ],
    );
  }
}
