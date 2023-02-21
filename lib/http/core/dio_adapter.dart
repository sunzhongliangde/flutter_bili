import 'package:dio/dio.dart';
import 'package:flutter_bili/http/core/hi_adapter.dart';
import 'package:flutter_bili/http/core/hi_error.dart';
import 'package:flutter_bili/http/request/base_request.dart';

class DioAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    Response? response;
    var option = Options(headers: request.header);
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
      print("httpMethod: ${request.httpMethod()}");
      print("requestParams: ${request.params}");
      print(e.message);
    }

    if (error != null) {
      throw HiNetError(response?.hashCode ?? -1, error.toString(),
          data: response?.data);
    }
    return HiNetResponse(request, response?.statusCode, response?.data,
        response?.statusMessage, response?.extra);
  }
}
