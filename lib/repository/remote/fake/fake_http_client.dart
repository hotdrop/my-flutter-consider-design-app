import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'fake_http_client.g.dart';

@JsonLiteral('fake_coffee_user.json')
final _fakeCoffeeUser = _$_fakeCoffeeUserJsonLiteral;

class FakeDio implements Dio {
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
        return FakeResponse(_fakeCoffeeUser) as Response<T>;
      case 'https://fake.mybt.coffee.jp/api/v1/point':
        final sharedPrefs = await SharedPreferences.getInstance();
        final currentPoint = sharedPrefs.getInt(fakeLocalStorePointKey) ?? 0;
        return FakeResponse({'point': currentPoint}) as Response<T>;
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
        return FakeResponse(_fakeCoffeeUser) as Response<T>;
      default:
        throw UnimplementedError();
    }
  }

  @override
  void noSuchMethod(Invocation invocation) {
    throw UnimplementedError();
  }
}

class FakeResponse implements Response<Map<String, Object>> {
  FakeResponse(this.data);

  @override
  final Map<String, Object> data;

  @override
  void noSuchMethod(Invocation invocation) {
    throw UnimplementedError();
  }
}
