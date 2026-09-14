import 'package:btc_app/feature/market/models/kline_candle.dart';
import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:btc_app/core/constants/api_constants.dart';
import 'package:btc_app/feature/market/cubit/pair_chart_state.dart';
import 'package:btc_app/feature/market/repo/btcturk_market_repository.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';

class PairChartCubit extends Cubit<PairChartState> {
  final BtcTurkMarketRepository repository;
  final String pairSymbol;
  final DateTime now;

  PairChartCubit({
    required this.repository,
    required this.pairSymbol,
    DateTime? now,
  }) : now = now ?? DateTime.now(),
       super(const PairChartState());

  Future<void> load({PairChartRange? range}) async {
    if (state.status == PairChartStatus.loading) {
      return;
    }

    final PairChartRange selectedRange = range ?? state.range;
    final int resolution = selectedRange == PairChartRange.day
        ? ApiConstants.minuteKlineResolution
        : ApiConstants.defaultKlineResolution;

    emit(state.copyWith(status: PairChartStatus.loading, range: selectedRange));

    final int to = now.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;
    final int from = to - selectedRange.duration.inSeconds;

    try {
      final TickerModel? selectedTicker = await repository.getTicker(
        pairSymbol,
      );
      final List<KlineCandle> candles = await repository.getKlines(
        pairSymbol: pairSymbol,
        resolution: resolution,
        from: from,
        to: to,
      );
      emit(
        state.copyWith(
          status: PairChartStatus.success,
          candles: candles,
          selectedTicker: selectedTicker,
        ),
      );
    } on MarketRepositoryException catch (error) {
      emit(
        state.copyWith(status: PairChartStatus.failure, failure: error.failure),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: PairChartStatus.failure,
          failure: MarketFailure.unexpected,
        ),
      );
    }
  }

  Future<void> selectRange(PairChartRange range) async {
    if (range == state.range) {
      return;
    }

    await load(range: range);
  }
}
