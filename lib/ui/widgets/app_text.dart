import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText._(this._text, this._color, this.size);

  factory AppText.caption(String text) {
    return AppText._(text, Colors.grey, 14);
  }

  factory AppText.normal(String text, {Color? color}) {
    return AppText._(text, color, 16);
  }

  factory AppText.large(String text, {Color? color}) {
    return AppText._(text, color, 24);
  }

  factory AppText.huge(String text, {Color? color}) {
    return AppText._(text, color, 36);
  }

  final String _text;
  final Color? _color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Text(_text, style: TextStyle(fontSize: size, color: _color));
  }
}
