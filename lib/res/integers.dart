class Integers {
  Integers._({required this.maxPoint});

  factory Integers.createCoffee() {
    return Integers._(
      maxPoint: 5000,
    );
  }

  final int maxPoint;
}
