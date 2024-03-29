import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mybt/models/app_setting.dart';
import 'package:mybt/repository/app_setting_repository.dart';

part 'splash_view_model.g.dart';

@riverpod
class SplashViewModel extends _$SplashViewModel {
  @override
  Future<void> build() async {
    await ref.read(appSettingRepositoryProvider).init();
    final appSetting = await ref.read(appSettingRepositoryProvider).find();
    ref.read(_uiStateProvider.notifier).state = _UiState(appSetting);
  }
}

final _uiStateProvider = StateProvider<_UiState?>((ref) => null);

class _UiState {
  const _UiState(this.appSetting);

  final AppSetting appSetting;
}

final splashAppSettingProvider = Provider<AppSetting?>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value?.appSetting));
});
