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
}
