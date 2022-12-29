import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/app_setting_repository.dart';

part 'start_view_model.g.dart';

@riverpod
class StartViewModel extends _$StartViewModel {
  @override
  void build() {
    // 初期化するものがあればここで行う
  }

  void inputNickName(String newVal) {
    final prevUiState = ref.read(_uiStateProvider);
    ref.read(_uiStateProvider.notifier).state = prevUiState.copyWith(nickName: newVal);
  }

  void inputEmail(String newVal) {
    final prevUiState = ref.read(_uiStateProvider);
    ref.read(_uiStateProvider.notifier).state = prevUiState.copyWith(email: newVal);
  }

  Future<void> save() async {
    final inputNickname = ref.read(_uiStateProvider).nickName;
    final inputEmail = ref.read(_uiStateProvider).email;
    await ref.read(appSettingRepositoryProvider).registerUser(inputNickname, inputEmail);
  }
}

final _uiStateProvider = StateProvider<_UiState>((ref) => _UiState.empty());

class _UiState {
  const _UiState(this.nickName, this.email);

  factory _UiState.empty() {
    return const _UiState('', '');
  }

  final String nickName;
  final String email;

  _UiState copyWith({String? nickName, String? email}) {
    return _UiState(
      nickName ?? this.nickName,
      email ?? this.email,
    );
  }
}

final startPageCanSaveProvider = Provider<bool>((ref) {
  final uiState = ref.watch(_uiStateProvider);
  return uiState.nickName.isNotEmpty && uiState.email.isNotEmpty;
});
