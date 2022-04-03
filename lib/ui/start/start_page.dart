import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/res/res.dart';
import 'package:mybt/ui/home/home_page.dart';
import 'package:mybt/ui/start/start_view_model.dart';
import 'package:mybt/ui/widgets/app_dialog.dart';
import 'package:mybt/ui/widgets/progress_dialog.dart';

class StartPage extends ConsumerWidget {
  const StartPage._();

  static Future<void> start(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const StartPage._()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(startViewModel).uiState;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(R.res.strings.startTitle),
        ),
        body: uiState.when(
          loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          success: () {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 36),
                child: Column(
                  children: [
                    Text(R.res.strings.startOverview),
                    const SizedBox(height: 16),
                    const _ViewTextFieldNickName(),
                    const SizedBox(height: 24),
                    const _ViewTextFieldEmail(),
                    const SizedBox(height: 24),
                    const _ViewSaveButton(),
                  ],
                ),
              ),
            );
          },
          error: (_) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class _ViewTextFieldNickName extends ConsumerWidget {
  const _ViewTextFieldNickName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: R.res.strings.startNickNameFieldLabel,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      // YouTubeのFlutterチャンネルでティアオフの動画を見て使ってみている
      onChanged: ref.read(startViewModel).inputNickName,
    );
  }
}

class _ViewTextFieldEmail extends ConsumerWidget {
  const _ViewTextFieldEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: R.res.strings.startEmailFieldLabel,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: _validate,
      onChanged: (String? newVal) {
        if (newVal != null && _validate(newVal) == null) {
          ref.read(startViewModel).inputEmail(newVal);
        }
      },
    );
  }

  String? _validate(String? v) {
    if (v == null) {
      return null;
    }
    if (!RegExp(R.res.strings.emailValidationRegex).hasMatch(v)) {
      return R.res.strings.emailValidationError;
    }
    return null;
  }
}

class _ViewSaveButton extends ConsumerWidget {
  const _ViewSaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enableButton = ref.watch(startPageCanSaveStateProvider);

    return ElevatedButton(
      onPressed: enableButton
          ? () async {
              const dialog = AppProgressDialog<void>();
              await dialog.show(
                context,
                execute: ref.read(startViewModel).save,
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
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
        child: Text(R.res.strings.startRegisterButton),
      ),
    );
  }
}
