import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/app_setting.dart';
import 'package:mybt/models/history.dart';
import 'package:mybt/models/point.dart';
import 'package:mybt/repository/point_repository.dart';

final homeViewModel = StateNotifierProvider.autoDispose<_HomeViewModel, AsyncValue<void>>((ref) {
  return _HomeViewModel(ref.read);
});

class _HomeViewModel extends StateNotifier<AsyncValue<void>> {
  _HomeViewModel(this._read) : super(const AsyncValue.loading()) {
    _init();
  }

  final Reader _read;

  Future<void> _init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _read(pointProvider.notifier).refresh();
      _read(_uiStateProvider.notifier).refresh();
    });
  }

  Future<void> onRefresh() async {
    _read(_uiStateProvider.notifier).onLoaded();

    // ロード一瞬で終わってしまうので、もう少し重い処理がある想定で1秒ディレイしている
    await Future<void>.delayed(const Duration(seconds: 1));

    _read(pointProvider.notifier).refresh();
    _read(appSettingProvider.notifier).refresh();
    _read(_uiStateProvider.notifier).refresh();

    _read(_uiStateProvider.notifier).onLoaded();
  }
}

final _uiStateProvider = StateNotifierProvider<_UiStateNotifier, _UiState>((ref) {
  return _UiStateNotifier(ref.read, _UiState.empty());
});

class _UiStateNotifier extends StateNotifier<_UiState> {
  _UiStateNotifier(this._read, _UiState state) : super(state);

  final Reader _read;

  Future<void> refresh() async {
    final h = await _read(pointRepositoryProvider).findHistories();
    h.sort((s, v) => v.dateTime.compareTo(s.dateTime));
    state = state.copyWith(histories: h);
  }

  void onLoading() {
    state = state.copyWith(loadingPointCard: true);
  }

  void onLoaded() {
    state = state.copyWith(loadingPointCard: false);
  }
}

class _UiState {
  _UiState(this.loadingPointCard, this.histories);

  factory _UiState.empty() {
    return _UiState(false, []);
  }

  final bool loadingPointCard;
  final List<History> histories;

  _UiState copyWith({bool? loadingPointCard, List<History>? histories}) {
    return _UiState(
      loadingPointCard ?? this.loadingPointCard,
      histories ?? this.histories,
    );
  }
}

final homeLoadingPointCardStateProvider = Provider<bool>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.loadingPointCard));
});

final homeHistoriesProvider = Provider<List<History>>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.histories));
});
