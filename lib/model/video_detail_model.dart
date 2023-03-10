import 'video_model.dart';

///解放生产力：在线json转dart https://www.devio.org/io/tools/json-to-dart/
class VideoDetailModel {
  late bool isFavorite;
  late bool isLike;
  late VideoModel videoInfo;
  late List<VideoModel> videoList;

  VideoDetailModel.fromJson(Map<String, dynamic> json) {
    isFavorite = json['isFavorite'];
    isLike = json['isLike'];
    videoInfo = VideoModel.fromJson(json['videoInfo']);
    if (json['videoList'] != null) {
      videoList = List<VideoModel>.empty(growable: true);
      json['videoList'].forEach((v) {
        videoList.add(VideoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isFavorite'] = isFavorite;
    data['isLike'] = isLike;
    data['videoInfo'] = videoInfo.toJson();
    data['videoList'] = videoList.map((v) => v.toJson()).toList();
    return data;
  }
}
