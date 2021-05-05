import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/point_repository.dart';
import 'package:mybt/ui/base_view_model.dart';

final pointGetViewModel = ChangeNotifierProvider.autoDispose((ref) => PointGetViewModel(ref.read));

class PointGetViewModel extends BaseViewModel {
  PointGetViewModel(this._read) {
    init();
  }

  final Reader _read;

  int? _holdPoint;
  int? get holdPoint => _holdPoint;

  int _inputPoint = 0;
  int get inputPoint => _inputPoint;

  String? _pointFieldErrorMessage;
  String? get pointFieldErrorMessage => _pointFieldErrorMessage;

  Future<void> init() async {
    try {
      final repository = _read(pointRepositoryProvider);
      final myPoint = await repository.find();
      _holdPoint = myPoint.balance;
      success();
    } on Exception catch (e, s) {
      error('エラー', exception: e, stackTrace: s);
    }
  }

  void input(String inputStr, int maxPoint) {
    int inputPoint = int.tryParse(inputStr) ?? 0;
    if (_pointValidator(inputPoint, maxPoint)) {
      _inputPoint = inputPoint;
    } else {
      _inputPoint = 0;
    }
    notifyListeners();
  }

  bool _pointValidator(int inputVal, int maxPoint) {
    if (inputVal <= 0) {
      // 未入力の場合はエラーを出さない
      _pointFieldErrorMessage = null;
      return false;
    }

    if (inputVal > maxPoint) {
      _pointFieldErrorMessage = '獲得できる最大ポイントは$maxPointです。';
      return false;
    }

    _pointFieldErrorMessage = null;
    return true;
  }

  Future<void> execute() async {
    final repository = _read(pointRepositoryProvider);
    await repository.pointGet(_inputPoint);
  }
}
