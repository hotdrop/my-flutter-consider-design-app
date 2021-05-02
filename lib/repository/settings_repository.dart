import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/models/app_settings.dart';
import 'package:mybt/repository/local/local_data_source.dart';
import 'package:mybt/repository/local/settings_dao.dart';
import 'package:mybt/repository/remote/user_api.dart';

final SettingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(
    LocalDataSource.instance.settingsDao,
    UserApi.create(),
    ref.read,
  );
});

class SettingsRepository {
  const SettingsRepository(
    this._settingsDao,
    this._userApi,
    this._read,
  );

  final SettingsDao _settingsDao;
  final UserApi _userApi;
  final Reader _read;

  Future<AppSetting> find() async {
    AppLogger.d('アプリ設定情報を取得します。');
    return AppSetting(
      userId: _settingsDao.getUserId(),
      nickName: _settingsDao.getNickName(),
      email: _settingsDao.getEmail(),
    );
  }

  Future<void> registerUser(String? nickname, String? email) async {
    AppLogger.d('これらの値を保存します: ニックネーム=$nickname メールアドレス: $email');
    final user = await _userApi.create(nickname, email);

    _settingsDao.save(userId: user.id, nickName: nickname, email: email);
    AppLogger.d('保存完了しました。 生成UserID=${user.id}');

    // メモリで持っているアプリ設定情報も更新する
    _read(appSettingsProvider.notifier).refresh();
  }
}
