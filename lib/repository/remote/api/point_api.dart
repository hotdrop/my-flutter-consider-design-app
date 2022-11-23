import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/point.dart';
import 'package:mybt/repository/remote/http_client.dart';
import 'package:mybt/repository/remote/models/get_point_request.dart';
import 'package:mybt/repository/remote/models/point_response.dart';
import 'package:mybt/repository/remote/models/post_point_request.dart';

final pointApiProvider = Provider((ref) => PointApi(ref));

class PointApi {
  const PointApi(this._ref);

  final Ref _ref;

  ///
  /// ユーザーの保有ポイント取得
  ///
  Future<Point> find(String userId) async {
    final response = await _ref.read(httpClient).get(
          '/point',
          request: GetPointRequest(userId),
        );

    final pointResponse = PointResponse.mapper(response);
    return Point(pointResponse.point);
  }

  ///
  ///ポイント獲得
  ///
  Future<void> acquired(String userId, int inputPoint) async {
    await _ref.read(httpClient).post(
          '/point',
          request: PostPointRequest(userId, inputPoint),
        );
  }

  ///
  ///ポイント利用
  ///
  Future<void> use(String userId, int inputPoint) async {
    await _ref.read(httpClient).post(
          '/point/use',
          request: PostPointRequest(userId, inputPoint),
        );
  }
}
