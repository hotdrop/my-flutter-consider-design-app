import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/res/res.dart';
import 'package:mybt/ui/pointget/point_get_view_model.dart';
import 'package:mybt/ui/widgets/app_dialog.dart';
import 'package:mybt/ui/widgets/app_text.dart';
import 'package:mybt/ui/widgets/progress_dialog.dart';

class PointGetConfirmPage extends ConsumerWidget {
  const PointGetConfirmPage._();

  static void start(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => const PointGetConfirmPage._()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.res.strings.pointGetTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: AppText.large(R.res.strings.pointGetConfirmOverview)),
            const SizedBox(height: 16),
            Center(child: AppText.normal(R.res.strings.pointGetConfirmDetail)),
            const SizedBox(height: 24),
            AppText.large(R.res.strings.pointGetConfirmPointLabel),
            const _ViewTextGetPoint(),
            const SizedBox(height: 24),
            const _ViewDecisionButton(),
          ],
        ),
      ),
    );
  }
}

class _ViewTextGetPoint extends ConsumerWidget {
  const _ViewTextGetPoint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inputPoint = ref.watch(pointGetInputStateProvider);

    return Text(
      '$inputPoint',
      style: TextStyle(fontSize: 32, color: R.res.colors.appBarColor),
    );
  }
}

class _ViewDecisionButton extends ConsumerWidget {
  const _ViewDecisionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async => await _onPress(context, ref),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
        child: Text(R.res.strings.pointGetConfirmExecuteButton),
      ),
    );
  }

  Future<void> _onPress(BuildContext context, WidgetRef ref) async {
    const dialog = AppProgressDialog<void>();
    await dialog.show(
      context,
      execute: ref.read(pointGetViewModel).execute,
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
  }
}
