import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/app_setting.dart';
import 'package:mybt/models/history.dart';
import 'package:mybt/models/point.dart';
import 'package:mybt/repository/app_setting_repository.dart';
import 'package:mybt/repository/point_repository.dart';

final homeViewModel = StateNotifierProvider.autoDispose<_HomeViewModel, AsyncValue<void>>((ref) {
  return _HomeViewModel(ref);
});

class _HomeViewModel extends StateNotifier<AsyncValue<void>> {
  _HomeViewModel(this._ref) : super(const AsyncValue.loading()) {
    _init();
  }

  final Ref _ref;

  Future<void> _init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await refresh());
  }

  Future<void> refresh() async {
    final appSetting = await _ref.read(appSettingRepositoryProvider).find();
    final point = await _ref.read(pointRepositoryProvider).find();

    final histories = await _ref.read(pointRepositoryProvider).findHistories();
    histories.sort((s, v) => v.dateTime.compareTo(s.dateTime));

    _ref.read(_uiStateProvider.notifier).state = _UiState(appSetting, point, histories);
  }
}

final _uiStateProvider = StateProvider<_UiState>((ref) => _UiState.empty());

class _UiState {
  _UiState(this.appSetting, this.point, this.histories);

  factory _UiState.empty() {
    return _UiState(AppSetting(), const Point(0), []);
  }

  final AppSetting appSetting;
  final Point point;
  final List<History> histories;

  _UiState copyWith({AppSetting? appSetting, Point? point, List<History>? histories}) {
    return _UiState(
      appSetting ?? this.appSetting,
      point ?? this.point,
      histories ?? this.histories,
    );
  }
}

// このやり方だと値が更新されないのでやはり個々のModelクラスに永続Providerを用意する方が良さそう
final homeAppSettingProvider = Provider<AppSetting>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.appSetting));
});

final homeShowPointProvider = Provider<Point>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.point));
});

final homeHistoriesProvider = Provider<List<History>>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.histories));
});
