import 'package:flutter/material.dart';

class AppColors {
  AppColors._({
    required this.themeColor,
    required this.appBarColor,
  });

  factory AppColors.createCoffee() {
    return AppColors._(
      themeColor: const Color(0xFF906c56),
      appBarColor: const Color(0xFF955719),
    );
  }

  factory AppColors.createTea() {
    return AppColors._(
      themeColor: const Color(0xFFA353C9),
      appBarColor: const Color(0xFFB922C7),
    );
  }

  final Color themeColor;
  final Color appBarColor;
}
