import 'package:flutter/material.dart';

///
/// 現在の画面の前面にプログレスインジケータを表示する
/// showメソッドの引数は、本当はコンストラクタでフィールドに設定しようと思ったが
/// 実装時すぐshowを呼ぶのを忘れるので今の実装にした。
///
class AppProgressDialog<T> {
  const AppProgressDialog();

  Future<void> show(
    BuildContext context, {
    required Future<T> Function() execute,
    required Function(T) onSuccess,
    required Function(Exception, StackTrace) onError,
  }) async {
    _showProgressDialog(context);
    try {
      final navigator = Navigator.of(context);
      final result = await execute();
      navigator.pop;
      onSuccess(result);
    } on Exception catch (e, s) {
      Navigator.pop(context);
      onError(e, s);
    }
  }

  Future<void> _showProgressDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
