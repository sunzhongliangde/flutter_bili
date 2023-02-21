import 'package:flutter_bili/http/core/dio_adapter.dart';
import 'package:flutter_bili/http/core/hi_adapter.dart';
import 'package:flutter_bili/http/core/hi_error.dart';
import 'package:flutter_bili/http/request/base_request.dart';

class HiNet {
  static HiNet getInstance() {
    return HiNet();
  }

  Future fire(BaseRequest request) async {
    HiNetResponse? response;
    HiNetError? error;
    
    try {
      response = await send(request);
    } on HiNetError catch (e) {
      error = e;
    } catch(e) {
      error = e as HiNetError?;
    }

    if (response == null) {
      if (error != null) {
        return error;
      }
      return HiNetError(-1, "请求接口失败");
    }
    
    var result = response.data;
    var statusCode = response.statusCode;
    switch (statusCode) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        throw HiNetError(statusCode ?? -1, result.toString(), data: result);
    }
  }

  Future<dynamic> send<T>(BaseRequest request) async {
    HiNetAdapter adapter = DioAdapter();
    return adapter.send(request);
  }
}
