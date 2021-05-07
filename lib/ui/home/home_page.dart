import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:mybt/common/app_logger.dart';
import 'package:mybt/models/app_setting.dart';
import 'package:mybt/models/point.dart';
import 'package:mybt/res/R.dart';
import 'package:mybt/ui/home/home_view_model.dart';
import 'package:mybt/ui/pointget/point_get_input_page.dart';
import 'package:mybt/ui/pointuse/point_use_input_page.dart';
import 'package:mybt/ui/widgets/app_dialog.dart';
import 'package:mybt/ui/widgets/app_text.dart';

class HomePage extends StatelessWidget {
  HomePage._();

  static void start(BuildContext context) {
    Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute(builder: (_) => HomePage._()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LifecycleWrapper(
      onLifecycleEvent: (event) {
        if (event == LifecycleEvent.active) {
          onResume(context);
        } else if (event == LifecycleEvent.inactive) {
          onStop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(R.res.strings.homeTitle)),
        body: Consumer(
          builder: (context, watch, child) {
            final uiState = watch(homeViewModel).uiState;
            return uiState.when(
              loading: () => _viewBody(context, isLoading: true),
              success: () => _viewBody(context, isLoading: false),
              error: (String errorMsg) => _onError(context, errorMsg),
            );
          },
        ),
      ),
    );
  }

  void onResume(BuildContext context) {
    AppLogger.d('onResumeが呼ばれました');
    final viewModel = context.read(homeViewModel);
    viewModel.onRefresh();
  }

  void onStop() {
    AppLogger.d('onStopが呼ばれた');
  }

  Widget _onError(BuildContext context, String errorMsg) {
    Future<void>.delayed(Duration.zero).then((value) {
      AppDialog(
        errorMsg,
        onOk: () {},
      ).show(context);
    });
    return Center(
      child: Text('エラーです。'),
    );
  }

  Widget _viewBody(BuildContext context, {bool isLoading = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _cardPoint(context, isLoading: isLoading),
        const SizedBox(height: 16),
        _viewMenuButton(context),
        const SizedBox(height: 16),
        _viewHistories(context),
      ],
    );
  }

  Widget _cardPoint(BuildContext context, {bool isLoading = false}) {
    return Container(
      height: 230,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
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
            if (isLoading) _cardPointLoading(),
            if (!isLoading) ..._cardPointContent(context),
          ],
        ),
      ),
    );
  }

  Widget _cardPointLoading() {
    return Center(child: CircularProgressIndicator());
  }

  List<Widget> _cardPointContent(BuildContext context) {
    return [
      _currentDateOnCard(),
      _pointOnCard(context),
      _detailOnCard(),
    ];
  }

  Widget _currentDateOnCard() {
    return Consumer(builder: (context, watch, child) {
      final nowStr = watch(homeViewModel).nowDateTimeStr;
      return Positioned(
        top: 16,
        left: 16,
        child: _labelOnCard(nowStr),
      );
    });
  }

  Widget _pointOnCard(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final point = watch(pointProvider);
        return Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _labelOnCard('${point.balance}', fontSize: 32),
              _labelOnCard(R.res.strings.pointUnit),
            ],
          ),
        );
      },
    );
  }

  Widget _detailOnCard() {
    return Consumer(builder: (context, watch, child) {
      final appSettings = watch(appSettingProvider);
      return Positioned(
        bottom: 16,
        left: 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // これらの項目を編集する画面がないので本当は作成した方がいい
            _labelOnCard(appSettings.nickName ?? R.res.strings.homeUnSettingNickname),
            _labelOnCard(appSettings.email ?? R.res.strings.homeUnSettingEmail),
          ],
        ),
      );
    });
  }

  Widget _labelOnCard(String text, {double? fontSize}) {
    return Text(
      text,
      style: TextStyle(color: Colors.white, fontSize: fontSize),
    );
  }

  Widget _viewMenuButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _MenuButton(
            label: R.res.strings.homeMenuGetPoint,
            iconData: Icons.account_balance_wallet,
            onTap: () {
              PointGetInputPage.start(context);
            },
          ),
          _MenuButton(
            label: R.res.strings.homeMenuUsePoint,
            iconData: Icons.shopping_cart_outlined,
            onTap: () {
              PointUseInputPage.start(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _viewHistories(BuildContext context) {
    final histories = context.read(homeViewModel).histories;
    if (histories == null || histories.isEmpty) {
      // 「ポイント利用/獲得履歴はありません」というラベルを表示した方がいい。
      return SizedBox();
    } else {
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: histories.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 2.0,
              child: ListTile(
                title: Text(histories[index].toStringDateTime()),
                subtitle: Text(histories[index].detail),
                trailing: Text(
                  '${histories[index].point} ${R.res.strings.pointUnit}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            );
          },
        ),
      );
    }
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
          AppText.normal(label),
        ],
      ),
    );
  }
}
