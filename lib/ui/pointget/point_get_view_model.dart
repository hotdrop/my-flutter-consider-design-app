import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/history.dart';
import 'package:mybt/models/point.dart';

final pointGetViewModel = Provider((ref) => _PointGetViewModel(ref));

class _PointGetViewModel {
  _PointGetViewModel(this._ref);

  final Ref _ref;

  void input(int newVal) {
    _ref.read(_uiStateProvider.notifier).inputPoint(newVal);
  }

  Future<void> pointGet() async {
    final value = _ref.read(_uiStateProvider).inputPoint;
    await _ref.read(pointProvider.notifier).acquire(value);
    await _ref.read(historyProvider.notifier).saveAcquire(value);
  }
}

final _uiStateProvider = StateNotifierProvider<_UiStateNotifier, _UiState>((_) {
  return _UiStateNotifier(_UiState.empty());
});

class _UiStateNotifier extends StateNotifier<_UiState> {
  _UiStateNotifier(_UiState state) : super(state);

  void inputPoint(int newVal) {
    state = state.copyWith(inputPoint: newVal);
  }
}

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
