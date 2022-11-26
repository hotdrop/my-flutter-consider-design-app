import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/app_setting.dart';
import 'package:mybt/res/res.dart';
import 'package:mybt/ui/home/home_page.dart';
import 'package:mybt/ui/start/splash_view_model.dart';
import 'package:mybt/ui/start/start_page.dart';
import 'package:mybt/ui/widgets/app_dialog.dart';
import 'package:mybt/ui/widgets/app_text.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.res.strings.splashTitle),
      ),
      body: ref.watch(splashViewModelProvider).when(
            data: (_) => const _ViewOnSuccess(),
            error: (err, _) => _ViewOnError('$err'),
            loading: () => const _ViewLoadingPage(),
          ),
    );
  }
}

class _ViewOnError extends StatelessWidget {
  const _ViewOnError(this.errorMsg);

  final String errorMsg;

  @override
  Widget build(BuildContext context) {
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

class _ViewOnSuccess extends ConsumerWidget {
  const _ViewOnSuccess();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInitialized = ref.watch(appSettingProvider).isInitialized();

    if (isInitialized) {
      // 初期化に少し時間がかる想定
      Future<void>.delayed(const Duration(seconds: 1)).then((_) {
        HomePage.start(context);
      });
      return const _ViewLoadingPage();
    } else {
      return const _ViewFirstPage();
    }
  }
}

class _ViewLoadingPage extends ConsumerWidget {
  const _ViewLoadingPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(appSettingProvider).userId;

    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 36),
      child: Column(
        children: [
          Center(child: Image.asset(R.res.images.startImage)),
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
  const _ViewFirstPage();

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
  const _ViewButtonStart();

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
