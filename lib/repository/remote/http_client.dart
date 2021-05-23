import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/remote/fake/fake_http_client.dart';
import 'package:mybt/repository/remote/models/request.dart';

final httpClient = Provider((ref) => HttpClient(ref.read));

class HttpClient {
  const HttpClient(this._read);

  final Reader _read;

  Future<Map<String, Object?>> get(String endpoint, {Request? request}) async {
    Response response;
    if (request == null) {
      response = await _read(dioProvider).get<Map<String, Object?>>(endpoint);
    } else {
      response = await _read(dioProvider).get<Map<String, Object?>>(endpoint, queryParameters: request.urlParam());
    }

    if (response.statusCode != HttpStatus.ok) {
      throw HttpException('自身のポイント取得に失敗しました。');
    }

    return response.extra;
  }

  Future<Map<String, Object?>> post(String endpoint, {required Request request}) async {
    Response response = await _read(dioProvider).post<Map<String, Object?>>(
      endpoint,
      queryParameters: request.urlParam(),
      data: request.body(),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw HttpException('自身のポイント取得に失敗しました。');
    }

    return response.extra;
  }
}
