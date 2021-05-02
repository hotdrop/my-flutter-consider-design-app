import 'package:shared_preferences/shared_preferences.dart';

class SettingsDao {
  const SettingsDao(this._prefs);

  static const _userIdKey = 'key001';
  static const _nickNameKey = 'key002';

  final SharedPreferences _prefs;

  String? getUserId() {
    if (_prefs.containsKey(_userIdKey)) {
      return _prefs.getString(_userIdKey);
    } else {
      return null;
    }
  }

  String? getNickName() {
    if (_prefs.containsKey(_nickNameKey)) {
      return _prefs.getString(_nickNameKey);
    } else {
      return null;
    }
  }

  void save({required String userId, String? nickName}) {
    _prefs.setString(_userIdKey, userId);
    if (nickName != null) {
      _prefs.setString(_nickNameKey, nickName);
    }
  }
}
