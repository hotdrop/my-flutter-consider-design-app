import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mybt/models/app_settings.dart';
import 'package:mybt/models/point.dart';

final homeViewModel = ChangeNotifierProvider.autoDispose((ref) {
  return HomeViewModel(ref.read);
});

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this._read);

  static final dateFormatter = DateFormat('y/M/d H:m:s');

  final Reader _read;
  String _nowDateTimeStr = dateFormatter.format(DateTime.now());
  String get nowDateTimeStr => _nowDateTimeStr;

  Future<void> onRefresh() async {
    _read(pointProvider.notifier).find();
    _read(appSettingsProvider.notifier).refresh();
    _nowDateTimeStr = dateFormatter.format(DateTime.now());
    notifyListeners();
  }
}
