import 'package:flutter_bili/http/core/hi_net.dart';
import 'package:flutter_bili/http/request/video_detail_request.dart';
import 'package:flutter_bili/model/video_detail_model.dart';

class VideoDetailDao {
  static get(String vid) async {
    VideoDetailRequest request = VideoDetailRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);

    return VideoDetailModel.fromJson(result['data']);
  }
}