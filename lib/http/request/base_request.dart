// ignore_for_file: constant_identifier_names

import '../dao/login_dao.dart';

enum HttpMethod {
  GET,
  POST,
  DELETE,
}

abstract class BaseRequest {
  String pathParams = "";
  var useHttps = true;

  String authority() {
    return "api.devio.org";
  }

  HttpMethod httpMethod();
  String path();
  String url() {
    Uri uri;
    var pathStr = path();
    // join path params
    if (pathParams.isNotEmpty) {
      if (path().endsWith("/")) {
        pathStr = "${path()}$pathParams";
      } else {
        pathStr = "${path()}/$pathParams";
      }
    }
    if (useHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }
    print('uri: ${uri.toString()}');
    if (needLogin()) {
      addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }
    // A0B617C85FAC5F5537D52857D6A58065
    return uri.toString();
  }

  bool needLogin();

  // add params
  Map<String, String> params = <String, String>{};
  BaseRequest addParams(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  // add headers
  Map<String, String> header = <String, String>{
    "course-flag": "fa",
    "auth-token": "ZmEtMjAyMS0wNC0xMiAyMToyMjoyMC1mYQ==fa"
  };
  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
