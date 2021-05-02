import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/ui/home/home_page.dart';
import 'package:mybt/ui/start/start_view_model.dart';
import 'package:mybt/ui/widgets/app_dialog.dart';
import 'package:mybt/ui/widgets/progress_dialog.dart';

class StartPage extends StatelessWidget {
  StartPage._();

  static void start(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => StartPage._()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('はじめに'),
      ),
      body: _viewBody(context),
    );
  }

  Widget _viewBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 36),
      child: Column(
        children: [
          Text('ユーザー情報を登録します。嫌だったら入力せずに進んでください。'),
          SizedBox(height: 16),
          _textFieldNickName(context),
          SizedBox(height: 16),
          _textFieldEmail(context),
          SizedBox(height: 24),
          _buttonSave(context),
        ],
      ),
    );
  }

  Widget _textFieldNickName(BuildContext context) {
    final viewModel = context.read(startViewModelProvider);
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'ニックネーム（省略可能）',
        hintText: 'サイヤ人',
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      onChanged: (String value) {
        viewModel.inputNickName(value);
      },
    );
  }

  Widget _textFieldEmail(BuildContext context) {
    final viewModel = context.read(startViewModelProvider);
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'メールアドレス（省略可能）',
        hintText: 'migatteno_gokui@seven.universe.wis.jp',
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      onChanged: (String value) {
        viewModel.inputEmail(value);
      },
    );
  }

  Widget _buttonSave(BuildContext context) {
    final viewModel = context.read(startViewModelProvider);
    return ElevatedButton(
      onPressed: () async {
        final dialog = AppProgressDialog<void>();
        await dialog.show(
          context,
          execute: viewModel.save,
          onSuccess: (result) {
            AppLogger.d('成功したので次に進みます。');
            HomePage.start(context);
          },
          onError: (e, s) {
            AppLogger.d('エラーです。e:$e stackTrace:$s');
            final errorDialog = AppDialog('$e');
            errorDialog.show(context);
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
        child: Text('この内容で登録する'),
      ),
    );
  }
}
