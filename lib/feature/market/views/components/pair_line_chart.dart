import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:btc_app/core/extensions/build_context_extensions.dart';
import 'package:btc_app/core/extensions/num_extensions.dart';
import 'package:btc_app/feature/market/cubit/pair_chart_state.dart';
import 'package:btc_app/feature/market/models/kline_candle.dart';

class PairLineChart extends StatelessWidget {
  final List<KlineCandle> candles;
  final PairChartRange range;
  final ValueChanged<int?> onCandleSelected;

  const PairLineChart({
    super.key,
    required this.candles,
    required this.range,
    required this.onCandleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final Color lineColor = candles.last.close >= candles.first.close
        ? context.colors.positive
        : context.colors.negative;

    final List<FlSpot> spots = candles
        .map((candle) => FlSpot(candle.timestamp.toDouble(), candle.close))
        .toList(growable: false);

    final double minClose = candles.map((candle) => candle.close).reduce(min);
    final double maxClose = candles.map((candle) => candle.close).reduce(max);
    final double difference = maxClose - minClose;

    final double verticalPadding = difference == 0
        ? maxClose.abs() * .01
        : difference * .08;

    final double safePadding = verticalPadding == 0 ? 1.0 : verticalPadding;
    final double minX = spots.first.x;
    final double maxX = spots.last.x;
    final double minY = minClose - safePadding;
    final double maxY = maxClose + safePadding;

    final double horizontalInterval = max((maxX - minX) / 3, 1).toDouble();
    final double verticalInterval = (maxY - minY) / 6;

    final Locale locale = Localizations.localeOf(context);
    final NumberFormat compactNumber = NumberFormat.compact(
      locale: locale.toLanguageTag(),
    );

    final DateFormat dateFormat = range == PairChartRange.day
        ? DateFormat.Hm(locale.toLanguageTag())
        : DateFormat('dd-MM', locale.toLanguageTag());

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 24, 20, 12),
        child: LineChart(
          LineChartData(
            minX: minX,
            maxX: maxX,
            minY: minY,
            maxY: maxY,
            baselineX: minX,
            baselineY: minY,
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              drawVerticalLine: false,
              horizontalInterval: verticalInterval,
              getDrawingHorizontalLine: (_) => FlLine(
                color: context.colors.textSecondary.withValues(alpha: .16),
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: verticalInterval,
                  reservedSize: 54,
                  maxIncluded: true,
                  getTitlesWidget: (value, meta) => SideTitleWidget(
                    meta: meta,
                    child: Text(
                      compactNumber.format(value),
                      maxLines: 1,
                      style: context.bodySmall?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: horizontalInterval,
                  reservedSize: 30,
                  minIncluded: true,
                  maxIncluded: true,
                  getTitlesWidget: (value, meta) => SideTitleWidget(
                    meta: meta,
                    child: Text(
                      dateFormat.format(
                        DateTime.fromMillisecondsSinceEpoch(
                          value.toInt() * Duration.millisecondsPerSecond,
                          isUtc: true,
                        ).toLocal(),
                      ),
                      style: context.bodySmall?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            lineTouchData: LineTouchData(
              handleBuiltInTouches: true,
              touchCallback: (event, response) {
                final touchedSpots = response?.lineBarSpots;
                if (!event.isInterestedForInteractions ||
                    touchedSpots == null ||
                    touchedSpots.isEmpty) {
                  onCandleSelected(null);
                  return;
                }
                onCandleSelected(touchedSpots.first.spotIndex);
              },
              touchTooltipData: LineTouchTooltipData(
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                getTooltipColor: (_) => context.colors.background,
                getTooltipItems: (touchedSpots) => touchedSpots
                    .map(
                      (spot) => LineTooltipItem(
                        spot.y.formatDecimal(locale, maximumFractionDigits: 4),
                        context.labelLarge ?? const TextStyle(),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                color: lineColor,
                barWidth: 2,
                isCurved: true,
                preventCurveOverShooting: true,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      lineColor.withValues(alpha: .24),
                      lineColor.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }
}
