import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:btc_app/app/localization/locale_keys.g.dart';
import 'package:btc_app/core/extensions/build_context_extensions.dart';
import 'package:btc_app/feature/market/cubit/favorite_pairs_cubit.dart';
import 'package:btc_app/feature/market/cubit/favorite_pairs_state.dart';
import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/views/components/favorite_pair_card.dart';

class FavoritePairsSection extends StatelessWidget {
  final List<TickerModel> pairs;
  final ValueChanged<String> onPairTap;

  const FavoritePairsSection({
    super.key,
    required this.pairs,
    required this.onPairTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FavoritePairsCubit, FavoritePairsState, Set<String>>(
      selector: (state) => state.symbols,
      builder: (context, favoriteSymbols) {
        final favoritePairs = pairs
            .where((ticker) => favoriteSymbols.contains(ticker.pair))
            .toList(growable: false);

        if (favoritePairs.isEmpty) {
          return const SizedBox.shrink();
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final widthFactor = context.isMobileLayout
                ? 0.40
                : context.isTabletLayout
                ? 0.28
                : 0.20;
            final cardWidth = (constraints.maxWidth * widthFactor)
                .clamp(160.0, 240.0)
                .toDouble();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  context.tr(LocaleKeys.market_favorites_title),
                  style: context.titleLarge,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 92,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(right: 16),
                    itemCount: favoritePairs.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final ticker = favoritePairs[index];
                      return SizedBox(
                        width: cardWidth,
                        child: FavoritePairCard(
                          ticker: ticker,
                          onTap: () => onPairTap(ticker.pair),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
              ],
            );
          },
        );
      },
    );
  }
}
