import 'package:shared_preferences/shared_preferences.dart';

class SettingsDao {
  const SettingsDao(this._prefs);

  static const _userIdKey = 'key001';
  static const _nickNameKey = 'key002';
  static const _emailKey = 'key003';

  final SharedPreferences _prefs;

  String? getUserId() => getStringValue(_userIdKey);
  String? getNickName() => getStringValue(_nickNameKey);
  String? getEmail() => getStringValue(_emailKey);

  String? getStringValue(String key) {
    if (_prefs.containsKey(key)) {
      return _prefs.getString(key);
    } else {
      return null;
    }
  }

  void save({required String userId, String? nickName, String? email}) {
    _prefs.setString(_userIdKey, userId);
    if (nickName != null) {
      _prefs.setString(_nickNameKey, nickName);
    }
    if (email != null) {
      _prefs.setString(_emailKey, email);
    }
  }
}
