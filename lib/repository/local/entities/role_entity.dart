import 'package:hive/hive.dart';

part 'role_entity.g.dart';

@HiveType(typeId: 0)
class RoleEntity extends HiveObject {
  RoleEntity({required this.name, required this.type});

  @HiveField(0)
  String name;

  @HiveField(1)
  int type;

  static const String boxName = 'roles';
}
