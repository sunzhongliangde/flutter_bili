import 'dart:convert';
import 'package:flutter_bili/http/request/base_request.dart';

abstract class HiNetAdapter {
  Future<HiNetResponse<T>> send<T>(BaseRequest request);
}

class HiNetResponse<T> {
  T? data;
  BaseRequest request;
  int? statusCode;
  String? message;
  dynamic extra;

  HiNetResponse(this.request, [this.statusCode, this.data, this.message, this.extra]);

  @override
  String toString() {
    if (data is Map) {
      return jsonEncode(data);
    } else {
      return data.toString();
    }
  }
}
