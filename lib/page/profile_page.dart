import 'package:flutter/material.dart';
import 'package:flutter_bili/http/core/hi_error.dart';
import 'package:flutter_bili/http/dao/profile_dao.dart';
import 'package:flutter_bili/model/profile_model.dart';
import 'package:flutter_bili/util/toast.dart';
import 'package:flutter_bili/util/view_util.dart';

import '../widget/hi_blur.dart';
import '../widget/hi_flexible_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileModel? _profileModel;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          controller: _controller,
          // 视差
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
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
                      Positioned.fill(
                          child: cachedImage(
                              'https://www.devio.org/img/beauty_camera/beauty_camera4.jpg')),
                      const Positioned.fill(child: HiBlur(sigma: 20))
                    ],
                  ),
                ),
              )
            ];
          },
          body: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('标题${index}'),
                );
              })),
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
}
