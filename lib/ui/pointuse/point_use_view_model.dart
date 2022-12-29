import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/history_repository.dart';
import 'package:mybt/models/point.dart';
import 'package:mybt/repository/point_repository.dart';

part 'point_use_view_model.g.dart';

@riverpod
class PointUseViewModel extends _$PointUseViewModel {
  @override
  Future<void> build() async {
    final currentPoint = await ref.read(pointRepositoryProvider).find();
    ref.read(_uiStateProvider.notifier).state = _UiState(0, currentPoint);
  }

  void input(int newVal) {
    final prevVal = ref.read(_uiStateProvider);
    ref.read(_uiStateProvider.notifier).state = prevVal.copyWith(inputPoint: newVal);
  }

  Future<void> execute() async {
    final value = ref.read(pointUseInputStateProvider);
    await ref.read(pointRepositoryProvider).use(value);
    await ref.read(historyRepositoryProvider).saveUse(value);
  }
}

final _uiStateProvider = StateProvider<_UiState>((_) => _UiState.empty());

class _UiState {
  _UiState(this.inputPoint, this.currentPoint);

  factory _UiState.empty() {
    return _UiState(0, const Point(0));
  }

  final int inputPoint;
  final Point currentPoint;

  int getHoldBalance() {
    return currentPoint.balance;
  }

  ///
  /// 現在ポイントはポイント利用フローの途中では絶対変わらないのでcopyWithには含めない
  ///
  _UiState copyWith({int? inputPoint}) {
    return _UiState(
      inputPoint ?? this.inputPoint,
      currentPoint,
    );
  }
}

final pointUseCurrentPointProvider = Provider<Point>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.currentPoint));
});

// ユーザーが入力したポイント数
final pointUseInputStateProvider = Provider<int>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.inputPoint));
});

// ユーザーが入力したポイント数が利用可能か
final pointUseOkInputPointStateProvider = Provider<bool>((ref) {
  final inputVal = ref.watch(pointUseInputStateProvider);
  final holdVal = ref.watch(_uiStateProvider).getHoldBalance();
  return inputVal > 0 && inputVal <= holdVal;
});
