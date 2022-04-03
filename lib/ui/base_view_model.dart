import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mybt/common/app_logger.dart';

part 'base_view_model.freezed.dart';

class BaseViewModel extends ChangeNotifier {
  UIState _uiState = const OnLoading();
  UIState get uiState => _uiState;

  void nowLoading() {
    _uiState = const OnLoading();
    notifyListeners();
  }

  void success() {
    _uiState = const OnSuccess();
    notifyListeners();
  }

  void error(String message, {Exception? exception, StackTrace? stackTrace}) {
    AppLogger.d('エラーメッセージ: $message, 例外情報: $exception, スタックトレース: $stackTrace');
    _uiState = OnError(message);
    notifyListeners();
  }
}

@freezed
class UIState with _$UIState {
  const factory UIState.loading() = OnLoading;
  const factory UIState.success() = OnSuccess;
  const factory UIState.error(String message) = OnError;
}
