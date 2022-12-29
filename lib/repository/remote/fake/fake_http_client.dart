import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/res/res.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'fake_http_client.g.dart';

@JsonLiteral('fake_coffee_user.json')
final _fakeCoffeeUser = _$_fakeCoffeeUserJsonLiteral;

final dioProvider = Provider((ref) {
  final options = BaseOptions(
    baseUrl: R.res.url.api,
    connectTimeout: 5000,
    receiveTimeout: 3000,
    headers: <String, String>{
      HttpHeaders.userAgentHeader: 'dio',
      'Content-Type': 'application/json',
    },
  );
  final dio = _FakeDio(options);
  return dio;
});

class _FakeDio implements Dio {
  _FakeDio(this.options);

  static const String fakeCoffeeUserID = '4d58da01395bcaf9';
  static const String fakeLocalStorePointKey = 'key101';

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    AppLogger.d('${this.options.baseUrl}$path をgetで叩きます。');
    switch (path) {
      case '/user/$fakeCoffeeUserID':
        // 通信してるっぽくしたいのでdelayをさせる
        await Future<void>.delayed(const Duration(milliseconds: 500));
        return FakeResponse(_fakeCoffeeUser, statusCode: 200) as Response<T>;
      case '/point':
        final sharedPrefs = await SharedPreferences.getInstance();
        final currentPoint = sharedPrefs.getInt(fakeLocalStorePointKey) ?? 0;
        // 通信してるっぽくしたいのでdelayをさせる
        await Future<void>.delayed(const Duration(milliseconds: 500));
        return FakeResponse({'point': currentPoint}, statusCode: 200) as Response<T>;
    }
    throw UnimplementedError();
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    AppLogger.d('${this.options.baseUrl}$path をpostで叩きます。data=$data');
    switch (path) {
      case '/user':
        // 通信してるっぽくしたいのでdelayをさせる
        await Future<void>.delayed(const Duration(seconds: 2));
        return FakeResponse(_fakeCoffeeUser, statusCode: 200) as Response<T>;
      case '/point':
        // 通信してるっぽくしたいのでdelayをさせる
        await Future<void>.delayed(const Duration(seconds: 1));
        final point = data?['inputPoint'] as int;
        _acquirePoint(point);
        return FakeResponse({}, statusCode: 200) as Response<T>;
      case '/point/use':
        // 通信してるっぽくしたいのでdelayをさせる
        await Future<void>.delayed(const Duration(seconds: 1));
        final point = data?['inputPoint'] as int;
        _usePoint(point);
        return FakeResponse({}, statusCode: 200) as Response<T>;
      default:
        throw UnimplementedError();
    }
  }

  Future<void> _acquirePoint(int inputPoint) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final currentPoint = sharedPrefs.getInt(fakeLocalStorePointKey) ?? 0;
    final p = currentPoint + inputPoint;
    sharedPrefs.setInt(fakeLocalStorePointKey, p);
  }

  Future<void> _usePoint(int inputPoint) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final currentPoint = sharedPrefs.getInt(fakeLocalStorePointKey) ?? 0;
    final p = currentPoint - inputPoint;
    sharedPrefs.setInt(fakeLocalStorePointKey, p);
  }

  @override
  BaseOptions options;

  @override
  void noSuchMethod(Invocation invocation) {
    throw UnimplementedError();
  }
}

class FakeResponse implements Response<Map<String, Object>> {
  FakeResponse(this.data, {required this.statusCode}) : extra = data;

  @override
  final Map<String, Object> data;

  @override
  Map<String, dynamic> extra;

  @override
  int? statusCode;

  @override
  void noSuchMethod(Invocation invocation) {
    throw UnimplementedError();
  }
}
