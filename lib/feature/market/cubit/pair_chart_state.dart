import 'package:equatable/equatable.dart';

import 'package:btc_app/feature/market/models/kline_candle.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';

enum PairChartStatus { initial, loading, success, failure }

class PairChartState extends Equatable {
  final PairChartStatus status;
  final List<KlineCandle> candles;
  final MarketFailure? failure;

  const PairChartState({
    this.status = PairChartStatus.initial,
    this.candles = const [],
    this.failure,
  });

  PairChartState copyWith({
    PairChartStatus? status,
    List<KlineCandle>? candles,
    MarketFailure? failure,
  }) {
    return PairChartState(
      status: status ?? this.status,
      candles: candles ?? this.candles,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, candles, failure];
}
