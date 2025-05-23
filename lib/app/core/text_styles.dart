import 'package:flutter/cupertino.dart';

import 'app_strings.dart';

abstract class AppTextStyles {
  static const TextStyle w900 = TextStyle(fontWeight: FontWeight.w900);
  static const TextStyle w800 = TextStyle(fontWeight: FontWeight.w800);
  static const TextStyle w700 = TextStyle(fontWeight: FontWeight.w700);
  static const TextStyle w600 = TextStyle(
      fontFamily: AppStrings.enFontFamily,
      fontWeight: FontWeight.w600);
  static const TextStyle w500 = TextStyle(
      fontFamily: AppStrings.enFontFamily,
      fontWeight: FontWeight.w500);
  static const TextStyle w400 = TextStyle(
      fontFamily: AppStrings.enFontFamily,
      fontWeight: FontWeight.w400);
  static const TextStyle w300 = TextStyle(fontWeight: FontWeight.w300);
  static const TextStyle w200 = TextStyle(fontWeight: FontWeight.w200);
}
