import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/point_repository.dart';

final pointProvider = StateNotifierProvider<PointNotifier, Point>((ref) {
  return PointNotifier(ref);
});

class PointNotifier extends StateNotifier<Point> {
  PointNotifier(this._ref) : super(const Point(0));

  final Ref _ref;

  Future<void> refresh() async {
    state = await _ref.read(pointRepositoryProvider).find();
  }
}

class Point {
  const Point(this.balance);
  final int balance;
}
