import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/point_repository.dart';

final pointUseViewModel = StateNotifierProvider.autoDispose<_PointUseViewModel, AsyncValue<void>>((ref) {
  return _PointUseViewModel(ref.read);
});

class _PointUseViewModel extends StateNotifier<AsyncValue<void>> {
  _PointUseViewModel(this._read) : super(const AsyncValue.loading()) {
    _init();
  }

  final Reader _read;
  late int _holdPoint;
  int get holdPoint => _holdPoint;

  Future<void> _init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final myPoint = await _read(pointRepositoryProvider).find();
      _holdPoint = myPoint.balance;
    });
  }

  void input(int newVal) {
    _read(_uiStateProvider.notifier).inputPoint(newVal);
  }

  Future<void> execute() async {
    final value = _read(pointUseInputStateProvider);
    await _read(pointRepositoryProvider).pointUse(value);
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
  final holdVal = ref.read(pointUseViewModel.notifier).holdPoint;
  return inputVal > 0 && inputVal <= holdVal;
});
