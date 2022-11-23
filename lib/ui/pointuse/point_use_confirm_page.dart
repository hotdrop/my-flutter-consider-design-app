import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/res/res.dart';
import 'package:mybt/ui/pointuse/point_use_view_model.dart';
import 'package:mybt/ui/widgets/app_dialog.dart';
import 'package:mybt/ui/widgets/app_text.dart';
import 'package:mybt/ui/widgets/progress_dialog.dart';

class PointUseConfirmPage extends ConsumerWidget {
  const PointUseConfirmPage._();

  static void start(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => const PointUseConfirmPage._()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(R.res.strings.pointUseTitle)),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          children: [
            Center(child: AppText.large(R.res.strings.pointUseConfirmOverview)),
            const SizedBox(height: 16),
            Center(child: AppText.normal(R.res.strings.pointUseConfirmDetail)),
            const SizedBox(height: 24),
            AppText.large(R.res.strings.pointUseConfirmPointLabel),
            const _ViewTextUsePoint(),
            const SizedBox(height: 24),
            const _ViewDecisionButton(),
          ],
        ),
      ),
    );
  }
}

class _ViewTextUsePoint extends ConsumerWidget {
  const _ViewTextUsePoint();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usePoint = ref.watch(pointUseInputStateProvider);

    return Text(
      '$usePoint',
      style: TextStyle(fontSize: 32, color: R.res.colors.appBarColor),
    );
  }
}

class _ViewDecisionButton extends ConsumerWidget {
  const _ViewDecisionButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async => await _onPress(context, ref),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
        child: Text(R.res.strings.pointUseConfirmExecuteButton),
      ),
    );
  }

  Future<void> _onPress(BuildContext context, WidgetRef ref) async {
    const dialog = AppProgressDialog<void>();
    await dialog.show(
      context,
      execute: ref.read(pointUseViewModel).execute,
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
  }
}
