class Role {
  const Role(this.name, this.type);

  factory Role.create({required String name, required int typeIdx}) {
    final type = RoleType.values[typeIdx];
    return Role(name, type);
  }

  final String name;
  final RoleType type;
}

enum RoleType { normal, leader }
