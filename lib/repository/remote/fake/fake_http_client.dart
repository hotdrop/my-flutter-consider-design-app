import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/res/R.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'fake_http_client.g.dart';

@JsonLiteral('fake_coffee_user.json')
final _fakeCoffeeUser = _$_fakeCoffeeUserJsonLiteral;

final dioProvider = Provider((ref) => _FakeDio.create());

class _FakeDio implements Dio {
  const _FakeDio._();

  factory _FakeDio.create() {
    final options = BaseOptions(
      baseUrl: R.res.url.api,
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: <String, String>{
        HttpHeaders.userAgentHeader: 'dio',
        'Content-Type': 'application/json',
      },
    );
    final dio = _FakeDio._();
    dio.options = options;
    return dio;
  }

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
    AppLogger.d('$path をgetで叩きます。');
    switch (path) {
      case 'https://fake.mybt.coffee.jp/api/v1/user/$fakeCoffeeUserID':
        // 通信してるっぽくしたいのでdelayをさせる
        await Future<void>.delayed(Duration(seconds: 1));
        return FakeResponse(_fakeCoffeeUser, statusCode: 200) as Response<T>;
      case 'https://fake.mybt.coffee.jp/api/v1/point':
        final sharedPrefs = await SharedPreferences.getInstance();
        final currentPoint = sharedPrefs.getInt(fakeLocalStorePointKey) ?? 0;
        // 通信してるっぽくしたいのでdelayをさせる
        await Future<void>.delayed(Duration(seconds: 1));
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
    AppLogger.d('$path をpostで叩きます。data=$data');
    switch (path) {
      case 'https://fake.mybt.coffee.jp/api/v1/user':
        // 通信してるっぽくしたいのでdelayをさせる
        await Future<void>.delayed(Duration(seconds: 2));
        return FakeResponse(_fakeCoffeeUser, statusCode: 200) as Response<T>;
      case 'https://fake.mybt.coffee.jp/api/v1/point':
        // 通信してるっぽくしたいのでdelayをさせる
        await Future<void>.delayed(Duration(seconds: 1));
        final point = queryParameters?['inputPoint'] as int;
        _acquirePoint(point);
        return FakeResponse({}, statusCode: 200) as Response<T>;
      case 'https://fake.mybt.coffee.jp/api/v1/point/use':
        // 通信してるっぽくしたいのでdelayをさせる
        await Future<void>.delayed(Duration(seconds: 1));
        final point = queryParameters?['inputPoint'] as int;
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
  void noSuchMethod(Invocation invocation) {
    throw UnimplementedError();
  }
}

class FakeResponse implements Response<Map<String, Object>> {
  FakeResponse(this.data, {required this.statusCode});

  @override
  final Map<String, Object> data;

  @override
  int? statusCode;

  @override
  void noSuchMethod(Invocation invocation) {
    throw UnimplementedError();
  }
}
