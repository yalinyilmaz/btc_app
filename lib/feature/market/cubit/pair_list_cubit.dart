import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:btc_app/feature/market/cubit/pair_list_state.dart';
import 'package:btc_app/feature/market/repo/btcturk_market_repository.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';

class PairListCubit extends Cubit<PairListState> {
  final BtcTurkMarketRepository repository;

  PairListCubit({required this.repository}) : super(const PairListState());

  void searchPairs(String query) {
    if (query == state.searchQuery) {
      return;
    }

    emit(state.copyWith(searchQuery: query));
  }

  void clearSearch() {
    searchPairs('');
  }

  Future<void> load({bool refresh = false}) async {
    if (state.status == PairListStatus.loading) {
      return;
    }

    emit(state.copyWith(status: PairListStatus.loading));

    try {
      final pairs = await repository.getTickers(refresh: refresh);
      emit(state.copyWith(status: PairListStatus.success, pairs: pairs));
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

  void selectFilter(PairFilterType filter) {
    if (filter == state.filter) {
      return;
    }

    emit(state.copyWith(filter: filter));
  }
}
