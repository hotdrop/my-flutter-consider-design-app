import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/models/role.dart';
import 'package:mybt/repository/local/local_data_source.dart';
import 'package:mybt/repository/settings_repository.dart';

final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSetting>((ref) {
  return AppSettingsNotifier(ref.read);
});

class AppSettingsNotifier extends StateNotifier<AppSetting> {
  AppSettingsNotifier(this._read) : super(AppSetting());

  final Reader _read;

  Future<void> init() async {
    AppLogger.d('AppSettingsの初期化を開始します。');
    await LocalDataSource.instance.init();
    await Future<void>.delayed(Duration(seconds: 3));
    AppLogger.d('AppSettingsの初期化が完了しました。');

    // 初期化が完了してからripositoryのProviderを使う
    final repository = _read(SettingsRepositoryProvider);
    state = await repository.find();
  }

  Future<void> refresh() async {
    AppLogger.d('アプリ設定のrefreshが呼ばれました。');
    final repository = _read(SettingsRepositoryProvider);
    state = await repository.find();
  }
}

class AppSetting {
  AppSetting({this.userId, this.myRole, this.nickName});

  final String? userId;
  final Role? myRole;
  final String? nickName;

  bool isInitialized() {
    return userId != null;
  }
}
