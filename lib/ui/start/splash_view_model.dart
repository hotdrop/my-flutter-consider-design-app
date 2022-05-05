import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/models/app_setting.dart';
import 'package:mybt/repository/local/local_data_source.dart';

final splashViewModel = StateNotifierProvider.autoDispose<_SplashViewModel, AsyncValue<void>>((ref) {
  return _SplashViewModel(ref.read);
});

class _SplashViewModel extends StateNotifier<AsyncValue<void>> {
  _SplashViewModel(this._read) : super(const AsyncValue.loading()) {
    _init();
  }

  final Reader _read;

  Future<void> _init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard((() async {
      AppLogger.d('アプリの初期処理を実行します。');
      await _read(localDataSourceProvider).init();
      await _read(appSettingProvider.notifier).refresh();
      // 起動処理が一瞬で終わってしまうので、もう少し重い処理がある想定で1秒ディレイしている
      await Future<void>.delayed(const Duration(seconds: 1));
      AppLogger.d('アプリの初期処理が完了しました。');
    }));
  }
}
