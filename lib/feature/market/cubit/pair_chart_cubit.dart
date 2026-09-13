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

  Future<void> load() async {
    if (state.status == PairChartStatus.loading) {
      return;
    }

    emit(state.copyWith(status: PairChartStatus.loading));

    final to = now.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;
    final from = to - ApiConstants.defaultKlineRange.inSeconds;

    try {
      final candles = await repository.getKlines(
        pairSymbol: pairSymbol,
        resolution: ApiConstants.defaultKlineResolution,
        from: from,
        to: to,
      );
      emit(state.copyWith(status: PairChartStatus.success, candles: candles));
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
}
