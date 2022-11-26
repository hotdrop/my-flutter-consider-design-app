import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/models/point.dart';
import 'package:mybt/res/res.dart';
import 'package:mybt/ui/pointuse/point_use_confirm_page.dart';
import 'package:mybt/ui/pointuse/point_use_view_model.dart';
import 'package:mybt/ui/widgets/app_text.dart';

class PointUseInputPage extends StatelessWidget {
  const PointUseInputPage._();

  static void start(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (context) => const PointUseInputPage._()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.res.strings.pointUseTitle)),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Center(
          child: Column(
            children: [
              AppText.normal(R.res.strings.pointUseInputOverview),
              const SizedBox(height: 8),
              const _ViewHoldPointLabel(),
              const SizedBox(height: 16),
              const _ViewPointTextField(),
              const SizedBox(height: 16),
              const _ViewButtonNext(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewHoldPointLabel extends ConsumerWidget {
  const _ViewHoldPointLabel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final holdPoint = ref.read(pointProvider).balance;
    return AppText.large('$holdPoint ${R.res.strings.pointUnit}');
  }
}

class _ViewPointTextField extends ConsumerWidget {
  const _ViewPointTextField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final holdPoint = ref.watch(pointProvider).balance;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: R.res.strings.pointUseInputTextFieldLabel,
          counterText: '',
        ),
        style: const TextStyle(fontSize: 24),
        maxLength: 4,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? v) => _pointValidator(v, holdPoint),
        onChanged: (String? newVal) {
          if (_pointValidator(newVal, holdPoint) == null) {
            final inputVal = (newVal != null) ? int.tryParse(newVal) ?? 0 : 0;
            ref.read(pointUseViewModel).input(inputVal);
          } else {
            ref.read(pointUseViewModel).input(0);
          }
        },
      ),
    );
  }

  String? _pointValidator(String? inputVal, int holdPoint) {
    final inputPoint = int.tryParse(inputVal ?? '0') ?? 0;
    if (inputPoint <= 0) {
      return null;
    }

    if (inputPoint > holdPoint) {
      return R.res.strings.pointUseInputTextFieldErrorOverPoint;
    }
    return null;
  }
}

class _ViewButtonNext extends ConsumerWidget {
  const _ViewButtonNext();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enableButton = ref.watch(pointUseOkInputPointStateProvider);

    return ElevatedButton(
      onPressed: enableButton ? () => PointUseConfirmPage.start(context) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
        child: AppText.normal(R.res.strings.pointUseInputConfirmButton),
      ),
    );
  }
}
