import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/ui/base_view_model.dart';

final pointGetViewModel = ChangeNotifierProvider.autoDispose((ref) {
  return PointGetViewModel(ref.read);
});

class PointGetViewModel extends BaseViewModel {
  PointGetViewModel(this._read);

  final Reader _read;

  int _inpuPoint = 0;

  void input(int input) {
    _inpuPoint = input;
  }

  Future<void> execute() async {
    // TODO
  }
}
