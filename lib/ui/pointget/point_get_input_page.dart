import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/res/R.dart';
import 'package:mybt/ui/pointget/point_get_confirm_page.dart';
import 'package:mybt/ui/pointget/point_get_view_model.dart';
import 'package:mybt/ui/widgets/app_dialog.dart';
import 'package:mybt/common/app_extension.dart';
import 'package:mybt/ui/widgets/app_text.dart';
import 'package:mybt/ui/widgets/app_text_form_field.dart';

class PointGetInputPage extends ConsumerWidget {
  PointGetInputPage._();

  static void start(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (context) => PointGetInputPage._()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(pointGetViewModel).uiState;

    return Scaffold(
      appBar: AppBar(title: Text(R.res.strings.pointGetTitle)),
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
      child: Text(R.res.strings.pointGetInputError),
    );
  }

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    final holdPoint = ref.read(pointGetViewModel).holdPoint;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        children: [
          AppText.normal('${R.res.strings.pointGetInputOverview}'),
          AppText.large('$holdPoint'),
          const SizedBox(height: 4),
          Text(
            '${R.res.strings.pointGetInputAttension}'.embedded(<int>[R.res.integers.maxPoint]),
            style: Theme.of(context).textTheme.caption,
          ),
          const SizedBox(height: 16),
          _textFieldPoint(ref),
          const SizedBox(height: 16),
          _buttonNext(context, ref),
        ],
      ),
    );
  }

  Widget _textFieldPoint(WidgetRef ref) {
    final viewModel = ref.read(pointGetViewModel);
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

  Widget _buttonNext(BuildContext context, WidgetRef ref) {
    final inputPoint = ref.read(pointGetViewModel).inputPoint;
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
