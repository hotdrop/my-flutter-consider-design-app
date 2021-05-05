import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
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
    return entities
        .map((e) => History(
              dateTime: e.dateTime,
              point: e.point,
              detail: e.detail,
            ))
        .toList();
  }
}
