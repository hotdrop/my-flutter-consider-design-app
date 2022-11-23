import 'package:mybt/repository/app_setting_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final appSettingProvider = NotifierProvider<AppSettingNotifier, AppSetting>(AppSettingNotifier.new);

class AppSettingNotifier extends Notifier<AppSetting> {
  @override
  AppSetting build() {
    return AppSetting();
  }

  Future<void> save(String? nickname, String? email) async {
    await ref.read(appSettingRepositoryProvider).registerUser(nickname, email);
    state = await ref.read(appSettingRepositoryProvider).find();
  }

  Future<void> load() async {
    state = await ref.read(appSettingRepositoryProvider).find();
  }
}

class AppSetting {
  AppSetting({this.userId, this.nickName, this.email});

  final String? userId;
  final String? nickName;
  final String? email;

  bool isInitialized() {
    return userId != null;
  }
}
