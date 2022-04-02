import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/res/R.dart';
import 'package:mybt/ui/home/home_page.dart';
import 'package:mybt/ui/start/start_view_model.dart';
import 'package:mybt/ui/widgets/app_dialog.dart';
import 'package:mybt/ui/widgets/progress_dialog.dart';

class StartPage extends ConsumerWidget {
  StartPage._();

  static void start(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => StartPage._()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(startViewModel).uiState;
    return Scaffold(
      appBar: AppBar(
        title: Text(R.res.strings.startTitle),
      ),
      body: uiState.when(
        loading: () => _onLoading(),
        success: () => _onSuccess(context, ref),
        error: (String errorMsg) => _onError(errorMsg),
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

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 36),
      child: Column(
        children: [
          Text(R.res.strings.startOverview),
          const SizedBox(height: 16),
          _textFieldNickName(ref),
          const SizedBox(height: 16),
          _textFieldEmail(ref),
          const SizedBox(height: 24),
          _buttonSave(context, ref),
        ],
      ),
    );
  }

  Widget _textFieldNickName(WidgetRef ref) {
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
        ref.read(startViewModel).inputNickName(value);
      },
    );
  }

  Widget _textFieldEmail(WidgetRef ref) {
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
        ref.read(startViewModel).inputEmail(value);
      },
    );
  }

  Widget _buttonSave(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final viewModel = ref.read(startViewModel);
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
