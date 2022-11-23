import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/repository/setting_repository.dart';

final appSettingProvider = StateNotifierProvider<AppSettingsNotifier, AppSetting>((ref) {
  return AppSettingsNotifier(ref);
});

class AppSettingsNotifier extends StateNotifier<AppSetting> {
  AppSettingsNotifier(this._ref) : super(AppSetting());

  final Ref _ref;

  Future<void> refresh() async {
    AppLogger.d('アプリ設定のrefreshが呼ばれました。');
    state = await _ref.read(settingRepositoryProvider).find();
  }
}

class AppSetting {
  AppSetting({this.userId, this.nickName, this.email});

  final String? userId;
  final String? nickName;
  final String? email;

  bool isInitialized() {
    return userId != null;
  }
}
