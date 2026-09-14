import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:btc_app/app/components/app_error_view.dart';
import 'package:btc_app/app/components/app_language_button.dart';
import 'package:btc_app/app/components/app_page_body.dart';
import 'package:btc_app/app/localization/locale_keys.g.dart';
import 'package:btc_app/app/routes/router.dart';
import 'package:btc_app/feature/market/cubit/pair_list_cubit.dart';
import 'package:btc_app/feature/market/cubit/pair_list_state.dart';
import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';
import 'package:btc_app/feature/market/views/pair_list_view.dart';

typedef _PairListPageData = ({
  PairListStatus status,
  List<TickerModel> allPairs,
  MarketFailure? failure,
  String? errorMessage,
});

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
        child: BlocSelector<PairListCubit, PairListState, _PairListPageData>(
          selector: (state) => (
            status: state.status,
            allPairs: state.allPairs,
            failure: state.failure,
            errorMessage: state.errorMessage,
          ),
          builder: (context, data) {
            return switch (data.status) {
              PairListStatus.initial || PairListStatus.loading => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              PairListStatus.success when data.allPairs.isEmpty => Center(
                child: Text(context.tr(LocaleKeys.market_pairs_empty)),
              ),
              PairListStatus.success => PairListView(
                allPairs: data.allPairs,
                onPairTap: (pairSymbol) {
                  context.push(AppRouteNames.pairChartPath(pairSymbol));
                },
              ),
              PairListStatus.failure => AppErrorView(
                displayMessage: _displayMessage(context, data),
                onRetry: () =>
                    context.read<PairListCubit>().load(refresh: true),
              ),
            };
          },
        ),
      ),
    );
  }

  String _displayMessage(BuildContext context, _PairListPageData data) {
    final backendMessage = data.errorMessage?.trim();
    if (backendMessage != null && backendMessage.isNotEmpty) {
      return backendMessage;
    }

    return context.tr((data.failure ?? MarketFailure.unexpected).messageKey);
  }
}
