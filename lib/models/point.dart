import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/point_repository.dart';
import 'package:mybt/res/res.dart';

final pointProvider = NotifierProvider<PointNotifier, Point>(PointNotifier.new);

class PointNotifier extends Notifier<Point> {
  @override
  Point build() {
    return const Point(0);
  }

  Future<void> acquire(int value) async {
    await ref.read(pointRepositoryProvider).acquire(value);
    await refresh();
  }

  Future<void> use(int value) async {
    await ref.read(pointRepositoryProvider).use(value);
    await refresh();
  }

  Future<void> refresh() async {
    state = await ref.read(pointRepositoryProvider).find();
  }
}

class Point {
  const Point(this.balance);

  final int balance;

  int get maxAvaiablePoint => R.res.integers.maxPoint - balance;
}
