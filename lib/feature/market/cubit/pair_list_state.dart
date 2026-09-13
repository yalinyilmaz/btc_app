import 'package:equatable/equatable.dart';

import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';

enum PairListStatus { initial, loading, success, failure }

enum PairFilterType {
  tryMarket('TRY'),
  usdt('USDT'),
  all(null);

  final String? denominatorSymbol;

  const PairFilterType(this.denominatorSymbol);

  bool includes(TickerModel pair) {
    return denominatorSymbol == null ||
        pair.denominatorSymbol == denominatorSymbol;
  }
}

class PairListState extends Equatable {
  final PairListStatus status;
  final List<TickerModel> pairs;
  final MarketFailure? failure;
  final String? errorMessage;
  final PairFilterType filter;
  final String searchQuery;

  const PairListState({
    this.status = PairListStatus.initial,
    this.pairs = const [],
    this.failure,
    this.errorMessage,
    this.filter = PairFilterType.tryMarket,
    this.searchQuery = '',
  });

  PairListState copyWith({
    PairListStatus? status,
    List<TickerModel>? pairs,
    MarketFailure? failure,
    String? errorMessage,
    PairFilterType? filter,
    String? searchQuery,
  }) {
    return PairListState(
      status: status ?? this.status,
      pairs: pairs ?? this.pairs,
      failure: failure,
      errorMessage: errorMessage,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    status,
    pairs,
    failure,
    errorMessage,
    filter,
    searchQuery,
  ];
}
