import 'dart:async';
import './hi_adapter.dart';
import '../request/base_request.dart';

class MockAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) {
    return Future<HiNetResponse<T>>.delayed(const Duration(milliseconds: 1000),
        () {
      return HiNetResponse(
          request,
          200,
          {
            "message": "success",
            "data": {"code": 0}
          } as T);
    });
  }
}
