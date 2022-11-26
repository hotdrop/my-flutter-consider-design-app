import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/history.dart';
import 'package:mybt/models/point.dart';

final pointUseViewModel = Provider((ref) => _PointUseViewModel(ref));

class _PointUseViewModel {
  _PointUseViewModel(this._ref);

  final Ref _ref;

  void input(int newVal) {
    _ref.read(_uiStateProvider.notifier).inputPoint(newVal);
  }

  Future<void> execute() async {
    final value = _ref.read(pointUseInputStateProvider);
    await _ref.read(pointProvider.notifier).use(value);
    await _ref.read(historyProvider.notifier).saveUse(value);
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
final pointUseInputStateProvider = Provider<int>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.inputPoint));
});

// ユーザーが入力したポイント数が利用可能か
final pointUseOkInputPointStateProvider = StateProvider<bool>((ref) {
  final inputVal = ref.watch(pointUseInputStateProvider);
  final holdVal = ref.read(pointProvider).balance;
  return inputVal > 0 && inputVal <= holdVal;
});
