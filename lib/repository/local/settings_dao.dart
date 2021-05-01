import 'package:shared_preferences/shared_preferences.dart';

class SettingsDao {
  const SettingsDao(this._prefs);

  static const _nickNameKey = 'key001';
  static const _loggedInKey = 'key002';
  static const _accountNoKey = 'key003';

  final SharedPreferences _prefs;

  String? findNickName() {
    if (_prefs.containsKey(_nickNameKey)) {
      return _prefs.getString(_nickNameKey);
    } else {
      return null;
    }
  }

  bool findLoggedIn() {
    if (_prefs.containsKey(_loggedInKey)) {
      return _prefs.getBool(_loggedInKey)!;
    } else {
      return false;
    }
  }

  String? findAccountNo() {
    if (_prefs.containsKey(_accountNoKey)) {
      return _prefs.getString(_accountNoKey);
    } else {
      return null;
    }
  }
}
