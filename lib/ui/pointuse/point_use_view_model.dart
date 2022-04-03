import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/point_repository.dart';
import 'package:mybt/ui/base_view_model.dart';

final pointUseViewModel = ChangeNotifierProvider.autoDispose((ref) => PointUseViewModel(ref.read));

// 現在保持しているポイント数
final pointUseHoldPointStateProvider = StateProvider((_) => 0);

// ユーザーが入力したポイント数
final pointUseInputStateProvider = StateProvider((_) => 0);

// ユーザーが入力したポイント数が利用可能か
final pointUseOkInputPointStateProvider = StateProvider<bool>((ref) {
  final inputVal = ref.watch(pointUseInputStateProvider);
  final holdVal = ref.watch(pointUseHoldPointStateProvider);
  return inputVal > 0 && inputVal <= holdVal;
});

class PointUseViewModel extends BaseViewModel {
  PointUseViewModel(this._read) {
    init();
  }

  final Reader _read;

  Future<void> init() async {
    try {
      final myPoint = await _read(pointRepositoryProvider).find();
      _read(pointUseHoldPointStateProvider.notifier).state = myPoint.balance;
      success();
    } on Exception catch (e, s) {
      error('エラー', exception: e, stackTrace: s);
    }
  }

  void input(int inputVal) {
    _read(pointUseInputStateProvider.notifier).state = inputVal;
  }

  Future<void> execute() async {
    final value = _read(pointUseInputStateProvider);
    await _read(pointRepositoryProvider).pointUse(value);
  }
}
