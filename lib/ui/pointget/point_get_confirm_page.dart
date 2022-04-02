import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/res/R.dart';
import 'package:mybt/ui/pointget/point_get_view_model.dart';
import 'package:mybt/ui/widgets/app_dialog.dart';
import 'package:mybt/ui/widgets/app_text.dart';
import 'package:mybt/ui/widgets/progress_dialog.dart';

class PointGetConfirmPage extends ConsumerWidget {
  PointGetConfirmPage._();

  static void start(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => PointGetConfirmPage._()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(R.res.strings.pointGetTitle)),
      body: _viewBody(context, ref),
    );
  }

  Widget _viewBody(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        children: [
          Center(child: Text(R.res.strings.pointGetConfirmOverview)),
          Center(child: Text(R.res.strings.pointGetConfirmDetail)),
          const SizedBox(height: 24),
          AppText.large(R.res.strings.pointGetConfirmPointLabel),
          _textGetPoint(ref),
          const SizedBox(height: 24),
          _buttonDecision(context, ref),
        ],
      ),
    );
  }

  Widget _textGetPoint(WidgetRef ref) {
    final inputPoint = ref.read(pointGetViewModel).inputPoint;
    return Text(
      '$inputPoint',
      style: TextStyle(fontSize: 32, color: R.res.colors.accentColor),
    );
  }

  Widget _buttonDecision(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final viewModel = ref.read(pointGetViewModel);
        final dialog = AppProgressDialog<void>();
        await dialog.show(
          context,
          execute: viewModel.execute,
          onSuccess: (result) {
            AppLogger.d('ポイント取得に成功しました！');
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
        child: Text(R.res.strings.pointGetConfirmExecuteButton),
      ),
    );
  }
}
