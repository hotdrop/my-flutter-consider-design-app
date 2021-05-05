import 'package:hive/hive.dart';

part 'history_entity.g.dart';

@HiveType(typeId: 0)
class HistoryEntity extends HiveObject {
  HistoryEntity({
    required this.dateTime,
    required this.point,
    required this.detail,
  });

  @HiveField(0)
  DateTime dateTime;

  @HiveField(1)
  int point;

  @HiveField(2)
  String detail;

  static const String boxName = 'histories';
}
