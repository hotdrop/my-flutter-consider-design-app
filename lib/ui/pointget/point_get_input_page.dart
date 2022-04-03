import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/res/res.dart';
import 'package:mybt/ui/pointget/point_get_confirm_page.dart';
import 'package:mybt/ui/pointget/point_get_view_model.dart';
import 'package:mybt/ui/widgets/app_dialog.dart';
import 'package:mybt/common/app_extension.dart';
import 'package:mybt/ui/widgets/app_text.dart';

class PointGetInputPage extends ConsumerWidget {
  const PointGetInputPage._();

  static void start(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (context) => const PointGetInputPage._()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(pointGetViewModel).uiState;

    return Scaffold(
      appBar: AppBar(title: Text(R.res.strings.pointGetTitle)),
      body: uiState.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        success: () => const _ViewBody(),
        error: (String errorMsg) {
          _processOnError(context, errorMsg);
          return Center(
            child: Text(R.res.strings.pointGetInputError),
          );
        },
      ),
    );
  }

  void _processOnError(BuildContext context, String errorMsg) {
    Future<void>.delayed(Duration.zero).then((value) {
      AppDialog(
        errorMsg,
        onOk: () {},
      ).show(context);
    });
  }
}

class _ViewBody extends StatelessWidget {
  const _ViewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        children: [
          AppText.normal(R.res.strings.pointGetInputOverview),
          const _ViewHoldPointLabel(),
          const SizedBox(height: 4),
          AppText.caption(R.res.strings.pointGetInputAttension.embedded(<int>[R.res.integers.maxPoint])),
          const SizedBox(height: 16),
          const _ViewPointTextField(),
          const SizedBox(height: 16),
          const _ViewButtonNext(),
        ],
      ),
    );
  }
}

class _ViewHoldPointLabel extends ConsumerWidget {
  const _ViewHoldPointLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final holdPoint = ref.watch(pointGetHoldPointStateProvider);
    return AppText.large('$holdPoint ${R.res.strings.pointUnit}');
  }
}

class _ViewPointTextField extends ConsumerWidget {
  const _ViewPointTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableMaxGetPoint = ref.watch(pointGetAvailableMaxValueStateProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: R.res.strings.pointGetInputTextFieldLabel,
          counterText: '',
        ),
        style: const TextStyle(fontSize: 24),
        maxLength: 4,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? v) => _pointValidator(v, availableMaxGetPoint),
        onChanged: (String? newVal) {
          if (_pointValidator(newVal, availableMaxGetPoint) == null) {
            final inputVal = (newVal != null) ? int.tryParse(newVal) ?? 0 : 0;
            ref.read(pointGetViewModel).input(inputVal);
          } else {
            ref.read(pointGetViewModel).input(0);
          }
        },
      ),
    );
  }

  String? _pointValidator(String? inputVal, int availableMaxGetPoint) {
    final inputPoint = int.tryParse(inputVal ?? '0') ?? 0;
    if (inputPoint <= 0) {
      return null;
    }
    if (inputPoint > availableMaxGetPoint) {
      return R.res.strings.pointGetInputTextFieldErrorOverMaxPoint.embedded(<int>[availableMaxGetPoint]);
    }
    return null;
  }
}

class _ViewButtonNext extends ConsumerWidget {
  const _ViewButtonNext({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enableButton = ref.watch(pointGetOkInputPointStateProvider);

    return ElevatedButton(
      onPressed: enableButton ? () => PointGetConfirmPage.start(context) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
        child: AppText.normal(R.res.strings.pointGetInputConfirmButton),
      ),
    );
  }
}
