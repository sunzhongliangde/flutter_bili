import 'video_model.dart';

///解放生产力：在线json转dart https://www.devio.org/io/tools/json-to-dart/
class RankingModel {
  late int total;
  late List<VideoModel> list;

  RankingModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['list'] != null) {
      list = List<VideoModel>.empty(growable: true);
      json['list'].forEach((v) {
        list.add(VideoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['list'] = list.map((v) => v.toJson()).toList();
    return data;
  }
}
