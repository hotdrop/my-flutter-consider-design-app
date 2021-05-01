import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mybt/repository/local/entities/role_entity.dart';
import 'package:mybt/repository/local/role_dao.dart';
import 'package:mybt/repository/local/settings_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  LocalDataSource._();

  static final LocalDataSource _instance = LocalDataSource._();
  static LocalDataSource get instance => _instance;

  RoleDao? _roleDao;
  RoleDao get roleDao => _roleDao!;

  SettingsDao? _settingsDao;
  SettingsDao get settingsDao => _settingsDao!;

  Future<void> init() async {
    if (_isInitialized()) {
      return;
    }

    await Hive.initFlutter();
    Hive.registerAdapter(RoleEntityAdapter());

    final roleBox = await Hive.openBox<RoleEntity>(RoleEntity.boxName);
    _roleDao = RoleDao(roleBox);

    final sharedPrefs = await SharedPreferences.getInstance();
    _settingsDao = SettingsDao(sharedPrefs);
  }

  bool _isInitialized() {
    return _roleDao != null && _settingsDao != null;
  }
}
