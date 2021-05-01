import 'package:flutter/material.dart';

class AppProgressDialog {
  const AppProgressDialog({required this.execute});

  final Future<bool> Function() execute;

  Future<bool> show(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: const CircularProgressIndicator(),
          ),
        );
      },
    );
    final result = await execute();
    // 処理が完了したらダイアログは閉じる
    Navigator.pop(context);
    return result;
  }
}
