import 'package:flutter/material.dart';
import 'package:flutter_bili/model/home_model.dart';

class HomeTabPage extends StatefulWidget {
  final String name;
  final List<BannerMo>? bannerList;
  const HomeTabPage({super.key, required this.name, this.bannerList});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.name);
  }
}