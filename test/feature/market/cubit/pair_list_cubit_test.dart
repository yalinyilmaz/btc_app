import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:btc_app/feature/market/cubit/pair_list_cubit.dart';
import 'package:btc_app/feature/market/cubit/pair_list_state.dart';
import 'package:btc_app/feature/market/repo/btcturk_market_repository.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';

import '../ticker_fixture.dart';

class _MockBtcTurkMarketRepository extends Mock
    implements BtcTurkMarketRepository {}

void main() {
  late BtcTurkMarketRepository repository;

  void stubTickers() {
    when(
      () => repository.getTickers(),
    ).thenAnswer((_) async => [tickerFixture()]);
  }

  setUp(() {
    repository = _MockBtcTurkMarketRepository();
  });

  blocTest<PairListCubit, PairListState>(
    'loads the complete ticker snapshot',
    setUp: stubTickers,
    build: () => PairListCubit(repository: repository),
    act: (cubit) => cubit.load(),
    expect: () => [
      const PairListState(status: PairListStatus.loading),
      PairListState(status: PairListStatus.success, pairs: [tickerFixture()]),
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
    'changes the selected pair filter',
    build: () => PairListCubit(repository: repository),
    act: (cubit) => cubit.selectFilter(PairFilterType.usdt),
    expect: () => const [PairListState(filter: PairFilterType.usdt)],
  );

  blocTest<PairListCubit, PairListState>(
    'updates and clears the pair search',
    build: () => PairListCubit(repository: repository),
    act: (cubit) {
      cubit.searchPairs('btc');
      cubit.clearSearch();
    },
    expect: () => const [PairListState(searchQuery: 'btc'), PairListState()],
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
