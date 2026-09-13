import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:btc_app/app/components/app_language_button.dart';
import 'package:btc_app/app/components/app_page_body.dart';
import 'package:btc_app/app/localization/locale_keys.g.dart';
import 'package:btc_app/app/routes/router.dart';
import 'package:btc_app/feature/market/views/pair_list_view.dart';

class PairListPage extends StatelessWidget {
  const PairListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr(LocaleKeys.market_pairs_title)),
        actions: const [AppLanguageButton()],
      ),
      body: AppPageBody(
        child: PairListView(
          onPairTap: (pairSymbol) {
            context.push(AppRouteNames.pairChartLocation(pairSymbol));
          },
        ),
      ),
    );
  }
}
