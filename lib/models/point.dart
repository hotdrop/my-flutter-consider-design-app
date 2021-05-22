import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/point_repository.dart';

final pointProvider = StateNotifierProvider<PointNotifier, Point>((ref) {
  return PointNotifier(ref.read);
});

class PointNotifier extends StateNotifier<Point> {
  PointNotifier(this._read) : super(Point(0));

  final Reader _read;

  Future<void> refresh() async {
    final repository = _read(pointRepositoryProvider);
    state = await repository.find();
  }
}

class Point {
  const Point(this.balance);
  final int balance;
}
