import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/history.dart';
import 'package:mybt/models/point.dart';
import 'package:mybt/repository/local/history_dao.dart';
import 'package:mybt/repository/local/setting_dao.dart';
import 'package:mybt/repository/remote/point_api.dart';
import 'package:mybt/res/R.dart';

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
    // ポイント獲得
    final userId = await _read(settingDaoProvider).getUserId();
    await _read(pointApiProvider).acquired(userId!, inputPoint);

    // 利用履歴登録
    await _read(historyDaoProvider).save(inputPoint, R.res.strings.pointHistoryAcquire);
  }

  Future<void> pointUse(int inputPoint) async {
    // ポイント利用
    final userId = await _read(settingDaoProvider).getUserId();
    await _read(pointApiProvider).use(userId!, inputPoint);

    // 利用履歴登録
    await _read(historyDaoProvider).save(-inputPoint, R.res.strings.pointHistoryUse);
  }

  Future<List<History>> findHistories() async {
    final dao = _read(historyDaoProvider);
    return await dao.findAll();
  }
}
