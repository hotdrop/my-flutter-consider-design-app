import 'package:flutter/material.dart';
import 'package:mybt/res/R.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text('ホーム')),
      body: _viewBody(context),
    );
  }

  Widget _viewBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _cardPoint(context),
        const SizedBox(height: 16),
        _viewMenuButton(context),
      ],
    );
  }

  Widget _cardPoint(BuildContext context) {
    return Container(
      height: 230,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: InkWell(
          onTap: () {
            // TODO ポイント詳細に遷移
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Ink.image(
                  image: AssetImage(R.res.images.homePointCard),
                  fit: BoxFit.fill,
                ),
              ),
              _pointOnCard(context),
              _detailOnCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pointOnCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 36),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // TODO 動的に取得
          _labelOnCard('3600', fontSize: 32),
          _labelOnCard('ポイント'),
        ],
      ),
    );
  }

  Widget _detailOnCard() {
    return Positioned(
      bottom: 16,
      left: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelOnCard('ニックネーム: 未設定'),
          _labelOnCard('※ ポイントの有効期限は1年です'),
        ],
      ),
    );
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
            label: 'ポイント取得',
            iconData: Icons.account_balance_wallet,
            onTap: () {
              // TODO ポイント獲得ページへ
            },
          ),
          _MenuButton(
            label: 'ポイント利用',
            iconData: Icons.shopping_cart_outlined,
            onTap: () {
              // TODO ポイント利用ページへ
            },
          ),
        ],
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
          AppText.normal(label),
        ],
      ),
    );
  }
}
