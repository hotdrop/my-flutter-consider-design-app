import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'fake_http_client.g.dart';

@JsonLiteral('fake_coffee_user.json')
final _fakeCoffeeUser = _$_fakeCoffeeUserJsonLiteral;

final httpClient = Provider((ref) => _FakeDio());

class _FakeDio implements Dio {
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
        acquirePoint(point);
        return FakeResponse({}, statusCode: 200) as Response<T>;
      case 'https://fake.mybt.coffee.jp/api/v1/point/use':
        // 通信してるっぽくしたいのでdelayをさせる
        await Future<void>.delayed(Duration(seconds: 1));
        final point = queryParameters?['inputPoint'] as int;
        usePoint(point);
        return FakeResponse({}, statusCode: 200) as Response<T>;
      default:
        throw UnimplementedError();
    }
  }

  Future<void> acquirePoint(int inputPoint) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final currentPoint = sharedPrefs.getInt(fakeLocalStorePointKey) ?? 0;
    final p = currentPoint + inputPoint;
    sharedPrefs.setInt(fakeLocalStorePointKey, p);
  }

  Future<void> usePoint(int inputPoint) async {
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
