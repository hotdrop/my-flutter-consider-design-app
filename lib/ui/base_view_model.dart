import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mybt/common/app_logger.dart';

part 'base_view_model.freezed.dart';

class BaseViewModel extends ChangeNotifier {
  UIState state = OnLoading();

  void nowLoading() {
    state = OnLoading();
    notifyListeners();
  }

  void success() {
    state = OnSuccess();
    notifyListeners();
  }

  void error(String message, {Exception? exception, StackTrace? stackTrace}) {
    AppLogger.d('エラーメッセージ: $message, 例外情報: $exception, スタックトレース: $stackTrace');
    state = OnError(message);
    notifyListeners();
  }
}

@freezed
class UIState with _$UIState {
  const factory UIState.loading() = OnLoading;
  const factory UIState.success() = OnSuccess;
  const factory UIState.error(String message) = OnError;
}