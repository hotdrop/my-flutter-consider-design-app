import 'package:mybt/res/res.dart';

class Point {
  const Point(this.balance);

  final int balance;

  int get maxAvaiablePoint => R.res.integers.maxPoint - balance;
}
