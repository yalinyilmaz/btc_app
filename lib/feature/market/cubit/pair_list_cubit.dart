import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:btc_app/feature/market/cubit/pair_list_state.dart';
import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/repo/btcturk_market_repository.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';

class PairListCubit extends Cubit<PairListState> {
  final BtcTurkMarketRepository repository;

  PairListCubit({required this.repository}) : super(const PairListState());

  Future<void> load({bool refresh = false}) async {
    if (state.status == PairListStatus.loading) {
      return;
    }

    if (!refresh) {
      emit(state.copyWith(status: PairListStatus.loading));
    }

    try {
      final List<TickerModel> allPairs = await repository.getTickers(
        refresh: refresh,
      );
      final List<TickerModel> pairs = _filterPairs(
        allPairs,
        state.filter,
        state.searchQuery,
      );

      emit(
        state.copyWith(
          status: PairListStatus.success,
          allPairs: allPairs,
          filteredPairs: pairs,
        ),
      );
    } on MarketRepositoryException catch (error) {
      emit(
        state.copyWith(
          status: PairListStatus.failure,
          failure: error.failure,
          errorMessage: error.serverMessage,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: PairListStatus.failure,
          failure: MarketFailure.unexpected,
        ),
      );
    }
  }

  void searchPairs(String query) {
    if (query == state.searchQuery) {
      return;
    }

    emit(
      state.copyWith(
        searchQuery: query,
        filteredPairs: _filterPairs(state.allPairs, state.filter, query),
      ),
    );
  }

  void clearSearch() {
    searchPairs('');
  }

  void selectFilter(PairFilterType filter) {
    if (filter == state.filter) {
      return;
    }

    emit(
      state.copyWith(
        filter: filter,
        filteredPairs: _filterPairs(state.allPairs, filter, state.searchQuery),
      ),
    );
  }

  List<TickerModel> _filterPairs(
    List<TickerModel> pairs,
    PairFilterType filter,
    String query,
  ) {
    final String searchText = query.trim().replaceAll(' ', '').toUpperCase();

    return pairs
        .where((pair) {
          return filter.includes(pair) &&
              pair.pair.toUpperCase().contains(searchText);
        })
        .toList(growable: false);
  }
}
