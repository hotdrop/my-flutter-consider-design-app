import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/history_repository.dart';
import 'package:mybt/models/point.dart';
import 'package:mybt/repository/point_repository.dart';

part 'point_get_view_model.g.dart';

@riverpod
class PointGetViewModel extends _$PointGetViewModel {
  @override
  Future<void> build() async {
    final currentPoint = await ref.read(pointRepositoryProvider).find();
    ref.read(_uiStateProvider.notifier).state = _UiState(0, currentPoint);
  }

  void input(int newVal) {
    final prevVal = ref.read(_uiStateProvider);
    ref.read(_uiStateProvider.notifier).state = prevVal.copyWith(inputPoint: newVal);
  }

  Future<void> pointGet() async {
    final value = ref.read(_uiStateProvider).inputPoint;
    await ref.read(pointRepositoryProvider).acquire(value);
    await ref.read(historyRepositoryProvider).saveAcquire(value);
  }
}

final _uiStateProvider = StateProvider<_UiState>((_) => _UiState.empty());

class _UiState {
  _UiState(this.inputPoint, this.currentPoint);

  // これいちいち作ってられないのでStateProviderをnull許容にした方がいいのか・・
  factory _UiState.empty() {
    return _UiState(0, const Point(0));
  }

  final int inputPoint;
  final Point currentPoint;

  int getUpperLimit() {
    return currentPoint.maxAvaiablePoint;
  }

  ///
  /// 現在ポイントはポイント獲得フローの途中では絶対変わらないのでcopyWithには含めない
  ///
  _UiState copyWith({int? inputPoint}) {
    return _UiState(
      inputPoint ?? this.inputPoint,
      currentPoint,
    );
  }
}

final pointGetCurrentPointProvider = Provider<Point>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.currentPoint));
});

// ユーザーが入力したポイント数
final pointGetInputStateProvider = Provider<int>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.inputPoint));
});

// ユーザーが入力したポイント数が獲得可能か
final pointGetOkInputPointStateProvider = Provider<bool>((ref) {
  final inputPoint = ref.watch(pointGetInputStateProvider);
  final maxVal = ref.watch(_uiStateProvider).getUpperLimit();
  return inputPoint > 0 && inputPoint <= maxVal;
});
