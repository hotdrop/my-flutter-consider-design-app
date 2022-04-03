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
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(splashViewModel).uiState;

    return Scaffold(
      appBar: AppBar(title: Text(R.res.strings.splashTitle)),
      body: uiState.when(
        loading: () => const _ViewLoadingPage(),
        success: () => _onSuccess(context, ref),
        error: (String errorMsg) => _onError(context, errorMsg),
      ),
    );
  }

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    final isInitialized = ref.read(appSettingProvider).isInitialized();
    if (isInitialized) {
      Future<void>.delayed(Duration.zero).then((_) {
        HomePage.start(context);
      });
      return const _ViewLoadingPage();
    } else {
      return const _ViewFirstPage();
    }
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
}

class _ViewLoadingPage extends ConsumerWidget {
  const _ViewLoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(appSettingProvider).userId;

    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 36),
      child: Column(
        children: [
          Image.asset(R.res.images.startImage),
          const SizedBox(height: 16),
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          if (userId != null) Text('${R.res.strings.splashUserIDLabel}$userId'),
        ],
      ),
    );
  }
}

class _ViewFirstPage extends StatelessWidget {
  const _ViewFirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 36),
      child: Column(
        children: [
          Image.asset(R.res.images.startImage),
          const SizedBox(height: 16),
          AppText.large(R.res.strings.splashOverview),
          const Expanded(
            child: Align(
              alignment: FractionalOffset.center,
              child: _ViewButtonStart(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewButtonStart extends StatelessWidget {
  const _ViewButtonStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => StartPage.start(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
        child: Text(R.res.strings.splashFirstTimeButton),
      ),
    );
  }
}
