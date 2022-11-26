import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/history.dart';

final homeViewModel = StateNotifierProvider.autoDispose<_HomeViewModel, AsyncValue<void>>((ref) {
  return _HomeViewModel(ref);
});

class _HomeViewModel extends StateNotifier<AsyncValue<void>> {
  _HomeViewModel(this._ref) : super(const AsyncValue.loading()) {
    _init();
  }

  final Ref _ref;

  Future<void> _init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _ref.read(historyProvider.notifier).refresh();
    });
  }
}
