import 'package:flutter/material.dart';

import 'package:btc_app/app/components/app_responsive_builder.dart';
import 'package:btc_app/feature/market/models/kline_candle.dart';
import 'package:btc_app/feature/market/views/components/pair_chart_details.dart';
import 'package:btc_app/feature/market/views/components/pair_line_chart.dart';

class PairChartContent extends StatefulWidget {
  final List<KlineCandle> candles;

  const PairChartContent({super.key, required this.candles});

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
    final chart = PairLineChart(
      candles: widget.candles,
      onCandleSelected: _selectCandle,
    );
    final details = PairChartDetails(
      candle: _displayedCandle,
      isSelected: _selectedIndex != null,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: AppResponsiveBuilder(
        mobile: (_) => Column(
          children: [
            Expanded(child: chart),
            const SizedBox(height: 16),
            details,
          ],
        ),
        tablet: (_) => Column(
          children: [
            Expanded(child: chart),
            const SizedBox(height: 20),
            details,
          ],
        ),
        desktop: (_) => Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: chart),
            const SizedBox(width: 24),
            SizedBox(width: 280, child: details),
          ],
        ),
      ),
    );
  }
}
