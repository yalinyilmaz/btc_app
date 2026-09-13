import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:btc_app/app/localization/locale_keys.g.dart';
import 'package:btc_app/core/extensions/build_context_extensions.dart';
import 'package:btc_app/core/extensions/num_extensions.dart';
import 'package:btc_app/feature/market/models/kline_candle.dart';

class PairChartDetails extends StatelessWidget {
  final KlineCandle candle;
  final bool isSelected;

  const PairChartDetails({
    super.key,
    required this.candle,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.toLanguageTag();
    final date = DateFormat.yMMMd(locale).add_Hm().format(candle.dateTime);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr(LocaleKeys.market_chart_range),
              style: context.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.tr(
                isSelected
                    ? LocaleKeys.market_chart_selectedPoint
                    : LocaleKeys.market_chart_latestPoint,
              ),
              style: context.titleMedium,
            ),
            const SizedBox(height: 12),
            _DetailRow(
              label: context.tr(LocaleKeys.market_chart_time),
              value: date,
            ),
            const SizedBox(height: 8),
            _DetailRow(
              label: context.tr(LocaleKeys.market_chart_close),
              value: candle.close.formatDecimal(context.locale),
            ),
            const SizedBox(height: 12),
            Text(
              context.tr(LocaleKeys.market_chart_interactionHint),
              style: context.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: context.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: context.labelLarge,
          ),
        ),
      ],
    );
  }
}
