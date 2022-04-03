import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/res/res.dart';
import 'app.dart';

void main() {
  R.initCoffee();
  runApp(const ProviderScope(child: MyApp()));
}
