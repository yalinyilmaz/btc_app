import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:btc_app/app/localization/locale_keys.g.dart';
import 'package:btc_app/core/extensions/build_context_extensions.dart';
import 'package:btc_app/core/extensions/num_extensions.dart';
import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/views/components/favorite_pair_button.dart';

class PairTile extends StatelessWidget {
  final TickerModel ticker;
  final VoidCallback onTap;

  const PairTile({super.key, required this.ticker, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final changeColor = ticker.dailyPercent < 0
        ? context.colors.negative
        : context.colors.positive;

    return Material(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _PairName(
                  numerator: ticker.numeratorSymbol,
                  denominator: ticker.denominatorSymbol,
                ),
              ),
              Expanded(
                child: _PairValue(
                  label: context.tr(LocaleKeys.market_pairs_price),
                  value: ticker.last.formatDecimal(context.locale),
                  suffix: ticker.denominatorSymbol,
                ),
              ),
              Expanded(
                child: _PairValue(
                  label: context.tr(LocaleKeys.market_pairs_change24h),
                  value: ticker.dailyPercent.formatPercent(context.locale),
                  valueColor: changeColor,
                  textAlign: TextAlign.end,
                ),
              ),
              FavoritePairButton(pairSymbol: ticker.pair),
            ],
          ),
        ),
      ),
    );
  }
}

class _PairName extends StatelessWidget {
  final String numerator;
  final String denominator;

  const _PairName({required this.numerator, required this.denominator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(numerator, style: context.titleMedium),
        const SizedBox(height: 4),
        Text(
          denominator,
          style: context.bodySmall?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _PairValue extends StatelessWidget {
  final String label;
  final String value;
  final String? suffix;
  final Color? valueColor;
  final TextAlign textAlign;

  const _PairValue({
    required this.label,
    required this.value,
    this.suffix,
    this.valueColor,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: textAlign == TextAlign.end
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          style: context.bodySmall?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: textAlign == TextAlign.end
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.labelLarge?.copyWith(color: valueColor),
              ),
            ),
            if (suffix != null) ...[
              const SizedBox(width: 4),
              Text(
                suffix!,
                style: context.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
