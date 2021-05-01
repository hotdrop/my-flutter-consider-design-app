import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/models/role.dart';
import 'package:mybt/ui/home/home_page.dart';
import 'package:mybt/ui/start/splash_page.dart';
import 'package:mybt/ui/start/start_view_model.dart';
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
        title: Text('はじめる'),
      ),
      body: _viewBody(context),
    );
  }

  Widget _viewBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 36),
      child: Column(
        children: [
          Text('初期情報を登録します。省略も可能です。'),
          SizedBox(height: 16),
          _textFieldNickName(context),
          _radioGroupRole(context),
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
        labelText: 'ニックネーム',
        hintText: '省略も可能',
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      onChanged: (String value) {
        viewModel.inputNickName(value);
      },
    );
  }

  Widget _radioGroupRole(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: RoleType.values.map((type) => _makeRadio(context, type)).toList(),
    );
  }

  Widget _makeRadio(BuildContext context, RoleType type) {
    final label = (type == RoleType.normal) ? '通常' : 'リーダー';
    return Consumer(builder: (context, watch, child) {
      final viewModel = watch(startViewModelProvider);
      return Row(
        children: [
          Radio<RoleType>(
            value: type,
            groupValue: viewModel.selectRoleType,
            onChanged: (RoleType? type) {
              if (type != null) {
                viewModel.selectRole(type);
              }
            },
          ),
          Text(label),
        ],
      );
    });
  }

  Widget _buttonSave(BuildContext context) {
    final viewModel = context.read(startViewModelProvider);
    return ElevatedButton(
      onPressed: () async {
        final progressDialog = AppProgressDialog(execute: viewModel.save);
        final result = await progressDialog.show(context);
        if (result) {
          AppLogger.d('成功したので次に進みます。');
          HomePage.start(context);
        } else {
          AppLogger.d('エラーですよ・・ ${viewModel.errorMessage}');
          // TODO 本当はここでなんか出したい
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
        child: Text('この内容で登録する'),
      ),
    );
  }
}
