import 'package:flutter/material.dart';

class AppColors {
  static const orange = Color(0xFFFF6A13);
  static const orangeDark = Color(0xFFE85A00);
  static const orangeSoft = Color(0xFFFFEDE0);
  static const bg = Color(0xFFF5F6FF);
  static const field = Color(0xFFEEF0FF);
  static const text = Color(0xFF1F1A2E);
  static const muted = Color(0xFF7A7890);
  static const brown = Color(0xFF8A3B00);
  static const green = Color(0xFF16A34A);
  static const greenSoft = Color(0xFFDDF7E8);
  static const red = Color(0xFFDC2626);
  static const redSoft = Color(0xFFFEE2E2);
}

/// Nama font. Kosongkan (null) untuk memakai font bawaan perangkat.
/// Untuk Plus Jakarta Sans: daftarkan file font di pubspec.yaml lalu isi
/// dengan 'PlusJakartaSans'.
const String? kFontFamily = null;

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.orange, primary: AppColors.orange),
    scaffoldBackgroundColor: AppColors.bg,
    fontFamily: kFontFamily,
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: AppColors.text, displayColor: AppColors.text),
  );
}
