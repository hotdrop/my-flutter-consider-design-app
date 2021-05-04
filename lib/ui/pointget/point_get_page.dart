import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybt/res/R.dart';
import 'package:mybt/ui/pointget/point_get_view_model.dart';
import 'package:mybt/ui/widgets/app_dialog.dart';

class PointGetPage extends StatelessWidget {
  static void start(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (context) => PointGetPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.res.strings.pointGetTitle)),
      body: Consumer(
        builder: (context, watch, child) {
          final uiState = watch(pointGetViewModel).state;
          return uiState.when(
            loading: () => _onLoading(),
            success: () => _onSuccess(),
            error: (String errorMsg) => _onError(context, errorMsg),
          );
        },
      ),
    );
  }

  Widget _onLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _onSuccess() {
    return Column(
      children: [
        Text('取得したいポイントを入力してください。'),
        // TODO ポイント取得のUI
      ],
    );
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
}
