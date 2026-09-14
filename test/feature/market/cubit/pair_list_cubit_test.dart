import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:btc_app/feature/market/cubit/pair_list_cubit.dart';
import 'package:btc_app/feature/market/cubit/pair_list_state.dart';
import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/models/ticker_socket_update.dart';
import 'package:btc_app/feature/market/repo/btcturk_market_repository.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';

import '../ticker_fixture.dart';

class _MockBtcTurkMarketRepository extends Mock
    implements BtcTurkMarketRepository {}

void main() {
  late BtcTurkMarketRepository repository;
  late StreamController<List<TickerSocketUpdate>> tickerController;
  final btcTry = tickerFixture(
    pair: 'BTCTRY',
  ).copyWith(pairNormalized: 'BTC_TRY', denominatorSymbol: 'TRY');
  final ethTry = tickerFixture(pair: 'ETHTRY', order: 2).copyWith(
    pairNormalized: 'ETH_TRY',
    denominatorSymbol: 'TRY',
    numeratorSymbol: 'ETH',
  );
  final btcUsdt = tickerFixture(order: 3);
  late List<TickerModel> allPairs;

  void stubTickers() {
    when(() => repository.getTickers()).thenAnswer((_) async => allPairs);
  }

  setUp(() {
    repository = _MockBtcTurkMarketRepository();
    tickerController = StreamController<List<TickerSocketUpdate>>.broadcast();
    when(
      () => repository.watchTickerUpdates(),
    ).thenAnswer((_) => tickerController.stream);
    when(() => repository.closeTickerUpdates()).thenAnswer((_) async {});
    allPairs = [btcTry, ethTry, btcUsdt];
  });

  tearDown(() => tickerController.close());

  blocTest<PairListCubit, PairListState>(
    'loads the complete ticker snapshot',
    setUp: stubTickers,
    build: () => PairListCubit(repository: repository),
    act: (cubit) => cubit.load(),
    expect: () => [
      const PairListState(status: PairListStatus.loading),
      PairListState(
        status: PairListStatus.success,
        allPairs: allPairs,
        filteredPairs: [btcTry, ethTry],
        realtimeStatus: RealtimeStatus.connecting,
      ),
    ],
    verify: (_) {
      verify(() => repository.getTickers()).called(1);
    },
  );

  blocTest<PairListCubit, PairListState>(
    'emits the typed failure returned by the repository',
    setUp: () {
      when(
        () => repository.getTickers(),
      ).thenThrow(const MarketRepositoryException(MarketFailure.connection));
    },
    build: () => PairListCubit(repository: repository),
    act: (cubit) => cubit.load(),
    expect: () => const [
      PairListState(status: PairListStatus.loading),
      PairListState(
        status: PairListStatus.failure,
        failure: MarketFailure.connection,
      ),
    ],
  );

  blocTest<PairListCubit, PairListState>(
    'refreshes the ticker snapshot without replacing the content with loading',
    setUp: () {
      when(
        () => repository.getTickers(refresh: true),
      ).thenAnswer((_) async => allPairs);
    },
    seed: () => PairListState(
      status: PairListStatus.success,
      allPairs: [btcTry],
      filteredPairs: [btcTry],
    ),
    build: () => PairListCubit(repository: repository),
    act: (cubit) => cubit.load(refresh: true),
    expect: () => [
      PairListState(
        status: PairListStatus.success,
        allPairs: allPairs,
        filteredPairs: [btcTry, ethTry],
        realtimeStatus: RealtimeStatus.connecting,
      ),
    ],
    verify: (_) {
      verify(() => repository.getTickers(refresh: true)).called(1);
    },
  );

  blocTest<PairListCubit, PairListState>(
    'emits the filtered pairs when the selected market changes',
    setUp: stubTickers,
    build: () => PairListCubit(repository: repository),
    act: (cubit) async {
      await cubit.load();
      cubit.selectFilter(PairFilterType.usdt);
    },
    expect: () => [
      const PairListState(status: PairListStatus.loading),
      PairListState(
        status: PairListStatus.success,
        allPairs: allPairs,
        filteredPairs: [btcTry, ethTry],
        realtimeStatus: RealtimeStatus.connecting,
      ),
      PairListState(
        status: PairListStatus.success,
        allPairs: allPairs,
        filteredPairs: [btcUsdt],
        realtimeStatus: RealtimeStatus.connecting,
        filter: PairFilterType.usdt,
      ),
    ],
  );

  blocTest<PairListCubit, PairListState>(
    'merges socket updates into the matching ticker',
    setUp: stubTickers,
    build: () => PairListCubit(repository: repository),
    act: (cubit) async {
      await cubit.load();
      tickerController.add([tickerSocketUpdateFixture(last: 200)]);
      await Future<void>.delayed(const Duration(milliseconds: 10));
    },
    expect: () => [
      const PairListState(status: PairListStatus.loading),
      PairListState(
        status: PairListStatus.success,
        allPairs: allPairs,
        filteredPairs: [btcTry, ethTry],
        realtimeStatus: RealtimeStatus.connecting,
      ),
      isA<PairListState>()
          .having(
            (state) => state.realtimeStatus,
            'realtimeStatus',
            RealtimeStatus.connected,
          )
          .having(
            (state) => state.allPairs
                .firstWhere((pair) => pair.pair == 'BTCUSDT')
                .last,
            'last',
            200,
          ),
    ],
  );

  blocTest<PairListCubit, PairListState>(
    'emits searched pairs and restores them when search is cleared',
    setUp: stubTickers,
    build: () => PairListCubit(repository: repository),
    act: (cubit) async {
      await cubit.load();
      cubit.searchPairs('eth');
      cubit.clearSearch();
    },
    expect: () => [
      const PairListState(status: PairListStatus.loading),
      PairListState(
        status: PairListStatus.success,
        allPairs: allPairs,
        filteredPairs: [btcTry, ethTry],
        realtimeStatus: RealtimeStatus.connecting,
      ),
      PairListState(
        status: PairListStatus.success,
        allPairs: allPairs,
        filteredPairs: [ethTry],
        realtimeStatus: RealtimeStatus.connecting,
        searchQuery: 'eth',
      ),
      PairListState(
        status: PairListStatus.success,
        allPairs: allPairs,
        filteredPairs: [btcTry, ethTry],
        realtimeStatus: RealtimeStatus.connecting,
      ),
    ],
  );

  test('filters pairs by denominator symbol', () {
    final usdtPair = tickerFixture();
    final tryPair = tickerFixture().copyWith(denominatorSymbol: 'TRY');

    expect(PairFilterType.tryMarket.includes(tryPair), isTrue);
    expect(PairFilterType.tryMarket.includes(usdtPair), isFalse);
    expect(PairFilterType.usdt.includes(usdtPair), isTrue);
    expect(PairFilterType.all.includes(tryPair), isTrue);
    expect(PairFilterType.all.includes(usdtPair), isTrue);
  });
}
