import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/res/R.dart';
import 'package:mybt/ui/pointuse/point_use_confirm_page.dart';
import 'package:mybt/ui/pointuse/point_use_view_model.dart';
import 'package:mybt/ui/widgets/app_dialog.dart';
import 'package:mybt/ui/widgets/app_text.dart';
import 'package:mybt/ui/widgets/app_text_form_field.dart';

class PointUseInputPage extends StatelessWidget {
  static void start(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (context) => PointUseInputPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.res.strings.pointUseTitle)),
      body: Consumer(
        builder: (context, watch, child) {
          final uiState = watch(pointUseViewModel).uiState;
          return uiState.when(
            loading: () => _onLoading(),
            success: () => _onSuccess(context),
            error: (String errorMsg) => _onError(context, errorMsg),
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
  /// TODO とりあえずポイント獲得と同じUIにしているがアイテムを選んで購入するというUIにしたい
  /// そうすると購入アイテム一蘭も必要になって来るのでまた別途検討する
  ///
  Widget _onSuccess(BuildContext context) {
    final holdPoint = context.read(pointUseViewModel).holdPoint;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Center(
        child: Column(
          children: [
            AppText.normal('${R.res.strings.pointUseInputOverview}'),
            AppText.large('$holdPoint'),
            SizedBox(height: 16),
            _textFieldPoint(context),
            SizedBox(height: 16),
            _buttonNext(context),
          ],
        ),
      ),
    );
  }

  Widget _textFieldPoint(BuildContext context) {
    final viewModel = context.read(pointUseViewModel);
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

  Widget _buttonNext(BuildContext context) {
    final usePoint = context.read(pointUseViewModel).usePoint;
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
