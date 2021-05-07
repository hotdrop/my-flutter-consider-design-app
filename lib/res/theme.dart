import 'package:flutter/material.dart';
import 'package:mybt/res/colors.dart';

class AppTheme {
  static ThemeData drinkTheme(AppColors colors) {
    return ThemeData.light().copyWith(
      primaryColor: colors.themeColor,
      accentColor: colors.accentColor,
      appBarTheme: AppBarTheme(
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: colors.themeColor,
        ),
      ),
    );
  }
}
