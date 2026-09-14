import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:btc_app/app/theme/color/colors.dart';
import 'package:btc_app/app/theme/typography/text_style.dart';

abstract final class AppTheme {
  static final systemOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.dark.background,
    systemNavigationBarDividerColor: AppColors.dark.background,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarContrastEnforced: false,
  );

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.dark.positive,
      onPrimary: AppColors.dark.textPrimary,
      surface: AppColors.dark.surface,
      onSurface: AppColors.dark.textPrimary,
      error: AppColors.dark.negative,
      onError: AppColors.dark.textPrimary,
      outline: AppColors.dark.textSecondary,
    ),
    scaffoldBackgroundColor: AppColors.dark.background,
    textTheme: AppTextStyle.textTheme,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.dark.background,
      foregroundColor: AppColors.dark.textPrimary,
      systemOverlayStyle: systemOverlayStyle,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.dark.surface,
      thickness: 1,
      space: 1,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.dark.positive,
    ),
  );
}
