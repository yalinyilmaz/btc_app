import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:btc_app/app/components/app_error_view.dart';
import 'package:btc_app/app/localization/locale_keys.g.dart';
import 'package:btc_app/feature/market/cubit/pair_chart_cubit.dart';
import 'package:btc_app/feature/market/cubit/pair_chart_state.dart';
import 'package:btc_app/feature/market/models/kline_candle.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';
import 'package:btc_app/feature/market/views/components/pair_chart_content.dart';
import 'package:btc_app/feature/market/views/extensions/market_failure_extensions.dart';

class PairChartView extends StatelessWidget {
  const PairChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PairChartCubit, PairChartState, PairChartStatus>(
      selector: (state) => state.status,
      builder: (context, status) {
        return switch (status) {
          PairChartStatus.initial || PairChartStatus.loading => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          PairChartStatus.success =>
            BlocSelector<PairChartCubit, PairChartState, List<KlineCandle>>(
              selector: (state) => state.candles,
              builder: (context, candles) {
                if (candles.isEmpty) {
                  return Center(
                    child: Text(context.tr(LocaleKeys.market_chart_empty)),
                  );
                }

                return PairChartContent(candles: candles);
              },
            ),
          PairChartStatus.failure =>
            BlocSelector<PairChartCubit, PairChartState, MarketFailure?>(
              selector: (state) => state.failure,
              builder: (context, failure) {
                return AppErrorView(
                  messageKey: (failure ?? MarketFailure.unexpected).messageKey,
                  onRetry: context.read<PairChartCubit>().load,
                );
              },
            ),
        };
      },
    );
  }
}
