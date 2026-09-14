import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:btc_app/feature/market/cubit/pair_list_cubit.dart';
import 'package:btc_app/feature/market/cubit/pair_list_state.dart';
import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/repo/btcturk_market_repository.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';

import '../ticker_fixture.dart';

class _MockBtcTurkMarketRepository extends Mock implements BtcTurkMarketRepository {}

void main() {
  late BtcTurkMarketRepository repository;
  final btcTry = tickerFixture(pair: 'BTCTRY').copyWith(pairNormalized: 'BTC_TRY', denominatorSymbol: 'TRY');
  final ethTry = tickerFixture(
    pair: 'ETHTRY',
    order: 2,
  ).copyWith(pairNormalized: 'ETH_TRY', denominatorSymbol: 'TRY', numeratorSymbol: 'ETH');
  final btcUsdt = tickerFixture(order: 3);
  late List<TickerModel> allPairs;

  void stubTickers() {
    when(() => repository.getTickers()).thenAnswer((_) async => allPairs);
  }

  setUp(() {
    repository = _MockBtcTurkMarketRepository();
    allPairs = [btcTry, ethTry, btcUsdt];
  });

  blocTest<PairListCubit, PairListState>(
    'loads the complete ticker snapshot',
    setUp: stubTickers,
    build: () => PairListCubit(repository: repository),
    act: (cubit) => cubit.load(),
    expect: () => [
      const PairListState(status: PairListStatus.loading),
      PairListState(status: PairListStatus.success, allPairs: allPairs, filteredPairs: [btcTry, ethTry]),
    ],
    verify: (_) {
      verify(() => repository.getTickers()).called(1);
    },
  );

  blocTest<PairListCubit, PairListState>(
    'emits the typed failure returned by the repository',
    setUp: () {
      when(() => repository.getTickers()).thenThrow(const MarketRepositoryException(MarketFailure.connection));
    },
    build: () => PairListCubit(repository: repository),
    act: (cubit) => cubit.load(),
    expect: () => const [
      PairListState(status: PairListStatus.loading),
      PairListState(status: PairListStatus.failure, failure: MarketFailure.connection),
    ],
  );

  blocTest<PairListCubit, PairListState>(
    'refreshes the ticker snapshot without replacing the content with loading',
    setUp: () {
      when(() => repository.getTickers(refresh: true)).thenAnswer((_) async => allPairs);
    },
    seed: () => PairListState(status: PairListStatus.success, allPairs: [btcTry], filteredPairs: [btcTry]),
    build: () => PairListCubit(repository: repository),
    act: (cubit) => cubit.load(refresh: true),
    expect: () => [
      PairListState(status: PairListStatus.success, allPairs: allPairs, filteredPairs: [btcTry, ethTry]),
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
      PairListState(status: PairListStatus.success, allPairs: allPairs, filteredPairs: [btcTry, ethTry]),
      PairListState(
        status: PairListStatus.success,
        allPairs: allPairs,
        filteredPairs: [btcUsdt],
        filter: PairFilterType.usdt,
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
      PairListState(status: PairListStatus.success, allPairs: allPairs, filteredPairs: [btcTry, ethTry]),
      PairListState(status: PairListStatus.success, allPairs: allPairs, filteredPairs: [ethTry], searchQuery: 'eth'),
      PairListState(status: PairListStatus.success, allPairs: allPairs, filteredPairs: [btcTry, ethTry]),
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
