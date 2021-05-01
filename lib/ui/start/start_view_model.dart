import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/role.dart';
import 'package:mybt/repository/settings_repository.dart';

final startViewModelProvider = ChangeNotifierProvider.autoDispose((ref) {
  return StartViewModel(
    ref.read(SettingsRepositoryProvider),
  );
});

class StartViewModel extends ChangeNotifier {
  StartViewModel(this._repository);

  final SettingsRepository _repository;

  String? _inputNickName;
  RoleType? _selectRoleType;
  RoleType get selectRoleType => _selectRoleType ?? RoleType.normal;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void inputNickName(String input) {
    _inputNickName = input;
  }

  void selectRole(RoleType type) {
    _selectRoleType = type;
    notifyListeners();
  }

  Future<void> save() async {
    await _repository.registerUser(_inputNickName, selectRoleType);
  }
}
