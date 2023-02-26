import 'package:flutter/material.dart';
import 'package:flutter_bili/util/color.dart';

import '../model/video_model.dart';
import '../util/format_util.dart';

/// 详情页作者
class VideoDetailAuthor extends StatelessWidget {
  final Owner owner;
  const VideoDetailAuthor({super.key, required this.owner});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  owner.face,
                  width: 30,
                  height: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      owner.name,
                      style: const TextStyle(
                          fontSize: 13,
                          color: primary,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${countFormat(owner.fans)}粉丝',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    )
                  ],
                ),
              ),
            ],
          ),
          MaterialButton(
            color: primary,
            height: 24,
            minWidth: 50,
            child: const Text(
              "关注",
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
            onPressed: () {
              print('object====');
            },
          ),
        ],
      ),
    );
  }
}
