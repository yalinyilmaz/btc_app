import 'package:equatable/equatable.dart';

import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';

enum PairListStatus { initial, loading, success, failure }

enum RealtimeStatus { idle, connecting, connected, disconnected }

class PairListState extends Equatable {
  final PairListStatus status;
  final List<TickerModel> pairs;
  final MarketFailure? failure;
  final String? errorMessage;
  final RealtimeStatus realtimeStatus;

  const PairListState({
    this.status = PairListStatus.initial,
    this.pairs = const [],
    this.failure,
    this.errorMessage,
    this.realtimeStatus = RealtimeStatus.idle,
  });

  PairListState copyWith({
    PairListStatus? status,
    List<TickerModel>? pairs,
    MarketFailure? failure,
    String? errorMessage,
    RealtimeStatus? realtimeStatus,
  }) {
    return PairListState(
      status: status ?? this.status,
      pairs: pairs ?? this.pairs,
      failure: failure,
      errorMessage: errorMessage,
      realtimeStatus: realtimeStatus ?? this.realtimeStatus,
    );
  }

  @override
  List<Object?> get props => [
    status,
    pairs,
    failure,
    errorMessage,
    realtimeStatus,
  ];
}
