import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:btc_app/app/localization/locale_keys.g.dart';
import 'package:btc_app/core/extensions/build_context_extensions.dart';
import 'package:btc_app/feature/market/cubit/favorite_pairs_cubit.dart';
import 'package:btc_app/feature/market/cubit/favorite_pairs_state.dart';

class FavoritePairButton extends StatelessWidget {
  final String pairSymbol;

  const FavoritePairButton({super.key, required this.pairSymbol});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FavoritePairsCubit, FavoritePairsState, bool>(
      selector: (state) => state.contains(pairSymbol),
      builder: (context, isFavorite) {
        return IconButton(
          onPressed: () {
            context.read<FavoritePairsCubit>().toggle(pairSymbol);
          },
          tooltip: context.tr(
            isFavorite
                ? LocaleKeys.market_favorites_remove
                : LocaleKeys.market_favorites_add,
          ),
          icon: Icon(
            isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
            color: isFavorite
                ? context.colors.positive
                : context.colors.textSecondary,
          ),
        );
      },
    );
  }
}
