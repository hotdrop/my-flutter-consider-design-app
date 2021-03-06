import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mybt/repository/local/entities/history_entity.dart';

final localDataSourceProvider = Provider((ref) => const _LocalDataSource());

class _LocalDataSource {
  const _LocalDataSource();

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HistoryEntityAdapter());
  }
}
