import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/history.dart';
import 'package:mybt/repository/local/history_dao.dart';
import 'package:mybt/res/res.dart';
import 'package:mybt/ui/home/home_view_model.dart';

final historyRepositoryProvider = Provider((ref) => HistoryRepository(ref));

class HistoryRepository {
  const HistoryRepository(this._ref);

  final Ref _ref;

  Future<List<History>> findAll() async {
    final histories = await _ref.read(historyDaoProvider).findAll();
    histories.sort((s, v) => v.dateTime.compareTo(s.dateTime));
    return histories;
  }

  Future<void> saveAcquire(int value) async {
    await _ref.read(historyDaoProvider).save(value, R.res.strings.pointHistoryAcquire);
    // TODO RepositoryがViewModelを知っているのは嫌なのでなんとかする
    _ref.invalidate(homeViewModelProvider);
  }

  Future<void> saveUse(int value) async {
    await _ref.read(historyDaoProvider).save(-value, R.res.strings.pointHistoryUse);
    // TODO RepositoryがViewModelを知っているのは嫌なのでなんとかする
    _ref.invalidate(homeViewModelProvider);
  }
}
