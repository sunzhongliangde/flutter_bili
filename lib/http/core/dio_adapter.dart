import 'package:dio/dio.dart';
import 'package:flutter_bili/http/core/hi_adapter.dart';
import 'package:flutter_bili/http/core/hi_error.dart';
import 'package:flutter_bili/http/request/base_request.dart';

import '../../util/logger.dart';

class DioAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    Response? response;
    var option =
        Options(headers: request.header, responseType: ResponseType.json);
    DioError? error;
    try {
      if (request.httpMethod() == HttpMethod.GET) {
        response = await Dio().get(request.url(), options: option);
      } else if (request.httpMethod() == HttpMethod.POST) {
        response = await Dio()
            .post(request.url(), options: option, data: request.params);
      } else if (request.httpMethod() == HttpMethod.DELETE) {
        response = await Dio()
            .delete(request.url(), options: option, data: request.params);
      }
    } on DioError catch (e) {
      error = e;
      response = e.response;
      Log.print("httpMethod: ${request.httpMethod()}");
      Log.print("requestParams: ${request.params}");
      Log.print("requestHeader: ${request.header}");
      Log.print("返回报错：${e.message}");
    }

    if (error != null) {
      throw HiNetError(response?.statusCode ?? -1, error.toString(),
          data: response?.data);
    }
    return HiNetResponse(request, response?.statusCode, response?.data,
        response?.statusMessage, response?.extra);
  }
}
