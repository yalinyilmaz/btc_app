import 'package:equatable/equatable.dart';

import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';

enum PairListStatus { initial, loading, success, failure }

class PairListState extends Equatable {
  final PairListStatus status;
  final List<TickerModel> pairs;
  final MarketFailure? failure;
  final String? errorMessage;

  const PairListState({
    this.status = PairListStatus.initial,
    this.pairs = const [],
    this.failure,
    this.errorMessage,
  });

  PairListState copyWith({
    PairListStatus? status,
    List<TickerModel>? pairs,
    MarketFailure? failure,
    String? errorMessage,
  }) {
    return PairListState(
      status: status ?? this.status,
      pairs: pairs ?? this.pairs,
      failure: failure,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, pairs, failure, errorMessage];
}
