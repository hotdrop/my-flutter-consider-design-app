import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/point_repository.dart';
import 'package:mybt/res/R.dart';
import 'package:mybt/ui/base_view_model.dart';

final pointUseViewModel = ChangeNotifierProvider.autoDispose((ref) => PointUseViewModel(ref.read));

class PointUseViewModel extends BaseViewModel {
  PointUseViewModel(this._read) {
    init();
  }

  final Reader _read;

  late int _holdPoint;
  int get holdPoint => _holdPoint;

  int _usePoint = 0;
  int get usePoint => _usePoint;

  Future<void> init() async {
    try {
      final myPoint = await _read(pointRepositoryProvider).find();
      _holdPoint = myPoint.balance;
      success();
    } on Exception catch (e, s) {
      error('エラー', exception: e, stackTrace: s);
    }
  }

  void input(String inputVal, bool isValidate) {
    final inputPoint = int.tryParse(inputVal) ?? 0;
    if (isValidate) {
      _usePoint = inputPoint;
    } else {
      _usePoint = 0;
    }
    notifyListeners();
  }

  String? pointValidator(String? inputVal) {
    final inputPoint = int.tryParse(inputVal ?? '0') ?? 0;
    if (inputPoint <= 0) {
      return null;
    }

    if (inputPoint > _holdPoint) {
      return '${R.res.strings.pointUseInputTextFieldErrorOverPoint}';
    }

    return null;
  }

  Future<void> execute() async {
    await _read(pointRepositoryProvider).pointUse(_usePoint);
  }
}
