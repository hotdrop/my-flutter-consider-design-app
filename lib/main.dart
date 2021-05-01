import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/app.dart';
import 'package:mybt/res/R.dart';

void main() {
  R.initAppCoffee();
  runApp(ProviderScope(child: MyApp()));
}
