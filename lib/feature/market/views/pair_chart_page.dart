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
    final String pairName = _formatPairName(pairSymbol);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr(LocaleKeys.market_chart_title, args: [pairName]),
        ),
        actions: const [AppLanguageButton()],
      ),
      body: const AppPageBody(child: PairChartView()),
    );
  }

  String _formatPairName(String symbol) {
    if (symbol.endsWith('USDT')) {
      return '${symbol.substring(0, symbol.length - 4)}/USDT';
    }

    if (symbol.endsWith('TRY')) {
      return '${symbol.substring(0, symbol.length - 3)}/TRY';
    }

    return symbol;
  }
}
