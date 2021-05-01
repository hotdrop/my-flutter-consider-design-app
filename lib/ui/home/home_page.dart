import 'package:flutter/material.dart';

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
      appBar: AppBar(title: Text('メイン')),
      body: _viewBody(),
    );
  }

  Widget _viewBody() {
    return Center(
      child: Text('ホームです'),
    );
  }
}
