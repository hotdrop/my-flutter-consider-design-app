import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/point_repository.dart';
import 'package:mybt/res/R.dart';
import 'package:mybt/ui/base_view_model.dart';
import 'package:mybt/common/app_extension.dart';

final pointGetViewModel = ChangeNotifierProvider.autoDispose((ref) => PointGetViewModel(ref.read));

class PointGetViewModel extends BaseViewModel {
  PointGetViewModel(this._read) {
    init();
  }

  final Reader _read;

  late int _holdPoint;
  int get holdPoint => _holdPoint;

  int _inputPoint = 0;
  int get inputPoint => _inputPoint;

  late int _availableMaxGetPoint;

  Future<void> init() async {
    try {
      final myPoint = await _read(pointRepositoryProvider).find();
      _holdPoint = myPoint.balance;
      _availableMaxGetPoint = R.res.integers.maxPoint - myPoint.balance;
      success();
    } on Exception catch (e, s) {
      error('エラー', exception: e, stackTrace: s);
    }
  }

  void input(String inputVal, bool isValidate) {
    final inputPoint = int.tryParse(inputVal) ?? 0;
    if (isValidate) {
      _inputPoint = inputPoint;
    } else {
      _inputPoint = 0;
    }
    notifyListeners();
  }

  String? pointValidator(String? inputVal) {
    final inputPoint = int.tryParse(inputVal ?? '0') ?? 0;
    if (inputPoint <= 0) {
      return null;
    }

    if (inputPoint > _availableMaxGetPoint) {
      return '${R.res.strings.pointGetInputTextFieldErrorOverMaxPoint}'.embedded(<int>[_availableMaxGetPoint]);
    }

    return null;
  }

  Future<void> execute() async {
    await _read(pointRepositoryProvider).pointGet(_inputPoint);
  }
}
