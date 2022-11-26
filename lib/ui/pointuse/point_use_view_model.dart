import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/history.dart';
import 'package:mybt/models/point.dart';

part 'point_use_view_model.g.dart';

@riverpod
class PointUseViewModel extends _$PointUseViewModel {
  @override
  void build() {
    // 初期処理があればここで行う
  }

  void input(int newVal) {
    final prevVal = ref.read(_uiStateProvider);
    ref.read(_uiStateProvider.notifier).state = prevVal.copyWith(inputPoint: newVal);
  }

  Future<void> execute() async {
    final value = ref.read(pointUseInputStateProvider);
    await ref.read(pointProvider.notifier).use(value);
    await ref.read(historyProvider.notifier).saveUse(value);
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
final pointUseInputStateProvider = Provider<int>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.inputPoint));
});

// ユーザーが入力したポイント数が利用可能か
final pointUseOkInputPointStateProvider = StateProvider<bool>((ref) {
  final inputVal = ref.watch(pointUseInputStateProvider);
  final holdVal = ref.watch(pointProvider).balance;
  return inputVal > 0 && inputVal <= holdVal;
});
