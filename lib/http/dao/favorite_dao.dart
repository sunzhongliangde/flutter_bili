import 'package:flutter_bili/http/core/hi_net.dart';
import 'package:flutter_bili/http/request/base_request.dart';
import 'package:flutter_bili/http/request/cancel_favorite_request.dart';
import 'package:flutter_bili/http/request/favorite_request.dart';

import '../../model/ranking_model.dart';
import '../request/favorite_list_request.dart';

class FavoriteDao {
  static favorite(String vid, bool favorite) async {
    BaseRequest request =
        favorite ? FavoriteRequest() : CancelFavoriteRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);

    return result;
  }

  //https://api.devio.org/uapi/fa/favorites?pageIndex=1&pageSize=10
  static favoriteList({int pageIndex = 1, int pageSize = 10}) async {
    FavoriteListRequest request = FavoriteListRequest();
    request.addParams("pageIndex", pageIndex).addParams("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return RankingModel.fromJson(result['data']);
  }
}
