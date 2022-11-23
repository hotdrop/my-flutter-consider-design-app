import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/history.dart';
import 'package:mybt/repository/local/history_dao.dart';
import 'package:mybt/res/res.dart';

final historyRepositoryProvider = Provider((ref) => HistoryRepository(ref));

class HistoryRepository {
  const HistoryRepository(this._ref);

  final Ref _ref;

  Future<void> save(int inputPoint, String detail) async {
    await _ref.read(historyDaoProvider).save(inputPoint, R.res.strings.pointHistoryAcquire);
  }

  Future<List<History>> findAll() async {
    return await _ref.read(historyDaoProvider).findAll();
  }
}
