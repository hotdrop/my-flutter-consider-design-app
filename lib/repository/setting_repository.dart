import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/models/app_setting.dart';
import 'package:mybt/repository/local/setting_dao.dart';
import 'package:mybt/repository/remote/api/user_api.dart';

final settingRepositoryProvider = Provider((ref) => SettingRepository(ref));

class SettingRepository {
  const SettingRepository(this._ref);

  final Ref _ref;

  Future<AppSetting> find() async {
    AppLogger.d('アプリ設定情報を取得します。');
    final settingDao = _ref.read(settingDaoProvider);
    return AppSetting(
      userId: await settingDao.getUserId(),
      nickName: await settingDao.getNickName(),
      email: await settingDao.getEmail(),
    );
  }

  Future<void> registerUser(String? nickname, String? email) async {
    AppLogger.d('これらの値を保存します: ニックネーム=$nickname メールアドレス: $email');
    final user = await _ref.read(userApiProvider).create(nickname, email);

    await _ref.read(settingDaoProvider).save(userId: user.id, nickName: nickname, email: email);
    AppLogger.d('保存完了しました。 生成UserID=${user.id}');

    // メモリで持っているアプリ設定情報も更新する
    _ref.read(appSettingProvider.notifier).refresh();
  }
}
