import 'package:flutter/material.dart';
import 'package:flutter_bili/model/home_model.dart';
import 'package:flutter_bili/model/video_model.dart';
import 'package:flutter_bili/navigator/hi_navigator.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

import '../util/view_util.dart';

class HiBanner extends StatelessWidget {
  final List<BannerMo>? bannerList;
  final double bannerHeight;
  final EdgeInsetsGeometry? padding;

  const HiBanner(
      {super.key, this.bannerList, this.bannerHeight = 160, this.padding});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: bannerHeight,
      child: _banner(),
    );
  }

  _banner() {
    var right = 10 + (padding?.horizontal ?? 0) / 2;

    return Swiper(
      itemCount: bannerList?.length ?? 0,
      autoplay: true,
      itemBuilder: (context, index) {
        if (bannerList != null) {
          return _image(bannerList![index]);
        }
        return Container();
      },
      // 自定义指示器
      pagination: SwiperPagination(
          alignment: Alignment.bottomRight,
          margin: EdgeInsets.only(right: right, bottom: 1),
          builder: const DotSwiperPaginationBuilder(
              color: Colors.white60, size: 6, activeSize: 10)),
    );
  }

  _image(BannerMo bannerMo) {
    return InkWell(
      onTap: () {
        _handleClick(bannerMo);
      },
      child: Container(
        padding: padding,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          child: cachedImage(
            bannerMo.cover,
          ),
        ),
      ),
    );
  }

  void _handleClick(BannerMo bannerMo) {
    if (bannerMo.type == 'video') {
      final video = VideoModel(vid: bannerMo.url);
      HiNavigator.getInstance().onJumpTo(
        RouteStatus.detail,
        args: {'videoModel': video}
      );
    } else {
      print(bannerMo.url);
    }
  }
}
