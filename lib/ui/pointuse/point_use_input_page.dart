import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/res/R.dart';
import 'package:mybt/ui/pointuse/point_use_confirm_page.dart';
import 'package:mybt/ui/pointuse/point_use_view_model.dart';
import 'package:mybt/ui/widgets/app_dialog.dart';
import 'package:mybt/ui/widgets/app_text.dart';
import 'package:mybt/ui/widgets/app_text_form_field.dart';

class PointUseInputPage extends ConsumerWidget {
  PointUseInputPage._();

  static void start(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (context) => PointUseInputPage._()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(pointUseViewModel).uiState;

    return Scaffold(
      appBar: AppBar(title: Text(R.res.strings.pointUseTitle)),
      body: uiState.when(
        loading: () => _onLoading(),
        success: () => _onSuccess(context, ref),
        error: (String errorMsg) => _onError(context, errorMsg),
      ),
    );
  }

  Widget _onLoading() {
    return Center(
      child: const CircularProgressIndicator(),
    );
  }

  Widget _onError(BuildContext context, String errorMsg) {
    Future<void>.delayed(Duration.zero).then((value) {
      AppDialog(
        errorMsg,
        onOk: () {},
      ).show(context);
    });
    return Center(
      child: Text(R.res.strings.pointUseInputError),
    );
  }

  ///
  /// TODO ポイント利用のUI改善
  /// とりあえずポイント獲得と同じUIにしているがアイテムを選んで購入するというUIにしたい
  /// そうすると購入アイテム一蘭も必要になって来るのでまた別途検討する
  ///
  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    final holdPoint = ref.read(pointUseViewModel).holdPoint;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Center(
        child: Column(
          children: [
            AppText.normal('${R.res.strings.pointUseInputOverview}'),
            AppText.large('$holdPoint'),
            const SizedBox(height: 16),
            _textFieldPoint(ref),
            const SizedBox(height: 16),
            _buttonNext(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _textFieldPoint(WidgetRef ref) {
    final viewModel = ref.read(pointUseViewModel);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: AppTextFormField(
          keyboardType: TextInputType.number,
          label: R.res.strings.pointUseInputTextFieldHint,
          textSize: 24,
          maxLength: 4,
          validator: (String? v) => viewModel.pointValidator(v),
          onChanged: (String v, bool isValidate) => viewModel.input(v, isValidate)),
    );
  }

  Widget _buttonNext(BuildContext context, WidgetRef ref) {
    final usePoint = ref.read(pointUseViewModel).usePoint;
    return ElevatedButton(
      onPressed: (usePoint > 0)
          ? () {
              PointUseConfirmPage.start(context);
            }
          : null,
      child: Text(R.res.strings.pointUseInputConfirmButton),
    );
  }
}
