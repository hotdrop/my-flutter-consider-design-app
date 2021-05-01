import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/app_settings.dart';
import 'package:mybt/res/R.dart';
import 'package:mybt/ui/start/start_page.dart';
import 'package:mybt/ui/widgets/app_text.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('起動')),
      body: Consumer(
        builder: (context, watch, child) {
          final onInit = watch(appSettingsProvider.notifier).init();
          return FutureBuilder(
            future: onInit,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final state = watch(appSettingsProvider);
                return _onLoaded(context, state);
              } else {
                return _onLoading(context);
              }
            },
          );
        },
      ),
    );
  }

  Widget _onLoading(BuildContext context, {String? accountNo}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 36),
      child: Column(
        children: [
          Image.asset(R.res.images.startImage),
          const SizedBox(height: 16),
          const CircularProgressIndicator(),
          if (accountNo != null) Text('アカウントNo: $accountNo'),
        ],
      ),
    );
  }

  Widget _onLoaded(BuildContext context, AppSetting appSetting) {
    if (appSetting.accountNo != null) {
      // TODO ここでさらにデータをロードしてトップ画面へ
      return _onLoading(context, accountNo: appSetting.accountNo);
    } else {
      return _viewFirstStart(context);
    }
  }

  Widget _viewFirstStart(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 36),
      child: Column(
        children: [
          Image.asset(R.res.images.startImage),
          SizedBox(height: 16),
          AppText.large('コーヒータイプのアプリです。'),
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
        child: Text('はじめる'),
      ),
    );
  }
}
