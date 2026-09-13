import 'dart:ui';

import 'package:intl/intl.dart';

extension NumFormattingX on num {
  String formatDecimal(
    Locale locale, {
    int minimumFractionDigits = 0,
    int maximumFractionDigits = 8,
  }) {
    final formatter = NumberFormat.decimalPattern(locale.toLanguageTag())
      ..minimumFractionDigits = minimumFractionDigits
      ..maximumFractionDigits = maximumFractionDigits;

    return formatter.format(this);
  }

  String formatPercent(Locale locale) {
    final formatter = NumberFormat.percentPattern(locale.toLanguageTag())
      ..minimumFractionDigits = 2
      ..maximumFractionDigits = 2;

    return formatter.format(this / 100);
  }
}
