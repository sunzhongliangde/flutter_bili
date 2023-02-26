import 'package:flutter_bili/http/core/hi_net.dart';
import 'package:flutter_bili/http/request/home_request.dart';
import 'package:flutter_bili/model/home_model.dart';

class HomeDao {
  static get(String categoryName, [int pageIndex=1, int pagesize = 15]) async {
    HomeRequest request = HomeRequest();
    request.pathParams = categoryName;
    request.addParams("pageIndex", pageIndex);
    request.addParams("pageSize", pagesize);

    var result = await HiNet.getInstance().fire(request);
    return HomeModel.fromJson(result['data']);
  }

}