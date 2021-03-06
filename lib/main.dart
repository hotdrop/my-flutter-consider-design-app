import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/app.dart';
import 'package:mybt/res/res.dart';

void main() {
  R.initCoffee();
  runApp(const ProviderScope(child: MyApp()));
}
