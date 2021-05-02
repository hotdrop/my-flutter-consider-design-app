import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/point.dart';
import 'package:mybt/repository/local/local_data_source.dart';
import 'package:mybt/repository/local/settings_dao.dart';
import 'package:mybt/repository/remote/point_api.dart';

final pointRepositoryProvider = Provider<PointRepository>((ref) {
  return PointRepository(
    PointApi.create(),
    LocalDataSource.instance.settingsDao,
  );
});

class PointRepository {
  const PointRepository(this._api, this._settingsDao);

  final PointApi _api;
  final SettingsDao _settingsDao;

  Future<List<Point>> find() async {
    // APIでポイント取得
    final accountNo = _settingsDao.getUserId()!;
    return _api.find(accountNo);
  }
}