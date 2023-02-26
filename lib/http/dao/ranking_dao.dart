import 'package:flutter_bili/http/core/hi_net.dart';
import 'package:flutter_bili/model/ranking_model.dart';

import '../request/ranking_request.dart';

class RankingDao {
  static get(String sort, [int pageIndex = 1, int pagesize = 15]) async {
    RankingRequest request = RankingRequest();
    request.addParams("sort", sort);
    request.addParams("pageIndex", pageIndex);
    request.addParams("pageSize", pagesize);

    var result = await HiNet.getInstance().fire(request);
    return RankingModel.fromJson(result['data']);
  }
}
