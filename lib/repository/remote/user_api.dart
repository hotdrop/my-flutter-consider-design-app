import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/user.dart';
import 'package:mybt/repository/remote/fake/fake_http_client.dart';
import 'package:mybt/repository/remote/response/user_response.dart';
import 'package:mybt/res/R.dart';

final userApiProvider = Provider((ref) => _UserApi(ref.read));

class _UserApi {
  const _UserApi(this._read);

  final Reader _read;

  Future<User> create(String? nickname, String? email) async {
    final request = {'nickname': nickname, 'email': email};
    final response = await _read(httpClient).post<Map<String, Object>>(
      '${R.res.url.api}/user',
      data: request,
    );
    if (response.statusCode != 200) {
      throw HttpException('ユーザー登録に失敗しました。');
    }
    final data = UserResponse.mapper(response.data!);

    return User(data.userId);
  }
}
