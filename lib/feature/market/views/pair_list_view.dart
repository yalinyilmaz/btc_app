import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:btc_app/app/components/app_error_view.dart';
import 'package:btc_app/app/localization/locale_keys.g.dart';
import 'package:btc_app/feature/market/cubit/pair_list_cubit.dart';
import 'package:btc_app/feature/market/cubit/pair_list_state.dart';
import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';
import 'package:btc_app/feature/market/views/components/favorite_pairs_section.dart';
import 'package:btc_app/feature/market/views/components/pair_collection.dart';
import 'package:btc_app/feature/market/views/components/pair_filter_bar.dart';
import 'package:btc_app/feature/market/views/components/pair_search_bar.dart';

typedef _PairListViewData = ({
  PairListStatus status,
  List<TickerModel> pairs,
  MarketFailure? failure,
  String? errorMessage,
  PairFilterType filter,
  String searchQuery,
});

class PairListView extends StatelessWidget {
  final void Function(String pairSymbol) onPairTap;

  const PairListView({super.key, required this.onPairTap});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PairListCubit, PairListState, _PairListViewData>(
      selector: (state) => (
        status: state.status,
        pairs: state.pairs,
        failure: state.failure,
        errorMessage: state.errorMessage,
        filter: state.filter,
        searchQuery: state.searchQuery,
      ),
      builder: (context, data) {
        return switch (data.status) {
          PairListStatus.initial || PairListStatus.loading => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          PairListStatus.success => _buildContent(
            context,
            data.pairs,
            data.filter,
            data.searchQuery,
          ),
          PairListStatus.failure => AppErrorView(
            displayMessage: _displayMessage(context, data),
            onRetry: () => context.read<PairListCubit>().load(refresh: true),
          ),
        };
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<TickerModel> pairs,
    PairFilterType filter,
    String searchQuery,
  ) {
    if (pairs.isEmpty) {
      return Center(child: Text(context.tr(LocaleKeys.market_pairs_empty)));
    }

    final filteredPairs = _filterPairs(pairs, filter, searchQuery);

    return Column(
      children: [
        FavoritePairsSection(pairs: pairs, onPairTap: onPairTap),
        PairSearchBar(
          query: searchQuery,
          onChanged: context.read<PairListCubit>().searchPairs,
          onClear: context.read<PairListCubit>().clearSearch,
        ),
        PairFilterBar(
          selectedFilter: filter,
          onSelected: context.read<PairListCubit>().selectFilter,
        ),
        Expanded(
          child: filteredPairs.isEmpty
              ? Center(child: Text(context.tr(LocaleKeys.market_pairs_empty)))
              : PairCollection(pairs: filteredPairs, onPairTap: onPairTap),
        ),
      ],
    );
  }

  List<TickerModel> _filterPairs(
    List<TickerModel> pairs,
    PairFilterType filter,
    String query,
  ) {
    final searchText = query
        .trim()
        .toUpperCase()
        .replaceAll('/', '')
        .replaceAll('_', '')
        .replaceAll(' ', '');

    return pairs
        .where((pair) {
          if (!filter.includes(pair)) {
            return false;
          }
          if (searchText.isEmpty) {
            return true;
          }

          return pair.pair.toUpperCase().contains(searchText) ||
              pair.numeratorSymbol.toUpperCase().contains(searchText) ||
              pair.denominatorSymbol.toUpperCase().contains(searchText);
        })
        .toList(growable: false);
  }

  String _displayMessage(BuildContext context, _PairListViewData data) {
    final backendMessage = data.errorMessage?.trim();
    if (backendMessage != null && backendMessage.isNotEmpty) {
      return backendMessage;
    }

    return context.tr((data.failure ?? MarketFailure.unexpected).messageKey);
  }
}
