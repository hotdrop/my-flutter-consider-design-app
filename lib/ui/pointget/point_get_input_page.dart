import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/res/R.dart';
import 'package:mybt/ui/pointget/point_get_confirm_page.dart';
import 'package:mybt/ui/pointget/point_get_view_model.dart';
import 'package:mybt/ui/widgets/app_dialog.dart';
import 'package:mybt/common/app_extension.dart';
import 'package:mybt/ui/widgets/app_text.dart';
import 'package:mybt/ui/widgets/app_text_form_field.dart';

class PointGetInputPage extends StatelessWidget {
  static void start(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (context) => PointGetInputPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.res.strings.pointGetTitle)),
      body: Consumer(
        builder: (context, watch, child) {
          final uiState = watch(pointGetViewModel).uiState;
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
      child: Text(R.res.strings.pointGetInputError),
    );
  }

  Widget _onSuccess(BuildContext context) {
    final holdPoint = context.read(pointGetViewModel).holdPoint;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        children: [
          AppText.normal('${R.res.strings.pointGetInputOverview}'),
          AppText.large('$holdPoint'),
          SizedBox(height: 4),
          Text(
            '${R.res.strings.pointGetInputAttension}'.embedded(<int>[R.res.integers.maxPoint]),
            style: Theme.of(context).textTheme.caption,
          ),
          SizedBox(height: 16),
          _textFieldPoint(context),
          SizedBox(height: 16),
          _buttonNext(context),
        ],
      ),
    );
  }

  Widget _textFieldPoint(BuildContext context) {
    final viewModel = context.read(pointGetViewModel);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: AppTextFormField(
          keyboardType: TextInputType.number,
          label: R.res.strings.pointGetInputTextFieldHint,
          textSize: 24,
          maxLength: 4,
          validator: (String? v) => viewModel.pointValidator(v),
          onChanged: (String v, bool isValidate) => viewModel.input(v, isValidate)),
    );
  }

  Widget _buttonNext(BuildContext context) {
    final inputPoint = context.read(pointGetViewModel).inputPoint;
    return ElevatedButton(
      onPressed: (inputPoint > 0)
          ? () {
              PointGetConfirmPage.start(context);
            }
          : null,
      child: Text(R.res.strings.pointGetInputConfirmButton),
    );
  }
}
