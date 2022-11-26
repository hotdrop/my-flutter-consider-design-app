import 'package:mybt/res/res.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:intl/intl.dart';
import 'package:mybt/repository/history_repository.dart';

final historyProvider = NotifierProvider<HistoryNotifier, List<History>>(HistoryNotifier.new);

class HistoryNotifier extends Notifier<List<History>> {
  @override
  List<History> build() {
    return [];
  }

  Future<void> saveAcquire(int value) async {
    await ref.read(historyRepositoryProvider).save(value, R.res.strings.pointHistoryAcquire);
    await refresh();
  }

  Future<void> saveUse(int value) async {
    await ref.read(historyRepositoryProvider).save(-value, R.res.strings.pointHistoryUse);
    await refresh();
  }

  Future<void> refresh() async {
    final histories = await ref.read(historyRepositoryProvider).findAll();
    histories.sort((s, v) => v.dateTime.compareTo(s.dateTime));
    state = histories;
  }
}

class History {
  const History({
    required this.dateTime,
    required this.point,
    required this.detail,
  });

  final DateTime dateTime;
  final int point;
  final String detail;

  String toStringDateTime() {
    return DateFormat('yyyy/MM/dd HH:mm').format(dateTime);
  }
}
