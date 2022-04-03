import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/models/app_setting.dart';
import 'package:mybt/repository/local/local_data_source.dart';
import 'package:mybt/ui/base_view_model.dart';

final splashViewModel = ChangeNotifierProvider.autoDispose((ref) => SplashViewModel(ref.read));

class SplashViewModel extends BaseViewModel {
  SplashViewModel(this._read) {
    _init();
  }

  final Reader _read;

  Future<void> _init() async {
    AppLogger.d('アプリの初期処理を実行します。');

    await _read(localDataSourceProvider).init();
    await _read(appSettingProvider.notifier).refresh();

    // 起動処理が一瞬で終わってしまうので、もう少し重い処理がある想定で1秒ディレイしている
    await Future<void>.delayed(const Duration(seconds: 1));

    // ver1の時はホーム画面表示時に必要なデータの取得処理をここに入れていたが、その画面が必要なデータはその画面のVMで取るべきなので消した。
    AppLogger.d('アプリの初期処理が完了しました。');

    success();
  }
}
