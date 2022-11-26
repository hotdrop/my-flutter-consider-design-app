import 'package:mybt/repository/app_setting_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mybt/models/app_setting.dart';

part 'splash_view_model.g.dart';

@riverpod
class SplashViewModel extends _$SplashViewModel {
  @override
  Future<void> build() async {
    await ref.read(appSettingRepositoryProvider).init();
    await ref.read(appSettingProvider.notifier).load();
  }
}
