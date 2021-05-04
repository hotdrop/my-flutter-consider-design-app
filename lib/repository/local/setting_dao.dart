import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingDaoProvider = Provider((ref) => _SettingDao());

class _SettingDao {
  const _SettingDao();

  static const _userIdKey = 'key001';
  static const _nickNameKey = 'key002';
  static const _emailKey = 'key003';

  Future<String?> getUserId() => getStringValue(_userIdKey);
  Future<String?> getNickName() => getStringValue(_nickNameKey);
  Future<String?> getEmail() => getStringValue(_emailKey);

  Future<String?> getStringValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return prefs.getString(key);
    } else {
      return null;
    }
  }

  Future<void> save({required String userId, String? nickName, String? email}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_userIdKey, userId);
    if (nickName != null) {
      prefs.setString(_nickNameKey, nickName);
    }
    if (email != null) {
      prefs.setString(_emailKey, email);
    }
  }
}
