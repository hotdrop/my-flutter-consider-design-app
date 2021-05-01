import 'package:flutter/material.dart';

class AppColors {
  AppColors._({
    required this.themeColor,
    required this.accentColor,
  });

  factory AppColors.createCoffee() {
    return AppColors._(
      themeColor: Color(0xFF906c56),
      accentColor: Color(0xFF955719),
    );
  }

  final Color themeColor;
  final Color accentColor;
}
