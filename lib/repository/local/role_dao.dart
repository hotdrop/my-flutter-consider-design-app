import 'package:hive/hive.dart';
import 'package:mybt/models/role.dart';
import 'package:mybt/repository/local/entities/role_entity.dart';

class RoleDao {
  RoleDao(this._box);

  final Box<RoleEntity> _box;

  Role? find() {
    if (_box.isEmpty) {
      return null;
    }

    final entity = _box.values.first;
    return Role.create(name: entity.name, typeIdx: entity.type);
  }
}
