import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:btc_app/app/localization/locale_keys.g.dart';
import 'package:btc_app/feature/market/cubit/pair_list_cubit.dart';
import 'package:btc_app/feature/market/cubit/pair_list_state.dart';
import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/views/components/favorite_pairs_section.dart';
import 'package:btc_app/feature/market/views/components/pair_collection.dart';
import 'package:btc_app/feature/market/views/components/pair_filter_bar.dart';
import 'package:btc_app/feature/market/views/components/pair_search_bar.dart';

class PairListView extends StatelessWidget {
  final List<TickerModel> allPairs;
  final void Function(String pairSymbol) onPairTap;

  const PairListView({
    super.key,
    required this.allPairs,
    required this.onPairTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FavoritePairsSection(pairs: allPairs, onPairTap: onPairTap),
        PairSearchBar(
          onChanged: context.read<PairListCubit>().searchPairs,
          onClear: context.read<PairListCubit>().clearSearch,
        ),
        BlocSelector<PairListCubit, PairListState, PairFilterType>(
          selector: (state) => state.filter,
          builder: (context, filter) {
            return PairFilterBar(
              selectedFilter: filter,
              onSelected: context.read<PairListCubit>().selectFilter,
            );
          },
        ),
        Expanded(
          child: BlocSelector<PairListCubit, PairListState, List<TickerModel>>(
            selector: (state) => state.filteredPairs,
            builder: (context, pairs) {
              if (pairs.isEmpty) {
                return Center(
                  child: Text(context.tr(LocaleKeys.market_pairs_empty)),
                );
              }

              return PairCollection(pairs: pairs, onPairTap: onPairTap);
            },
          ),
        ),
      ],
    );
  }
}
