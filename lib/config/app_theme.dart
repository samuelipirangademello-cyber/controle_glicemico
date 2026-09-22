import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFFFCFAFA);
  static const headerBg = Color(0xFFFFF4F5);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF251A1D);
  static const muted = Color(0xFF76686C);
  static const line = Color(0xFFEDE3E5);
  static const brand = Color(0xFF941D34);
  static const brandDeep = Color(0xFF741326);
  static const brandSoft = Color(0xFFF8E1E5);
  static const accent = Color(0xFFC94D62);
  static const onBrand = Colors.white;

  static const okBg = Color(0xFFDDF3E5);
  static const okFg = Color(0xFF16713D);
  static const warnBg = Color(0xFFFFF0CF);
  static const warnFg = Color(0xFF8A5A00);
  static const highBg = Color(0xFFF9DADD);
  static const highFg = Color(0xFFAE1F35);
  static const lowBg = Color(0xFFFFE5CE);
  static const lowFg = Color(0xFF8B4A0A);
}

ThemeData appTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.brand,
      onPrimary: AppColors.onBrand,
      surface: AppColors.surface,
    ),
    fontFamily: 'sans-serif',
    visualDensity: VisualDensity.standard,
  );
}
