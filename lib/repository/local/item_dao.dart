import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:mybt/models/item.dart';
import 'package:mybt/repository/local/entities/item_entity.dart';

final itemDaoProvider = Provider((ref) => _ItemDao());

class _ItemDao {
  const _ItemDao();

  Future<List<Item>> findAll() async {
    final box = await Hive.openBox<ItemEntity>(ItemEntity.boxName);
    if (box.isEmpty) {
      return [];
    }

    final entities = box.values;
    return entities
        .map((e) => Item(
              name: e.name,
              overview: e.overview,
              price: e.price,
            ))
        .toList();
  }
}
