import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/res/R.dart';
import 'package:mybt/ui/pointget/point_get_confirm_page.dart';
import 'package:mybt/ui/pointget/point_get_view_model.dart';
import 'package:mybt/ui/widgets/app_dialog.dart';
import 'package:mybt/common/app_extension.dart';
import 'package:mybt/ui/widgets/app_text.dart';

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
          final uiState = watch(pointGetViewModel).state;
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
    final maxHoldPoint = R.res.integers.maxPoint;
    final holdPoint = context.read(pointGetViewModel).holdPoint!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        children: [
          AppText.normal('${R.res.strings.pointGetInputOverview}'),
          AppText.large('$holdPoint'),
          SizedBox(height: 4),
          Text(
            '${R.res.strings.pointGetInputAttension}'.embedded(<int>[maxHoldPoint]),
            style: Theme.of(context).textTheme.caption,
          ),
          SizedBox(height: 16),
          _textFieldPoint(context, maxHoldPoint - holdPoint),
          _textFieldPointError(context),
          SizedBox(height: 16),
          _buttonNext(context),
        ],
      ),
    );
  }

  Widget _textFieldPoint(BuildContext context, int availableGetPoint) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: R.res.strings.pointGetInputTextFieldHint,
        ),
        style: TextStyle(fontSize: 32),
        maxLength: 4,
        onChanged: (String inputVal) {
          context.read(pointGetViewModel).input(inputVal, availableGetPoint);
        },
      ),
    );
  }

  Widget _textFieldPointError(BuildContext context) {
    final errorLabel = context.read(pointGetViewModel).pointFieldErrorMessage;
    if (errorLabel != null) {
      return Text(errorLabel, style: TextStyle(color: Colors.red));
    } else {
      return SizedBox(height: 16);
    }
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
