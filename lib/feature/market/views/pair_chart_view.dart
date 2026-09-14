import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:btc_app/app/components/app_error_view.dart';
import 'package:btc_app/app/localization/locale_keys.g.dart';
import 'package:btc_app/feature/market/cubit/pair_chart_cubit.dart';
import 'package:btc_app/feature/market/cubit/pair_chart_state.dart';
import 'package:btc_app/feature/market/models/kline_candle.dart';
import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';
import 'package:btc_app/feature/market/views/components/pair_chart_content.dart';
import 'package:btc_app/feature/market/views/components/pair_chart_range_bar.dart';

typedef _PairChartViewData = ({
  PairChartStatus status,
  PairChartRange range,
  List<KlineCandle> candles,
  TickerModel? ticker,
  MarketFailure? failure,
});

class PairChartView extends StatelessWidget {
  const PairChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PairChartCubit, PairChartState, _PairChartViewData>(
      selector: (state) => (
        status: state.status,
        range: state.range,
        candles: state.candles,
        ticker: state.selectedTicker,
        failure: state.failure,
      ),
      builder: (context, data) {
        final bool isLoading = data.status == PairChartStatus.loading;

        if (data.status == PairChartStatus.initial || (isLoading && data.candles.isEmpty)) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (data.status == PairChartStatus.failure) {
          return AppErrorView(
            displayMessage: context.tr((data.failure ?? MarketFailure.unexpected).messageKey),
            onRetry: context.read<PairChartCubit>().load,
          );
        }

        if (data.candles.isEmpty) {
          return _EmptyChart(selectedRange: data.range, onRangeSelected: context.read<PairChartCubit>().selectRange);
        }

        return PairChartContent(
          key: ValueKey(data.range),
          candles: data.candles,
          ticker: data.ticker,
          selectedRange: data.range,
          onRangeSelected: context.read<PairChartCubit>().selectRange,
          isLoading: isLoading,
        );
      },
    );
  }
}

class _EmptyChart extends StatelessWidget {
  final PairChartRange selectedRange;
  final ValueChanged<PairChartRange> onRangeSelected;

  const _EmptyChart({required this.selectedRange, required this.onRangeSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          PairChartRangeBar(selectedRange: selectedRange, onSelected: onRangeSelected),
          Expanded(child: Center(child: Text(context.tr(LocaleKeys.market_chart_empty)))),
        ],
      ),
    );
  }
}
