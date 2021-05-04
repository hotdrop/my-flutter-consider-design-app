import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/setting_repository.dart';
import 'package:mybt/ui/base_view_model.dart';

final startViewModel = ChangeNotifierProvider.autoDispose((ref) => StartViewModel(ref.read));

class StartViewModel extends BaseViewModel {
  StartViewModel(this._read) {
    init();
  }

  final Reader _read;

  String? _inputNickName;
  String? _inputEmail;

  Future<void> init() async {
    // このViewModelは初期化が不要なので即successにする。
    // たとえ不要であっても全体の設計を合わせるためinitは必ず実装した方が良いかなと思ったのでこうした。
    success();
  }

  void inputNickName(String input) {
    _inputNickName = input;
  }

  void inputEmail(String input) {
    _inputEmail = input;
  }

  Future<void> save() async {
    final repository = _read(settingRepositoryProvider);
    await repository.registerUser(_inputNickName, _inputEmail);
  }
}
