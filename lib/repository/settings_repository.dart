import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/models/app_settings.dart';
import 'package:mybt/models/role.dart';
import 'package:mybt/repository/local/local_data_source.dart';
import 'package:mybt/repository/local/role_dao.dart';
import 'package:mybt/repository/local/settings_dao.dart';

final SettingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(
    LocalDataSource.instance.roleDao,
    LocalDataSource.instance.settingsDao,
  );
});

class SettingsRepository {
  const SettingsRepository(this._roleDao, this._settingsDao);

  final RoleDao _roleDao;
  final SettingsDao _settingsDao;

  Future<AppSetting> find() async {
    return AppSetting(
      myRole: _roleDao.find(),
      nickName: _settingsDao.findNickName(),
      loggedIn: _settingsDao.findLoggedIn(),
    );
  }

  Future<void> registerUser(String? nickname, RoleType type) async {
    AppLogger.d('これらの値を保存します: ニックネーム=$nickname タイプ: $type');
    // TODO アカウントNoを生成して保存処理する
    await Future<void>.delayed(Duration(seconds: 2));
  }
}
