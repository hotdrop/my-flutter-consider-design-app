import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/history.dart';
import 'package:mybt/models/point.dart';

part 'point_get_view_model.g.dart';

@riverpod
class PointGetViewModel extends _$PointGetViewModel {
  @override
  void build() {
    // 初期処理があればここで行う
  }

  void input(int newVal) {
    final prevVal = ref.read(_uiStateProvider);
    ref.read(_uiStateProvider.notifier).state = prevVal.copyWith(inputPoint: newVal);
  }

  Future<void> pointGet() async {
    final value = ref.read(_uiStateProvider).inputPoint;
    await ref.read(pointProvider.notifier).acquire(value);
    await ref.read(historyProvider.notifier).saveAcquire(value);
  }
}

final _uiStateProvider = StateProvider<_UiState>((_) => _UiState.empty());

class _UiState {
  _UiState(this.inputPoint);

  factory _UiState.empty() {
    return _UiState(0);
  }

  final int inputPoint;

  _UiState copyWith({int? inputPoint}) {
    return _UiState(
      inputPoint ?? this.inputPoint,
    );
  }
}

// ユーザーが入力したポイント数
final pointGetInputStateProvider = Provider<int>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.inputPoint));
});

///
/// ユーザーが入力したポイント数が獲得可能か
///
final pointGetOkInputPointStateProvider = Provider<bool>((ref) {
  final inputPoint = ref.watch(pointGetInputStateProvider);
  final maxVal = ref.read(pointProvider).maxAvaiablePoint;
  return inputPoint > 0 && inputPoint <= maxVal;
});
