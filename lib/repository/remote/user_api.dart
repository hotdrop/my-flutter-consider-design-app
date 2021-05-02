import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mybt/models/role.dart';
import 'package:mybt/models/user.dart';
import 'package:mybt/repository/remote/fake/fake_http_client.dart';
import 'package:mybt/repository/remote/response/user_response.dart';
import 'package:mybt/res/R.dart';

class UserApi {
  const UserApi._(this._httpClient);

  factory UserApi.create() {
    return UserApi._(FakeDio());
  }

  final Dio _httpClient;

  Future<User> create(String? nickname, RoleType type) async {
    // 本当はnickNameやtypeもrequestbodyにのせる
    final url = '${R.res.url.api}/user';
    final response = await _httpClient.post<Map<String, Object>>(url);

    await Future<void>.delayed(Duration(seconds: 2));

    final responseData = response.data;
    if (responseData == null) {
      throw HttpException('ユーザー登録に失敗しました。');
    }
    final data = UserResponse.mapper(responseData);

    return User(data.userId);
  }
}
