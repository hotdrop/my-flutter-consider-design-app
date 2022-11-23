import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/app_setting_repository.dart';

final startViewModel = StateNotifierProvider.autoDispose<_StartViewModel, AsyncValue<void>>((ref) {
  return _StartViewModel(ref);
});

class _StartViewModel extends StateNotifier<AsyncValue<void>> {
  _StartViewModel(this._ref) : super(const AsyncValue.loading()) {
    _init();
  }

  final Ref _ref;

  Future<void> _init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // 何か初期化あればここで行う
    });
  }

  void inputNickName(String newVal) {
    _ref.read(_uiStateProvider.notifier).inputNickName(newVal);
  }

  void inputEmail(String newVal) {
    _ref.read(_uiStateProvider.notifier).inputEmail(newVal);
  }

  Future<void> save() async {
    final inputNickname = _ref.read(_uiStateProvider).nickName;
    final inputEmail = _ref.read(_uiStateProvider).email;
    await _ref.read(appSettingRepositoryProvider).registerUser(inputNickname, inputEmail);
  }
}

final _uiStateProvider = StateNotifierProvider<_UiStateNotifier, _UiState>((_) {
  return _UiStateNotifier(_UiState.empty());
});

class _UiStateNotifier extends StateNotifier<_UiState> {
  _UiStateNotifier(_UiState state) : super(state);

  void inputNickName(String newVal) {
    state = state.copyWith(nickName: newVal);
  }

  void inputEmail(String newVal) {
    state = state.copyWith(email: newVal);
  }
}

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

final startPageInputNickNameProvider = Provider<String>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.nickName));
});

final startPageInputEmailProvider = Provider<String>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.email));
});

final startPageCanSaveProvider = Provider<bool>((ref) {
  final uiState = ref.watch(_uiStateProvider);
  return uiState.nickName.isNotEmpty && uiState.email.isNotEmpty;
});
