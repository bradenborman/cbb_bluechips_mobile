import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF0D9EF0);
  static const navy = Color(0xFF204667);
  static const bg = Color(0xFF0E0E0E);
  static const surface = Color(0xFF212121);
  static const line = Color(0xFF3C4144);
  static const ice = Color(0xFFF1F5F8);
}

ThemeData buildTheme() {
  final scheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.navy,
    onSecondary: Colors.white,
    surface: AppColors.surface,
    onSurface: AppColors.ice,
    error: const Color(0xFFEF5350),
    onError: Colors.white,
    tertiary: AppColors.primary,
    onTertiary: Colors.white,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    dividerColor: AppColors.line,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.ice,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    ),
    cardColor: AppColors.surface,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.primary),
    ),
  );
}