import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/models/app_setting.dart';
import 'package:mybt/repository/local/local_data_source.dart';
import 'package:mybt/ui/base_view_model.dart';

final splashViewModel = ChangeNotifierProvider.autoDispose((ref) => SplashViewModel(ref.read));

class SplashViewModel extends BaseViewModel {
  SplashViewModel(this._read) {
    init();
  }

  final Reader _read;

  // これはStateNotifierのメリットを消してしまっている気がする。
  // ただ、_onStartInitFinishedメソッドで値設定のタイミングを明示したかったのでこのようにした
  AppSetting? _appSetting;
  AppSetting? get appSetting => _appSetting;
  String? get userId => _appSetting?.userId;

  Future<void> init() async {
    await _initApp();

    if (_read(appSettingProvider).isInitialized()) {
      _onStartInitFinished();
    } else {
      _onStartNotYetInit();
    }
  }

  Future<void> _initApp() async {
    AppLogger.d('アプリの初期処理を実行します。');
    await _read(localDataSourceProvider).init();
    await _read(appSettingProvider.notifier).refresh();
    // もう少し重い処理がある想定で2秒ディレイ
    await Future<void>.delayed(Duration(seconds: 2));
    AppLogger.d('アプリの初期処理が完了しました。');
  }

  Future<void> _onStartInitFinished() async {
    AppLogger.d('初期処理が済んでいるので起動処理に入ります');
    try {
      // 画面にユーザーIDを表示するため一度更新する
      _appSetting = _read(appSettingProvider);
      notifyListeners();

      // ここでホーム画面の表示に必要な処理を行う。
      // 基本、ホーム画面に必要なデータはホーム画面のロード処理で行えば良いのでどうしても事前に必要な処理のみ行うのが望ましいと思う。
      // 一応何か処理をする前提で2秒程度delay入れる。
      await Future<void>.delayed(Duration(seconds: 2));
      success();
    } on Exception catch (e, s) {
      error('起動処理でエラーが発生しました。', exception: e, stackTrace: s);
    }
  }

  void _onStartNotYetInit() {
    AppLogger.d('初期処理がまだなのでこのまま完了扱いにします');
    success();
  }
}
