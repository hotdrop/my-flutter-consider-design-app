import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mybt/models/app_setting.dart';
import 'package:mybt/models/history.dart';
import 'package:mybt/models/point.dart';
import 'package:mybt/repository/point_repository.dart';
import 'package:mybt/ui/base_view_model.dart';

final homeViewModel = ChangeNotifierProvider.autoDispose((ref) {
  return HomeViewModel(ref.read);
});

class HomeViewModel extends BaseViewModel {
  HomeViewModel(this._read) {
    init();
  }

  static final dateFormatter = DateFormat('y/M/d H:m:s');

  final Reader _read;

  String get nowDateTimeStr => dateFormatter.format(DateTime.now());

  List<History>? _histories;
  List<History>? get histories => _histories;

  Future<void> init() async {
    try {
      await loadHistories();
      success();
    } on Exception catch (e, s) {
      error('ホーム画面表示時にエラーが発生しました。', exception: e, stackTrace: s);
    }
  }

  Future<void> onRefresh() async {
    await _read(pointProvider.notifier).find();
    await _read(appSettingProvider.notifier).refresh();
    await loadHistories();
    notifyListeners();
  }

  Future<void> loadHistories() async {
    final repo = _read(pointRepositoryProvider);
    final h = await repo.findHistories();
    h.sort((s, v) => v.dateTime.compareTo(s.dateTime));
    _histories = h;
  }
}
