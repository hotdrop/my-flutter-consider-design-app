import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/models/app_setting.dart';
import 'package:mybt/models/history.dart';
import 'package:mybt/models/point.dart';
import 'package:mybt/res/res.dart';
import 'package:mybt/ui/home/home_view_model.dart';
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
    final uiState = ref.watch(homeViewModel).uiState;

    return LifecycleWrapper(
      onLifecycleEvent: (event) {
        if (event == LifecycleEvent.active) {
          onResume(ref);
        } else if (event == LifecycleEvent.inactive) {
          onStop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(R.res.strings.homeTitle)),
        body: uiState.when(
          loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          success: () {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _ViewPointCard(),
                SizedBox(height: 16),
                _ViewMenuButton(),
                SizedBox(height: 16),
                _ViewHistories(),
              ],
            );
          },
          error: (String errorMsg) {
            _processOnError(context, errorMsg);
            return Center(
              child: Text(R.res.strings.homeLoadingErrorLabel),
            );
          },
        ),
      ),
    );
  }

  ///
  /// onResumeでonRefreshを呼びポイントCardViewとHistoryを更新している。
  /// LifecycleWrapperを使ってみたかったのと部分的なViewのロード検証をしたかったので作ったが、本当は
  /// homeHistoriesStateProviderをhomeViewModelではなくmodelクラスに切り出してポイントGetやUseを
  /// したときにProviderを更新するようにしたほうがいいと思う。
  ///
  void onResume(WidgetRef ref) {
    AppLogger.d('onResumeが呼ばれました');
    ref.read(homeViewModel).onRefresh();
  }

  void onStop() {
    AppLogger.d('onStopが呼ばれました');
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

class _ViewPointCard extends ConsumerWidget {
  const _ViewPointCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(homeLoadingPointCardStateProvider);

    return Container(
      height: 230,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: _createBody(isLoading),
    );
  }

  Widget _createBody(bool isLoading) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return const _ViewBodyPointCard();
    }
  }
}

class _ViewBodyPointCard extends ConsumerWidget {
  const _ViewBodyPointCard({Key? key}) : super(key: key);

  static final dateFormatter = DateFormat('y/M/d H:m:s');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
    );
  }
}

class _ViewPointOnCard extends ConsumerWidget {
  const _ViewPointOnCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final point = ref.watch(pointProvider);

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
  const _ViewUserInfoOnCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(appSettingProvider);
    final nickname = appSettings.nickName ?? R.res.strings.homeUnSettingNickname;
    final email = appSettings.email ?? R.res.strings.homeUnSettingEmail;

    return Positioned(
      bottom: 16,
      left: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.normal(nickname, color: Colors.white),
          AppText.normal(email, color: Colors.white),
        ],
      ),
    );
  }
}

class _ViewMenuButton extends StatelessWidget {
  const _ViewMenuButton({Key? key}) : super(key: key);

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
  const _ViewHistories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final histories = ref.watch(homeHistoriesStateProvider);
    if (histories.isEmpty) {
      return const SizedBox();
    }

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: histories.length,
        itemBuilder: (ctx, index) => _ViewRowHistory(histories[index]),
      ),
    );
  }
}

class _ViewRowHistory extends StatelessWidget {
  const _ViewRowHistory(this.history, {Key? key}) : super(key: key);

  final History history;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: ListTile(
        title: Text(history.toStringDateTime()),
        subtitle: AppText.normal(history.detail),
        trailing: AppText.large('${history.point} ${R.res.strings.pointUnit}'),
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
