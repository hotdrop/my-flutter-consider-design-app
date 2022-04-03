import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/point_repository.dart';
import 'package:mybt/res/R.dart';
import 'package:mybt/ui/base_view_model.dart';

final pointGetViewModel = ChangeNotifierProvider.autoDispose((ref) => PointGetViewModel(ref.read));

// 現在保持しているポイント数
final pointGetHoldPointStateProvider = StateProvider((_) => 0);

// ユーザーが入力したポイント数
final pointGetInputStateProvider = StateProvider((_) => 0);

// 残り獲得可能なポイント数
final pointGetAvailableMaxValueStateProvider = StateProvider<int>((_) => 0);

// ユーザーが入力したポイント数が獲得可能か
// <pointGetAvailableMaxValueStateProviderをwatchしている理由>
// TextFormFieldのvalidateでも同じことをやっているので今のところただの二重チェック。
// ただ、今はたまたまチェック内容が同じだけでこのProviderと入力のvalidateは別物。もしTextFormFieldで別のvalidateをやったり新しい入力項目を追加した場合の
// 拡張性を考えてこの実装にした。
final pointGetOkInputPointStateProvider = StateProvider<bool>((ref) {
  final inputVal = ref.watch(pointGetInputStateProvider);
  final maxVal = ref.watch(pointGetAvailableMaxValueStateProvider);
  return inputVal > 0 && inputVal <= maxVal;
});

class PointGetViewModel extends BaseViewModel {
  PointGetViewModel(this._read) {
    init();
  }

  final Reader _read;

  Future<void> init() async {
    try {
      final myPoint = await _read(pointRepositoryProvider).find();
      _read(pointGetHoldPointStateProvider.notifier).state = myPoint.balance;
      _read(pointGetAvailableMaxValueStateProvider.notifier).state = R.res.integers.maxPoint - myPoint.balance;
      success();
    } on Exception catch (e, s) {
      error('エラー', exception: e, stackTrace: s);
    }
  }

  void input(int inputVal) {
    _read(pointGetInputStateProvider.notifier).state = inputVal;
  }

  Future<void> execute() async {
    final value = _read(pointGetInputStateProvider);
    await _read(pointRepositoryProvider).pointGet(value);
  }
}
