import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mybt/models/history.dart';
import 'package:mybt/models/point.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<void> build() async {
    await ref.read(pointProvider.notifier).refresh();
    await ref.read(historyProvider.notifier).refresh();
  }
}
