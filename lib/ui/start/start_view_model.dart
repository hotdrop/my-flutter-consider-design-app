import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/repository/settings_repository.dart';

final startViewModel = ChangeNotifierProvider.autoDispose((ref) {
  return StartViewModel(
    ref.read(SettingsRepositoryProvider),
  );
});

class StartViewModel extends ChangeNotifier {
  StartViewModel(this._repository);

  final SettingsRepository _repository;

  String? _inputNickName;
  String? _inputEmail;

  void inputNickName(String input) {
    _inputNickName = input;
  }

  void inputEmail(String input) {
    _inputEmail = input;
  }

  Future<void> save() async {
    await _repository.registerUser(_inputNickName, _inputEmail);
  }
}
