import 'package:equatable/equatable.dart';

import 'package:btc_app/feature/market/models/kline_candle.dart';
import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';

enum PairChartStatus { initial, loading, success, failure }

enum PairChartRange {
  day(Duration(days: 1)),
  week(Duration(days: 7)),
  month(Duration(days: 30)),
  threeMonths(Duration(days: 90));

  final Duration duration;

  const PairChartRange(this.duration);
}

class PairChartState extends Equatable {
  final PairChartStatus status;
  final PairChartRange range;
  final List<KlineCandle> candles;
  final TickerModel? selectedTicker;
  final MarketFailure? failure;

  const PairChartState({
    this.status = PairChartStatus.initial,
    this.range = PairChartRange.week,
    this.candles = const [],
    this.selectedTicker,
    this.failure,
  });

  PairChartState copyWith({
    PairChartStatus? status,
    PairChartRange? range,
    List<KlineCandle>? candles,
    TickerModel? selectedTicker,
    MarketFailure? failure,
  }) {
    return PairChartState(
      status: status ?? this.status,
      range: range ?? this.range,
      candles: candles ?? this.candles,
      selectedTicker: selectedTicker ?? this.selectedTicker,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, range, candles, selectedTicker, failure];
}
