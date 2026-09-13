import 'package:flutter/material.dart';

import 'package:btc_app/app/components/app_responsive_builder.dart';
import 'package:btc_app/feature/market/cubit/pair_chart_state.dart';
import 'package:btc_app/feature/market/models/kline_candle.dart';
import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/views/components/pair_chart_details.dart';
import 'package:btc_app/feature/market/views/components/pair_chart_range_bar.dart';
import 'package:btc_app/feature/market/views/components/pair_line_chart.dart';

class PairChartContent extends StatefulWidget {
  final List<KlineCandle> candles;
  final TickerModel? ticker;
  final PairChartRange selectedRange;
  final ValueChanged<PairChartRange> onRangeSelected;
  final bool isLoading;

  const PairChartContent({
    super.key,
    required this.candles,
    this.ticker,
    required this.selectedRange,
    required this.onRangeSelected,
    this.isLoading = false,
  });

  @override
  State<PairChartContent> createState() => _PairChartContentState();
}

class _PairChartContentState extends State<PairChartContent> {
  int? _selectedIndex;

  KlineCandle get _displayedCandle {
    final selectedIndex = _selectedIndex;
    if (selectedIndex != null && selectedIndex < widget.candles.length) {
      return widget.candles[selectedIndex];
    }
    return widget.candles.last;
  }

  void _selectCandle(int? index) {
    if (_selectedIndex == index) {
      return;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final chart = Column(
      children: [
        PairChartRangeBar(
          selectedRange: widget.selectedRange,
          onSelected: widget.onRangeSelected,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 2,
          child: widget.isLoading ? const LinearProgressIndicator() : null,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: PairLineChart(
            candles: widget.candles,
            range: widget.selectedRange,
            onCandleSelected: _selectCandle,
          ),
        ),
      ],
    );
    final details = PairChartDetails(
      candle: _displayedCandle,
      ticker: widget.ticker,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: AppResponsiveBuilder(
        mobile: (_) => Column(
          children: [
            SizedBox(height: 420, child: chart),
            const SizedBox(height: 16),
            details,
          ],
        ),
        tablet: (_) => Column(
          children: [
            SizedBox(height: 500, child: chart),
            const SizedBox(height: 20),
            details,
          ],
        ),
        desktop: (_) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: SizedBox(height: 580, child: chart)),
            const SizedBox(width: 24),
            SizedBox(width: 360, child: details),
          ],
        ),
      ),
    );
  }
}
