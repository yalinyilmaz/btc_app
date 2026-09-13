import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
          padding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
          child: Row(
            children: [
              FavoritePairButton(pairSymbol: ticker.pair),
              const SizedBox(width: 8),
              _PairName(
                numerator: ticker.numeratorSymbol,
                denominator: ticker.denominatorSymbol,
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: _PairMarketValues(
                  price: ticker.last.formatDecimal(context.locale),
                  change: ticker.dailyPercent.formatPercent(context.locale),
                  volume: ticker.volume.floor().formatDecimal(context.locale),
                  coinSymbol: ticker.numeratorSymbol,
                  changeColor: changeColor,
                ),
              ),
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
    return Center(
      child: Text(
        '$numerator/$denominator',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: context.titleMedium,
      ),
    );
  }
}

class _PairMarketValues extends StatelessWidget {
  final String price;
  final String change;
  final String volume;
  final String coinSymbol;
  final Color changeColor;

  const _PairMarketValues({
    required this.price,
    required this.change,
    required this.volume,
    required this.coinSymbol,
    required this.changeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                price,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.titleMedium,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: changeColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                change,
                maxLines: 1,
                style: context.labelLarge?.copyWith(
                  color: context.colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                volume,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              coinSymbol,
              style: context.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
