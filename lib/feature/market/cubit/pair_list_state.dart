import 'package:equatable/equatable.dart';

import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';

enum PairListStatus { initial, loading, success, failure }

enum RealtimeStatus { idle, connecting, connected, disconnected }

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
  final List<TickerModel> allPairs;
  final List<TickerModel> filteredPairs;
  final MarketFailure? failure;
  final String? errorMessage;
  final RealtimeStatus realtimeStatus;
  final PairFilterType filter;
  final String searchQuery;

  const PairListState({
    this.status = PairListStatus.initial,
    this.allPairs = const [],
    this.filteredPairs = const [],
    this.failure,
    this.errorMessage,
    this.realtimeStatus = RealtimeStatus.idle,
    this.filter = PairFilterType.tryMarket,
    this.searchQuery = '',
  });

  PairListState copyWith({
    PairListStatus? status,
    List<TickerModel>? allPairs,
    List<TickerModel>? filteredPairs,
    MarketFailure? failure,
    String? errorMessage,
    RealtimeStatus? realtimeStatus,
    PairFilterType? filter,
    String? searchQuery,
  }) {
    return PairListState(
      status: status ?? this.status,
      allPairs: allPairs ?? this.allPairs,
      filteredPairs: filteredPairs ?? this.filteredPairs,
      failure: failure,
      errorMessage: errorMessage,
      realtimeStatus: realtimeStatus ?? this.realtimeStatus,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allPairs,
    filteredPairs,
    failure,
    errorMessage,
    realtimeStatus,
    filter,
    searchQuery,
  ];
}
