import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mybt/models/app_setting.dart';
import 'package:mybt/repository/local/setting_dao.dart';
import 'package:mybt/repository/setting_repository.dart';

import 'setting_repository_test.mocks.dart';

@GenerateMocks([SettingDao])
void main() {
  test('アプリ設定情報を正しく取得できるか確認する', () async {
    final testUserId = 'result1';
    final testNickName = 'result2';
    final testEmail = 'result3';
    final expectAppSetting = AppSetting(userId: testUserId, nickName: testNickName, email: testEmail);

    final mockDao = MockSettingDao();
    when(mockDao.getUserId()).thenAnswer((_) async => testUserId);
    when(mockDao.getNickName()).thenAnswer((_) async => testNickName);
    when(mockDao.getEmail()).thenAnswer((_) async => testEmail);

    final container = ProviderContainer(
      overrides: [settingDaoProvider.overrideWithValue(mockDao)],
    );

    final settingRepository = container.read(settingRepositoryProvider);
    final result = await settingRepository.find();

    expect(result.userId, expectAppSetting.userId);
    expect(result.nickName, expectAppSetting.nickName);
    expect(result.email, expectAppSetting.email);
  });
}
