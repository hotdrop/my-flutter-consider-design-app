import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mybt/res/res.dart';
import 'package:mybt/ui/home/home_view_model.dart';
import 'package:mybt/ui/home/row_history.dart';
import 'package:mybt/ui/pointget/point_get_input_page.dart';
import 'package:mybt/ui/pointuse/point_use_input_page.dart';
import 'package:mybt/ui/widgets/app_dialog.dart';
import 'package:mybt/ui/widgets/app_text.dart';

class HomePage extends ConsumerWidget {
  const HomePage._();

  static Future<void> start(BuildContext context) async {
    await Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute(builder: (_) => const HomePage._()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(R.res.strings.homeTitle)),
      body: ref.watch(homeViewModelProvider).when(
            loading: () => const _ViewOnLoading(),
            data: (_) => const _ViewOnSuccess(),
            error: (err, _) => _ViewOnError(errorMessage: '$err'),
          ),
    );
  }
}

class _ViewOnLoading extends StatelessWidget {
  const _ViewOnLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _ViewOnError extends StatelessWidget {
  const _ViewOnError({required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    Future<void>.delayed(Duration.zero).then((value) {
      AppDialog(errorMessage, onOk: () {}).show(context);
    });

    return Center(
      child: Text(R.res.strings.homeLoadingErrorLabel),
    );
  }
}

class _ViewOnSuccess extends StatelessWidget {
  const _ViewOnSuccess();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _ViewPointCard(),
        SizedBox(height: 16),
        _ViewMenuButton(),
        SizedBox(height: 16),
        _ViewHistories(),
      ],
    );
  }
}

class _ViewPointCard extends StatelessWidget {
  const _ViewPointCard();

  static final dateFormatter = DateFormat('yyyy/MM/dd HH:mm:ss');

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 4;

    return Container(
      width: height * 2,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Stack(
          children: [
            Positioned.fill(
              child: Ink.image(
                image: AssetImage(R.res.images.homePointCard),
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: AppText.normal(dateFormatter.format(DateTime.now()), color: Colors.white),
            ),
            const _ViewPointOnCard(),
            const _ViewUserInfoOnCard(),
          ],
        ),
      ),
    );
  }
}

class _ViewPointOnCard extends ConsumerWidget {
  const _ViewPointOnCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final point = ref.watch(homeCurrentPointProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppText.huge('${point.balance}', color: Colors.white),
          AppText.normal(R.res.strings.pointUnit, color: Colors.white),
        ],
      ),
    );
  }
}

class _ViewUserInfoOnCard extends ConsumerWidget {
  const _ViewUserInfoOnCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(homeAppSettingProivder);

    return Positioned(
      bottom: 16,
      left: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.normal(
            appSettings.nickName ?? R.res.strings.homeUnSettingNickname,
            color: Colors.white,
          ),
          AppText.normal(
            appSettings.email ?? R.res.strings.homeUnSettingEmail,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _ViewMenuButton extends StatelessWidget {
  const _ViewMenuButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _MenuButton(
            label: R.res.strings.homeMenuGetPoint,
            iconData: Icons.account_balance_wallet,
            onTap: () => PointGetInputPage.start(context),
          ),
          _MenuButton(
            label: R.res.strings.homeMenuUsePoint,
            iconData: Icons.shopping_cart_outlined,
            onTap: () => PointUseInputPage.start(context),
          ),
        ],
      ),
    );
  }
}

class _ViewHistories extends ConsumerWidget {
  const _ViewHistories();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final histories = ref.watch(homeHistoriesProvider);
    if (histories.isEmpty) {
      return const SizedBox();
    }

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: histories.length,
        itemBuilder: (ctx, index) => RowHistory(history: histories[index]),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.label,
    required this.iconData,
    required this.onTap,
  });

  final String label;
  final IconData iconData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Column(
        children: [
          Icon(iconData, size: 28, color: R.res.colors.themeColor),
          const SizedBox(height: 8),
          AppText.normal(label, color: R.res.colors.themeColor),
        ],
      ),
    );
  }
}
