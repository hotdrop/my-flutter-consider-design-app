import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/history.dart';
import 'package:mybt/models/point.dart';
import 'package:mybt/repository/local/history_dao.dart';
import 'package:mybt/repository/local/setting_dao.dart';
import 'package:mybt/repository/remote/api/point_api.dart';
import 'package:mybt/res/res.dart';

final pointRepositoryProvider = Provider((ref) => PointRepository(ref.read));

class PointRepository {
  const PointRepository(this._read);

  final Reader _read;

  Future<Point> find() async {
    final userId = await _read(settingDaoProvider).getUserId();
    return await _read(pointApiProvider).find(userId!);
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
    return await _read(historyDaoProvider).findAll();
  }
}
