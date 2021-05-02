import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/point_repository.dart';

final pointProvider = StateNotifierProvider<UserNotifier, List<Point>>((ref) {
  return UserNotifier(ref.read);
});

class UserNotifier extends StateNotifier<List<Point>> {
  UserNotifier(this._read) : super([]);

  final Reader _read;

  Future<void> find() async {
    // repositoryから所持ポイントを取得
    final repository = _read(pointRepositoryProvider);
    state = await repository.find();
  }
}

class Point {
  const Point({required this.balance, required this.name});
  final int balance;
  final String name;
}
