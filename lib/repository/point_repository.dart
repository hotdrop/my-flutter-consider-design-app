import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/point.dart';
import 'package:mybt/repository/local/setting_dao.dart';
import 'package:mybt/repository/remote/point_api.dart';

final pointRepositoryProvider = Provider((ref) => _PointRepository(ref.read));

class _PointRepository {
  const _PointRepository(this._read);

  final Reader _read;

  Future<Point> find() async {
    final dao = _read(settingDaoProvider);
    final userId = await dao.getUserId();

    final pointApi = _read(pointApiProvider);
    return await pointApi.find(userId!);
  }

  Future<void> pointGet(int inputPoint) async {
    final dao = _read(settingDaoProvider);
    final userId = await dao.getUserId();

    final pointApi = _read(pointApiProvider);
    await pointApi.acquired(userId!, inputPoint);
  }
}
