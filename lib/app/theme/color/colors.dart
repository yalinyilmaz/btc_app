import 'package:flutter/material.dart';

@immutable
class AppColors {
  final Color background;
  final Color positive;
  final Color negative;
  final Color favorite;
  final Color textPrimary;
  final Color textSecondary;
  final Color surface;
  final Color selectedSurface;

  const AppColors({
    required this.background,
    required this.positive,
    required this.negative,
    required this.favorite,
    required this.textPrimary,
    required this.textSecondary,
    required this.surface,
    required this.selectedSurface,
  });

  static const dark = AppColors(
    background: Color(0xFF09101B),
    positive: Color(0xFF009C21),
    negative: Color(0xFFD6301E),
    favorite: Color(0xFFD4AF37),
    textPrimary: Color(0xFFF8F8F8),
    textSecondary: Color(0xFF8F98A6),
    surface: Color(0xFF1B232E),
    selectedSurface: Color(0xFF29465F),
  );

  AppColors copyWith({
    Color? background,
    Color? positive,
    Color? negative,
    Color? favorite,
    Color? textPrimary,
    Color? textSecondary,
    Color? surface,
    Color? selectedSurface,
  }) {
    return AppColors(
      background: background ?? this.background,
      positive: positive ?? this.positive,
      negative: negative ?? this.negative,
      favorite: favorite ?? this.favorite,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      surface: surface ?? this.surface,
      selectedSurface: selectedSurface ?? this.selectedSurface,
    );
  }
}
