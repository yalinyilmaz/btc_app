import 'package:flutter/material.dart';

import 'package:btc_app/app/theme/color/colors.dart';

abstract final class AppTextStyle {
  static final textTheme = TextTheme(
    headlineSmall: TextStyle(
      color: AppColors.dark.textPrimary,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      color: AppColors.dark.textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: AppColors.dark.textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(color: AppColors.dark.textPrimary, fontSize: 16),
    bodyMedium: TextStyle(color: AppColors.dark.textPrimary, fontSize: 14),
    bodySmall: TextStyle(color: AppColors.dark.textSecondary, fontSize: 12),
    labelLarge: TextStyle(
      color: AppColors.dark.textPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );
}
