import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:btc_app/core/constants/api_constants.dart';
import 'package:btc_app/feature/market/cubit/pair_chart_cubit.dart';
import 'package:btc_app/feature/market/cubit/pair_chart_state.dart';
import 'package:btc_app/feature/market/models/kline_candle.dart';
import 'package:btc_app/feature/market/repo/btcturk_market_repository.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';

class _MockBtcTurkMarketRepository extends Mock
    implements BtcTurkMarketRepository {}

void main() {
  late BtcTurkMarketRepository repository;

  const candle = KlineCandle(
    timestamp: 2_000_000_000,
    high: 12,
    open: 9,
    low: 8,
    close: 10,
    volume: 1,
  );
  final now = DateTime.fromMillisecondsSinceEpoch(
    2_000_000_000_000,
    isUtc: true,
  );
  const to = 2_000_000_000;
  final from = to - ApiConstants.defaultKlineRange.inSeconds;

  setUp(() {
    repository = _MockBtcTurkMarketRepository();
  });

  blocTest<PairChartCubit, PairChartState>(
    'loads the default chart range',
    setUp: () {
      when(
        () => repository.getKlines(
          pairSymbol: 'BTCTRY',
          resolution: ApiConstants.defaultKlineResolution,
          from: from,
          to: to,
        ),
      ).thenAnswer((_) async => const [candle]);
    },
    build: () =>
        PairChartCubit(repository: repository, pairSymbol: 'BTCTRY', now: now),
    act: (cubit) => cubit.load(),
    expect: () => const [
      PairChartState(status: PairChartStatus.loading),
      PairChartState(status: PairChartStatus.success, candles: [candle]),
    ],
    verify: (_) {
      verify(
        () => repository.getKlines(
          pairSymbol: 'BTCTRY',
          resolution: ApiConstants.defaultKlineResolution,
          from: from,
          to: to,
        ),
      ).called(1);
    },
  );

  blocTest<PairChartCubit, PairChartState>(
    'maps repository failures to chart state',
    setUp: () {
      when(
        () => repository.getKlines(
          pairSymbol: 'BTCTRY',
          resolution: ApiConstants.defaultKlineResolution,
          from: from,
          to: to,
        ),
      ).thenThrow(const MarketRepositoryException(MarketFailure.connection));
    },
    build: () =>
        PairChartCubit(repository: repository, pairSymbol: 'BTCTRY', now: now),
    act: (cubit) => cubit.load(),
    expect: () => const [
      PairChartState(status: PairChartStatus.loading),
      PairChartState(
        status: PairChartStatus.failure,
        failure: MarketFailure.connection,
      ),
    ],
  );
}
