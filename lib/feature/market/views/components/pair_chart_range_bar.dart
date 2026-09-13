import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:btc_app/app/localization/locale_keys.g.dart';
import 'package:btc_app/core/extensions/build_context_extensions.dart';
import 'package:btc_app/feature/market/cubit/pair_chart_state.dart';

class PairChartRangeBar extends StatelessWidget {
  final PairChartRange selectedRange;
  final ValueChanged<PairChartRange> onSelected;

  const PairChartRangeBar({
    super.key,
    required this.selectedRange,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surface.withValues(alpha: 0.28),
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Expanded(
              child: _RangeButton(
                range: PairChartRange.day,
                isSelected: selectedRange == PairChartRange.day,
                onTap: onSelected,
              ),
            ),
            Expanded(
              child: _RangeButton(
                range: PairChartRange.week,
                isSelected: selectedRange == PairChartRange.week,
                onTap: onSelected,
              ),
            ),
            Expanded(
              child: _RangeButton(
                range: PairChartRange.month,
                isSelected: selectedRange == PairChartRange.month,
                onTap: onSelected,
              ),
            ),
            Expanded(
              child: _RangeButton(
                range: PairChartRange.threeMonths,
                isSelected: selectedRange == PairChartRange.threeMonths,
                onTap: onSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RangeButton extends StatelessWidget {
  final PairChartRange range;
  final bool isSelected;
  final ValueChanged<PairChartRange> onTap;

  const _RangeButton({
    required this.range,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? context.colors.selectedSurface : null,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onTap(range),
        child: Center(
          child: Text(
            context.tr(_labelKey),
            style: context.labelLarge?.copyWith(
              color: isSelected
                  ? context.colors.textPrimary
                  : context.colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  String get _labelKey => switch (range) {
    PairChartRange.day => LocaleKeys.market_chart_ranges_day,
    PairChartRange.week => LocaleKeys.market_chart_ranges_week,
    PairChartRange.month => LocaleKeys.market_chart_ranges_month,
    PairChartRange.threeMonths => LocaleKeys.market_chart_ranges_threeMonths,
  };
}
