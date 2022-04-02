import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/app_setting.dart';
import 'package:mybt/res/R.dart';
import 'package:mybt/ui/home/home_page.dart';
import 'package:mybt/ui/start/splash_view_model.dart';
import 'package:mybt/ui/start/start_page.dart';
import 'package:mybt/ui/widgets/app_dialog.dart';
import 'package:mybt/ui/widgets/app_text.dart';

class SplashPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(splashViewModel);
    final uiState = viewModel.uiState;
    return Scaffold(
      appBar: AppBar(title: Text(R.res.strings.splashTitle)),
      body: uiState.when(
        loading: () => _onLoading(context, userId: viewModel.userId),
        success: () => _onSuccess(context, appSetting: viewModel.appSetting),
        error: (String errorMsg) => _onError(context, errorMsg),
      ),
    );
  }

  Widget _onLoading(BuildContext context, {String? userId}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 36),
      child: Column(
        children: [
          Image.asset(R.res.images.startImage),
          const SizedBox(height: 16),
          const CircularProgressIndicator(),
          SizedBox(height: 24),
          if (userId != null) Text('${R.res.strings.splashUserIDLabel}$userId'),
        ],
      ),
    );
  }

  Widget _onSuccess(BuildContext context, {AppSetting? appSetting}) {
    // アプリ設定がない場合は初回起動画面を表示
    if (appSetting == null) {
      return _viewFirstStart(context);
    }

    Future<void>.delayed(Duration.zero).then((_) => HomePage.start(context));
    return _onLoading(context, userId: appSetting.userId);
  }

  Widget _onError(BuildContext context, String errorMsg) {
    Future<void>.delayed(Duration.zero).then((value) {
      AppDialog(
        errorMsg,
        onOk: () {
          // iOSはアプリを落とせないので何もしない
          // 初回でコケた場合、どうするのが正解なのだろうか・・
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          }
        },
      ).show(context);
    });
    return Center(
      child: Text(R.res.strings.splashErrorLabel),
    );
  }

  Widget _viewFirstStart(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 36),
      child: Column(
        children: [
          Image.asset(R.res.images.startImage),
          const SizedBox(height: 16),
          AppText.large(R.res.strings.splashOverview),
          Expanded(
            child: Align(
              alignment: FractionalOffset.center,
              child: _buttonStart(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonStart(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        StartPage.start(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
        child: Text(R.res.strings.splashFirstTimeButton),
      ),
    );
  }
}
