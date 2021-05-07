import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:mybt/flavors.dart';
import 'package:mybt/res/R.dart';
import 'package:mybt/ui/start/splash_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ja', ''),
      ],
      navigatorObservers: [defaultLifecycleObserver],
      title: F.title,
      theme: R.res.theme,
      home: SplashPage(),
    );
  }
}
