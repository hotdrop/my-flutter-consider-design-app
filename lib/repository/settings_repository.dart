import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/models/app_settings.dart';
import 'package:mybt/models/role.dart';
import 'package:mybt/repository/local/local_data_source.dart';
import 'package:mybt/repository/local/role_dao.dart';
import 'package:mybt/repository/local/settings_dao.dart';
import 'package:mybt/repository/remote/user_api.dart';

final SettingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(
    LocalDataSource.instance.roleDao,
    LocalDataSource.instance.settingsDao,
    UserApi.create(),
    ref.read,
  );
});

class SettingsRepository {
  const SettingsRepository(
    this._roleDao,
    this._settingsDao,
    this._userApi,
    this._read,
  );

  final RoleDao _roleDao;
  final SettingsDao _settingsDao;
  final UserApi _userApi;

  final Reader _read;

  Future<AppSetting> find() async {
    AppLogger.d('アプリ設定情報を取得します。');
    return AppSetting(
      userId: _settingsDao.getUserId(),
      myRole: _roleDao.getMyRole(),
      nickName: _settingsDao.getNickName(),
    );
  }

  Future<void> registerUser(String? nickname, RoleType type) async {
    AppLogger.d('これらの値を保存します: ニックネーム=$nickname タイプ: $type');
    final user = await _userApi.create(nickname, type);
    _settingsDao.save(userId: user.id, nickName: nickname);
    AppLogger.d('保存完了しました。 生成UserID=${user.id}');
    _read(appSettingsProvider.notifier).refresh();
  }
}
