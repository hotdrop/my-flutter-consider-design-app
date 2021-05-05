import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mybt/models/app_setting.dart';
import 'package:mybt/models/history.dart';
import 'package:mybt/models/point.dart';
import 'package:mybt/repository/point_repository.dart';
import 'package:mybt/ui/base_view_model.dart';

final homeViewModel = ChangeNotifierProvider.autoDispose((ref) {
  final point = ref.watch(pointProvider);
  final appSetting = ref.watch(appSettingProvider);
  return HomeViewModel(ref.read, point, appSetting);
});

class HomeViewModel extends BaseViewModel {
  HomeViewModel(this._read, this.point, this.appSetting) {
    init();
  }

  static final dateFormatter = DateFormat('y/M/d H:m:s');

  final Reader _read;

  Point point;
  AppSetting appSetting;
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
    _histories = await repo.findHistories();
  }
}
