import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/point.dart';
import 'package:mybt/repository/point_repository.dart';
import 'package:mybt/ui/base_view_model.dart';

final pointGetViewModel = ChangeNotifierProvider.autoDispose((ref) => PointGetViewModel(ref.read));

class PointGetViewModel extends BaseViewModel {
  PointGetViewModel(this._read);

  final Reader _read;

  Point? _point;
  Point? get myPoint => _point;

  int _inpuPoint = 0;

  Future<void> init() async {
    try {
      final repository = _read(pointRepositoryProvider);
      _point = await repository.find();
    } on Exception catch (e, s) {
      error('エラー', exception: e, stackTrace: s);
    }
  }

  void input(int input) {
    _inpuPoint = input;
  }

  Future<void> execute() async {
    final repository = _read(pointRepositoryProvider);
    await repository.pointGet(_inpuPoint);
  }
}
