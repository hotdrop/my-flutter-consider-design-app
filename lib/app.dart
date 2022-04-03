import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:mybt/flavors.dart';
import 'package:mybt/res/res.dart';
import 'package:mybt/ui/start/splash_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja', ''),
      ],
      navigatorObservers: [defaultLifecycleObserver],
      title: F.title,
      theme: R.res.theme,
      home: const SplashPage(),
    );
  }
}
