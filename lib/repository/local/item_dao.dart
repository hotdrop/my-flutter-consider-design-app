import 'package:hive/hive.dart';
import 'package:mybt/models/item.dart';
import 'package:mybt/repository/local/entities/item_entity.dart';

class ItemDao {
  ItemDao(this._box);

  final Box<ItemEntity> _box;

  List<Item> findAll() {
    if (_box.isEmpty) {
      return [];
    }

    final entities = _box.values;
    return entities
        .map((e) => Item(
              name: e.name,
              overview: e.overview,
              price: e.price,
            ))
        .toList();
  }
}
