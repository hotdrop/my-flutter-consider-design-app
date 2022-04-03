import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/setting_repository.dart';
import 'package:mybt/ui/base_view_model.dart';

final startViewModel = ChangeNotifierProvider.autoDispose((ref) => StartViewModel(ref.read));

final startPageInputNickNameStateProvider = StateProvider<String>((ref) => '');

final startPageInputEmailStateProvider = StateProvider<String>((ref) => '');

final startPageCanSaveStateProvider = StateProvider((ref) {
  final inputNickName = ref.watch(startPageInputNickNameStateProvider);
  final inputEmail = ref.watch(startPageInputEmailStateProvider);
  return inputNickName.isNotEmpty && inputEmail.isNotEmpty;
});

class StartViewModel extends BaseViewModel {
  StartViewModel(this._read) {
    init();
  }

  final Reader _read;

  Future<void> init() async {
    // このViewModelは初期化が不要なので即successにする。
    // たとえ不要であっても全体の設計を合わせるためinitは必ず実装した方が良いかなと思ったのでこうした。
    success();
  }

  void inputNickName(String input) {
    _read(startPageInputNickNameStateProvider.notifier).state = input;
  }

  void inputEmail(String input) {
    _read(startPageInputEmailStateProvider.notifier).state = input;
  }

  Future<void> save() async {
    final inputNickname = _read(startPageInputNickNameStateProvider);
    final inputEmail = _read(startPageInputEmailStateProvider);
    await _read(settingRepositoryProvider).registerUser(inputNickname, inputEmail);
  }
}
