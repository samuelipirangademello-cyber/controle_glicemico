import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFFFDF8F7);
  static const headerBg = Color(0xFFF8E4E5);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceTint = Color(0xFFFCF1F1);
  static const surfaceSoft = Color(0xFFF9ECEC);
  static const ink = Color(0xFF3A1F24);
  static const muted = Color(0xFF856A6F);
  static const line = Color(0xFFF0E2E2);
  static const brand = Color(0xFFA02F3B);
  static const brandDeep = Color(0xFF7A1522);
  static const brandSoft = Color(0xFFF8E4E5);
  static const accent = Color(0xFFC94B5B);
  static const onBrand = Colors.white;

  static const okBg = Color(0xFFD6F0DE);
  static const okFg = Color(0xFF17643A);
  static const warnBg = Color(0xFFFFEBB8);
  static const warnFg = Color(0xFF6E4A00);
  static const highBg = Color(0xFFFAC9CE);
  static const highFg = Color(0xFF9B1C2A);
  static const lowBg = Color(0xFFFFDDBF);
  static const lowFg = Color(0xFF85410A);
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
    splashFactory: InkSparkle.splashFactory,
    visualDensity: VisualDensity.standard,
  );
}
