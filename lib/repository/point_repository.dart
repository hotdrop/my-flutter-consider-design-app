import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/point.dart';
import 'package:mybt/repository/local/setting_dao.dart';
import 'package:mybt/repository/remote/api/point_api.dart';

final pointRepositoryProvider = Provider((ref) => PointRepository(ref));

class PointRepository {
  const PointRepository(this._ref);

  final Ref _ref;

  Future<Point> find() async {
    final userId = await _ref.read(settingDaoProvider).getUserId();
    return await _ref.read(pointApiProvider).find(userId!);
  }

  Future<void> acquire(int inputPoint) async {
    final userId = await _ref.read(settingDaoProvider).getUserId();
    await _ref.read(pointApiProvider).acquired(userId!, inputPoint);
  }

  Future<void> use(int inputPoint) async {
    final userId = await _ref.read(settingDaoProvider).getUserId();
    await _ref.read(pointApiProvider).use(userId!, inputPoint);
  }
}
