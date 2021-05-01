import 'package:flutter/material.dart';
import 'package:mybt/res/R.dart';

class AppText extends StatelessWidget {
  const AppText._(this._text, this._style, this.isTheme, this.size);

  factory AppText.largeWithTheme(String text, {TextStyle? style}) {
    return AppText._(text, style, true, 24);
  }

  final String _text;
  final TextStyle? _style;
  final bool isTheme;
  final double? size;

  @override
  Widget build(BuildContext context) {
    if (isTheme) {
      return Text(_text, style: TextStyle(fontSize: size, color: R.res.colors.themeColor));
    } else {
      return Text(_text, style: _style);
    }
  }
}
