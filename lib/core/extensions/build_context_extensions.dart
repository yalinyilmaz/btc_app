import 'package:flutter/material.dart';

import 'package:btc_app/app/theme/color/colors.dart';
import 'package:btc_app/core/responsive/app_breakpoints.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  AppColors get colors => theme.extension<AppColors>() ?? AppColors.dark;

  TextTheme get textTheme => theme.textTheme;

  TextStyle? get headlineSmall => textTheme.headlineSmall;
  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;
  TextStyle? get labelLarge => textTheme.labelLarge;

  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  AppLayoutSize get layoutSize => AppBreakpoints.fromWidth(screenWidth);
  bool get isMobileLayout => layoutSize == AppLayoutSize.mobile;
  bool get isTabletLayout => layoutSize == AppLayoutSize.tablet;
  bool get isDesktopLayout => layoutSize == AppLayoutSize.desktop;

  double get pageHorizontalPadding => switch (layoutSize) {
    AppLayoutSize.mobile => 16,
    AppLayoutSize.tablet => 24,
    AppLayoutSize.desktop => 32,
  };
}
