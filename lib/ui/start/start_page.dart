import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/res/R.dart';
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
        title: Text(R.res.strings.startTitle),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final uiState = watch(startViewModel).uiState;
          return uiState.when(
            loading: () => _onLoading(),
            success: () => _onSuccess(context),
            error: (String errorMsg) => _onError(errorMsg),
          );
        },
      ),
    );
  }

  Widget _onLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _onError(String errorMsg) {
    // このエラーは発生しない
    return Center(
      child: Text(errorMsg),
    );
  }

  Widget _onSuccess(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 36),
      child: Column(
        children: [
          Text(R.res.strings.startOverview),
          const SizedBox(height: 16),
          _textFieldNickName(context),
          const SizedBox(height: 16),
          _textFieldEmail(context),
          const SizedBox(height: 24),
          _buttonSave(context),
        ],
      ),
    );
  }

  Widget _textFieldNickName(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: R.res.strings.startNickNameFieldLabel,
        hintText: R.res.strings.startNickNameFieldHint,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      onChanged: (String value) {
        context.read(startViewModel).inputNickName(value);
      },
    );
  }

  Widget _textFieldEmail(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: R.res.strings.startEmailFieldLabel,
        hintText: R.res.strings.startEmailFieldHint,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      onChanged: (String value) {
        context.read(startViewModel).inputEmail(value);
      },
    );
  }

  Widget _buttonSave(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final viewModel = context.read(startViewModel);
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
        child: Text(R.res.strings.startRegisterButton),
      ),
    );
  }
}
