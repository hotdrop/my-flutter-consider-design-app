import 'package:hive/hive.dart';

part 'item_entity.g.dart';

@HiveType(typeId: 0)
class ItemEntity extends HiveObject {
  ItemEntity({
    required this.name,
    required this.overview,
    required this.price,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  String overview;

  @HiveField(2)
  int price;

  static const String boxName = 'items';
}
