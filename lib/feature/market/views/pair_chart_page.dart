import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:btc_app/app/components/app_language_button.dart';
import 'package:btc_app/app/components/app_page_body.dart';
import 'package:btc_app/app/localization/locale_keys.g.dart';
import 'package:btc_app/feature/market/views/pair_chart_view.dart';

class PairChartPage extends StatelessWidget {
  final String pairSymbol;

  const PairChartPage({super.key, required this.pairSymbol});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr(LocaleKeys.market_chart_title, args: [pairSymbol]),
        ),
        actions: const [AppLanguageButton()],
      ),
      body: const AppPageBody(child: PairChartView()),
    );
  }
}
