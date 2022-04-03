import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/app_setting.dart';
import 'package:mybt/models/history.dart';
import 'package:mybt/models/point.dart';
import 'package:mybt/repository/point_repository.dart';
import 'package:mybt/ui/base_view_model.dart';

final homeViewModel = ChangeNotifierProvider.autoDispose((ref) {
  return HomeViewModel(ref.read);
});

final homeLoadingPointCardStateProvider = StateProvider<bool>((_) => false);

final homeHistoriesStateProvider = StateNotifierProvider<_HomeHistoriesStateNotifier, List<History>>((ref) {
  return _HomeHistoriesStateNotifier(ref.read);
});

class _HomeHistoriesStateNotifier extends StateNotifier<List<History>> {
  _HomeHistoriesStateNotifier(this._read) : super([]);

  final Reader _read;

  Future<void> refresh() async {
    final h = await _read(pointRepositoryProvider).findHistories();
    h.sort((s, v) => v.dateTime.compareTo(s.dateTime));
    state = h;
  }
}

///
/// ViewModel
///
class HomeViewModel extends BaseViewModel {
  HomeViewModel(this._read) {
    _init();
  }

  final Reader _read;

  ///
  /// ホーム画面の表示に必要な処理を行う
  ///
  Future<void> _init() async {
    try {
      await _read(pointProvider.notifier).refresh();
      _read(homeHistoriesStateProvider.notifier).refresh();
      success();
    } on Exception catch (e, s) {
      error('ホーム画面表示時にエラーが発生しました。', exception: e, stackTrace: s);
    }
  }

  Future<void> onRefresh() async {
    try {
      _read(homeLoadingPointCardStateProvider.notifier).state = true;

      // ロード一瞬で終わってしまうので、もう少し重い処理がある想定で1秒ディレイしている
      await Future<void>.delayed(const Duration(seconds: 1));

      _read(pointProvider.notifier).refresh();
      _read(appSettingProvider.notifier).refresh();
      _read(homeHistoriesStateProvider.notifier).refresh();

      _read(homeLoadingPointCardStateProvider.notifier).state = false;
    } on Exception catch (e, s) {
      error('ホーム画面更新時にエラーが発生しました。', exception: e, stackTrace: s);
    }
  }
}
