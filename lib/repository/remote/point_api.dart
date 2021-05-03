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
    final request = {'userId': userId};

    final response = await _httpClient.get<Map<String, Object>>(
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
