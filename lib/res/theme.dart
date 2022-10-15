import 'package:flutter/material.dart';
import 'package:mybt/res/colors.dart';

class AppTheme {
  static ThemeData drinkTheme(AppColors colors) {
    return ThemeData.light().copyWith(
      primaryColor: colors.themeColor,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.themeColor,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        color: colors.appBarColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.themeColor,
        ),
      ),
    );
  }
}
