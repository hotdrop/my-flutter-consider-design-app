import 'package:flutter_riverpod/flutter_riverpod.dart';

final pointProvider = StateNotifierProvider<PointNotifier, List<Point>>((ref) {
  return PointNotifier(ref.read);
});

class PointNotifier extends StateNotifier<List<Point>> {
  PointNotifier(this._read) : super([]);

  final Reader _read;

  Future<void> find() async {
    // repositoryからポイントを取得
    // ポイントをstateに入れる
  }
}

class Point {
  const Point({required this.balance, required this.name});
  final int balance;
  final String name;
}
