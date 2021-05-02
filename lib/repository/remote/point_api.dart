import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mybt/models/point.dart';
import 'package:mybt/repository/remote/fake/fake_http_client.dart';
import 'package:mybt/repository/remote/response/point_response.dart';
import 'package:mybt/res/R.dart';

class PointApi {
  const PointApi._(this._httpClient);

  factory PointApi.create() {
    return PointApi._(FakeDio());
  }

  final Dio _httpClient;

  Future<Point> find(String userId) async {
    final url = '${R.res.url.api}/point';
    final response = await _httpClient.get<Map<String, Object>>(url);

    await Future<void>.delayed(Duration(seconds: 1));

    final responseData = response.data;
    if (responseData == null) {
      throw HttpException('ポイントの取得に失敗しました。');
    }

    final data = PointResponse.mapper(responseData);
    return Point(data.point);
  }
}
