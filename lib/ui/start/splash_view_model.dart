import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/app_setting.dart';
import 'package:mybt/repository/app_setting_repository.dart';
import 'package:mybt/repository/local/local_data_source.dart';

final splashViewModel = StateNotifierProvider.autoDispose<_SplashViewModel, AsyncValue<void>>((ref) {
  return _SplashViewModel(ref);
});

class _SplashViewModel extends StateNotifier<AsyncValue<void>> {
  _SplashViewModel(this._ref) : super(const AsyncValue.loading()) {
    _init();
  }

  final Ref _ref;

  Future<void> _init() async {
    state = const AsyncValue.loading();

    // 起動処理が一瞬で終わってしまうので、もう少し重い処理がある想定で1秒ディレイしている
    await Future<void>.delayed(const Duration(seconds: 1));

    state = await AsyncValue.guard((() async {
      await _ref.read(localDataSourceProvider).init();
      final appSetting = await _ref.read(appSettingRepositoryProvider).find();
      _ref.read(_uiStateProvider.notifier).state = _UiState(appSetting);
    }));
  }
}

final _uiStateProvider = StateProvider<_UiState>((ref) => _UiState.empty());

class _UiState {
  _UiState(this.appSetting);

  factory _UiState.empty() {
    return _UiState(AppSetting());
  }

  final AppSetting appSetting;

  _UiState copyWith({AppSetting? appSetting}) {
    return _UiState(
      appSetting ?? this.appSetting,
    );
  }
}

final splashAppSettingProvider = Provider<AppSetting>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.appSetting));
});
