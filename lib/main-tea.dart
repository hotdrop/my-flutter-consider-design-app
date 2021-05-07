import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/res/R.dart';
import 'app.dart';

void main() {
  R.initTea();
  runApp(ProviderScope(child: MyApp()));
}
