import 'package:flutter/widgets.dart';

import 'package:btc_app/app/localization/locale_keys.g.dart';

abstract final class AppLocale {
  static const english = Locale('en');
  static const turkish = Locale('tr');

  static const supportedLocales = <Locale>[english, turkish];
  static const fallbackLocale = english;
  static const translationsPath = 'assets/translations';

  static String languageNameKey(Locale locale) {
    return switch (locale.languageCode) {
      'tr' => LocaleKeys.common_languages_turkish,
      _ => LocaleKeys.common_languages_english,
    };
  }
}
