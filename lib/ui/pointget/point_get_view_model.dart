import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/point_repository.dart';
import 'package:mybt/res/res.dart';

final pointGetViewModel = StateNotifierProvider.autoDispose<_PointGetViewModel, AsyncValue<void>>((ref) {
  return _PointGetViewModel(ref.read);
});

class _PointGetViewModel extends StateNotifier<AsyncValue<void>> {
  _PointGetViewModel(this._read) : super(const AsyncValue.loading()) {
    _init();
  }

  final Reader _read;
  late int _holdPoint;
  int get holdPoint => _holdPoint;

  late int _maxAvaiableGetPoint;
  int get maxAvaiableGetPoint => _maxAvaiableGetPoint;

  Future<void> _init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final myPoint = await _read(pointRepositoryProvider).find();
      _holdPoint = myPoint.balance;
      _maxAvaiableGetPoint = R.res.integers.maxPoint - myPoint.balance;
    });
  }

  void input(int newVal) {
    _read(_uiStateProvider.notifier).inputPoint(newVal);
  }

  Future<void> pointGet() async {
    final value = _read(_uiStateProvider).inputPoint;
    await _read(pointRepositoryProvider).pointGet(value);
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
  final inputVal = ref.watch(pointGetInputStateProvider);
  final maxVal = ref.read(pointGetViewModel.notifier).maxAvaiableGetPoint;
  return inputVal > 0 && inputVal <= maxVal;
});
