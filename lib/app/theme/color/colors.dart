import 'package:flutter/material.dart';

@immutable
class AppColors {
  final Color background;
  final Color positive;
  final Color negative;
  final Color textPrimary;
  final Color textSecondary;
  final Color surface;

  const AppColors({
    required this.background,
    required this.positive,
    required this.negative,
    required this.textPrimary,
    required this.textSecondary,
    required this.surface,
  });

  static const dark = AppColors(
    background: Color(0xFF09101B),
    positive: Color(0xFF009C21),
    negative: Color(0xFFD6301E),
    textPrimary: Color(0xFFF8F8F8),
    textSecondary: Color(0xFF8F98A6),
    surface: Color(0xFF1B232E),
  );

  AppColors copyWith({
    Color? background,
    Color? positive,
    Color? negative,
    Color? textPrimary,
    Color? textSecondary,
    Color? surface,
  }) {
    return AppColors(
      background: background ?? this.background,
      positive: positive ?? this.positive,
      negative: negative ?? this.negative,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      surface: surface ?? this.surface,
    );
  }
}
