import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/res/R.dart';
import 'package:mybt/ui/pointuse/point_use_view_model.dart';
import 'package:mybt/ui/widgets/app_dialog.dart';
import 'package:mybt/ui/widgets/app_text.dart';
import 'package:mybt/ui/widgets/progress_dialog.dart';

class PointUseConfirmPage extends StatelessWidget {
  PointUseConfirmPage._();

  static void start(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => PointUseConfirmPage._()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.res.strings.pointUseTitle)),
      body: _viewBody(context),
    );
  }

  Widget _viewBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        children: [
          Center(child: Text(R.res.strings.pointUseConfirmOverview)),
          Center(child: Text(R.res.strings.pointUseConfirmDetail)),
          const SizedBox(height: 24),
          AppText.large(R.res.strings.pointUseConfirmPointLabel),
          _textGetPoint(context),
          const SizedBox(height: 24),
          _buttonDecision(context),
        ],
      ),
    );
  }

  Widget _textGetPoint(BuildContext context) {
    final usePoint = context.read(pointUseViewModel).usePoint;
    return Text(
      '$usePoint',
      style: TextStyle(fontSize: 32, color: R.res.colors.accentColor),
    );
  }

  Widget _buttonDecision(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final viewModel = context.read(pointUseViewModel);
        final dialog = AppProgressDialog<void>();
        await dialog.show(
          context,
          execute: viewModel.execute,
          onSuccess: (result) {
            AppLogger.d('ポイント利用に成功しました！');
            Navigator.popUntil(context, (route) => route.isFirst);
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
        child: Text(R.res.strings.pointUseConfirmExecuteButton),
      ),
    );
  }
}
