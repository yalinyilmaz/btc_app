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

typedef _PairChartViewData = ({
  PairChartStatus status,
  List<KlineCandle> candles,
  MarketFailure? failure,
});

class PairChartView extends StatelessWidget {
  const PairChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PairChartCubit, PairChartState, _PairChartViewData>(
      selector: (state) => (
        status: state.status,
        candles: state.candles,
        failure: state.failure,
      ),
      builder: (context, data) {
        return switch (data.status) {
          PairChartStatus.initial || PairChartStatus.loading => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          PairChartStatus.success when data.candles.isEmpty => Center(
            child: Text(context.tr(LocaleKeys.market_chart_empty)),
          ),
          PairChartStatus.success => PairChartContent(candles: data.candles),
          PairChartStatus.failure => AppErrorView(
            displayMessage: context.tr(
              (data.failure ?? MarketFailure.unexpected).messageKey,
            ),
            onRetry: context.read<PairChartCubit>().load,
          ),
        };
      },
    );
  }
}
