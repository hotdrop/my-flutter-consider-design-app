import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/models/history.dart';
import 'package:mybt/repository/local/entities/history_entity.dart';

final historyDaoProvider = Provider((ref) => _HistoryDao());

class _HistoryDao {
  const _HistoryDao();

  Future<List<History>> findAll() async {
    final box = await Hive.openBox<HistoryEntity>(HistoryEntity.boxName);
    if (box.isEmpty) {
      return [];
    }

    final entities = box.values;
    AppLogger.d('ポイント利用履歴を取得しました。レコード数: ${entities.length}');

    return entities
        .map((e) => History(
              dateTime: e.dateTime,
              point: e.point,
              detail: e.detail,
            ))
        .toList();
  }

  Future<void> save(int point, String detail) async {
    final box = await Hive.openBox<HistoryEntity>(HistoryEntity.boxName);
    final history = HistoryEntity(
      dateTime: DateTime.now(),
      point: point,
      detail: detail,
    );
    await box.add(history);
  }
}
