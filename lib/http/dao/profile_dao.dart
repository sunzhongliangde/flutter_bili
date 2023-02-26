import 'package:flutter_bili/http/core/hi_net.dart';
import 'package:flutter_bili/http/request/profile_request.dart';
import 'package:flutter_bili/model/profile_model.dart';

class ProfileDao {
  static get() async {
    ProfileRequest request = ProfileRequest();

    var result = await HiNet.getInstance().fire(request);
    return ProfileModel.fromJson(result['data']);
  }
}
