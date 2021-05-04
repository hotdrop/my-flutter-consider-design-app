import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/point.dart';
import 'package:mybt/repository/remote/fake/fake_http_client.dart';
import 'package:mybt/repository/remote/response/point_response.dart';
import 'package:mybt/res/R.dart';

final pointApiProvider = Provider((ref) => _PointApi(ref.read));

class _PointApi {
  const _PointApi(this._read);

  final Reader _read;

  Future<Point> find(String userId) async {
    final request = {'userId': userId};

    final response = await _read(httpClient).get<Map<String, Object>>(
      '${R.res.url.api}/point',
      queryParameters: request,
    );

    if (response.statusCode != 200) {
      throw HttpException('ポイントの取得に失敗しました。');
    }

    final data = PointResponse.mapper(response.data!);
    return Point(data.point);
  }
}
