import 'package:flutter/material.dart';
import 'package:mybt/res/app_url.dart';
import 'package:mybt/res/colors.dart';
import 'package:mybt/res/images.dart';
import 'package:mybt/res/theme.dart';

class R {
  R._({
    required this.theme,
    required this.images,
    required this.colors,
    required this.url,
  });

  factory R.initAppCoffee() {
    final appColors = AppColors.createCoffee();
    res = R._(
      theme: AppTheme.coffeeTheme(appColors),
      images: Images.createCoffee(),
      colors: appColors,
      url: AppUrl.createCoffee(),
    );
    return res;
  }

  static late R res;

  final ThemeData theme;
  final Images images;
  final AppColors colors;

  final AppUrl url;
}
