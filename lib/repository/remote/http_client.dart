import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/remote/fake/fake_http_client.dart';
import 'package:mybt/repository/remote/models/request.dart';

final httpClient = Provider((ref) => HttpClient(ref));

class HttpClient {
  const HttpClient(this._ref);

  final Ref _ref;

  Future<Map<String, Object?>> get(String endpoint, {Request? request}) async {
    Response response;
    if (request == null) {
      response = await _ref.read(dioProvider).get<Map<String, Object?>>(endpoint);
    } else {
      response = await _ref.read(dioProvider).get<Map<String, Object?>>(endpoint, queryParameters: request.urlParam());
    }

    if (response.statusCode != HttpStatus.ok) {
      throw const HttpException('自身のポイント取得に失敗しました。');
    }

    return response.extra;
  }

  Future<Map<String, Object?>> post(String endpoint, {required Request request}) async {
    Response response = await _ref.read(dioProvider).post<Map<String, Object?>>(
          endpoint,
          queryParameters: request.urlParam(),
          data: request.body(),
        );

    if (response.statusCode != HttpStatus.ok) {
      throw const HttpException('自身のポイント取得に失敗しました。');
    }

    return response.extra;
  }
}
