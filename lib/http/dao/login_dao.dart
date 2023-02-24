import 'package:flutter_bili/db/hi_cache.dart';
import 'package:flutter_bili/http/core/hi_net.dart';
import 'package:flutter_bili/http/request/base_request.dart';
import 'package:flutter_bili/http/request/login_request.dart';
import 'package:flutter_bili/http/request/registration_request.dart';
import 'package:flutter_bili/util/string_util.dart';

class LoginDao {
  // ignore: constant_identifier_names
  static const String BOARDING_PASS = "boarding-pass";

  static login(String userName, String password) {
    return _send(userName, password);
  }

  static registation(
      String userName, String password, String imoccId, String orderId) {
    return _send(userName, password, imoccId, orderId);
  }

  static dynamic _send(String userName, String password,
      [String? imoccId, String? orderId]) async {
    BaseRequest request;
    if (imoccId != null && orderId != null) {
      request = RegistrationRequest();
      request.addParams("imoocId", imoccId);
      request.addParams("orderId", orderId);
    } else {
      request = LoginRequest();
    }
    request.addParams("userName", userName);
    request.addParams("password", password);

    var result = await HiNet.getInstance().fire(request);
    if (result["code"] == 0 && result["data"] != null) {
      HiCache.getInstance().setString(BOARDING_PASS, result["data"]);
      print("登录成功，设置登录auth-token:${HiCache.getInstance().get(BOARDING_PASS)}");
    } else {
      // HiCache.getInstance()
      //    .setString(BOARDING_PASS, "A0B617C85FAC5F5537D52857D6A58065");
    }
    return result;
  }

  static getBoardingPass() {
    return HiCache.getInstance().get(BOARDING_PASS);
  }

  static bool isLogin() {
    final boardingPass = LoginDao.getBoardingPass();
    return !isEmpty(boardingPass);
  }
}
