import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:btc_app/core/extensions/build_context_extensions.dart';
import 'package:btc_app/core/extensions/num_extensions.dart';
import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/views/components/favorite_pair_button.dart';

class FavoritePairCard extends StatelessWidget {
  final TickerModel ticker;
  final VoidCallback onTap;

  const FavoritePairCard({
    super.key,
    required this.ticker,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final changeColor = ticker.dailyPercent < 0
        ? context.colors.negative
        : context.colors.positive;
    final pairName = '${ticker.numeratorSymbol}/${ticker.denominatorSymbol}';

    return Material(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 12, 8),
          child: Row(
            children: [
              FavoritePairButton(pairSymbol: ticker.pair),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pairName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ticker.last.formatDecimal(context.locale),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ticker.dailyPercent.formatPercent(context.locale),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.titleMedium?.copyWith(color: changeColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
