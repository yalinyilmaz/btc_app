import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:btc_app/app/localization/app_locale.dart';
import 'package:btc_app/app/localization/locale_keys.g.dart';

class AppLanguageButton extends StatelessWidget {
  const AppLanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      tooltip: context.tr(LocaleKeys.common_language),
      initialValue: context.locale,
      onSelected: context.setLocale,
      itemBuilder: (context) {
        return AppLocale.supportedLocales
            .map((locale) {
              final isSelected = context.locale == locale;

              return PopupMenuItem<Locale>(
                value: locale,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.tr(AppLocale.languageNameKey(locale)),
                      ),
                    ),
                    if (isSelected) const Icon(Icons.check, size: 18),
                  ],
                ),
              );
            })
            .toList(growable: false);
      },
    );
  }
}
