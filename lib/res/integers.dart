class Integers {
  Integers._({required this.maxPoint});

  factory Integers.createCoffee() {
    return Integers._(
      maxPoint: 5000,
    );
  }

  factory Integers.createTea() {
    return Integers._(
      maxPoint: 4500,
    );
  }

  final int maxPoint;
}
