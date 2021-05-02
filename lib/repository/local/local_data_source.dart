import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mybt/repository/local/entities/item_entity.dart';
import 'package:mybt/repository/local/item_dao.dart';
import 'package:mybt/repository/local/settings_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  LocalDataSource._();

  static final LocalDataSource _instance = LocalDataSource._();
  static LocalDataSource get instance => _instance;

  ItemDao? _itemDao;
  ItemDao get itemDao => _itemDao!;

  SettingsDao? _settingsDao;
  SettingsDao get settingsDao => _settingsDao!;

  Future<void> init() async {
    if (_isInitialized()) {
      return;
    }

    await Hive.initFlutter();
    Hive.registerAdapter(ItemEntityAdapter());

    final roleBox = await Hive.openBox<ItemEntity>(ItemEntity.boxName);
    _itemDao = ItemDao(roleBox);

    final sharedPrefs = await SharedPreferences.getInstance();
    _settingsDao = SettingsDao(sharedPrefs);
  }

  bool _isInitialized() {
    return _itemDao != null && _settingsDao != null;
  }
}
