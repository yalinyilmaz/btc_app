import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:btc_app/feature/market/cubit/favorite_pairs_cubit.dart';
import 'package:btc_app/feature/market/cubit/favorite_pairs_state.dart';

class _MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  setUp(() {
    storage = _MockStorage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any())).thenAnswer((_) async {});
    when(() => storage.delete(any())).thenAnswer((_) async {});
    when(storage.clear).thenAnswer((_) async {});
    when(storage.close).thenAnswer((_) async {});
  });

  blocTest<FavoritePairsCubit, FavoritePairsState>(
    'adds and removes a normalized pair symbol',
    build: () => FavoritePairsCubit(storage: storage),
    act: (cubit) {
      cubit.toggle(' btctry ');
      cubit.toggle('BTCTRY');
    },
    expect: () => const [
      FavoritePairsState(symbols: {'BTCTRY'}),
      FavoritePairsState(),
    ],
  );

  test('restores symbols from versioned storage', () async {
    when(() => storage.read(any())).thenReturn({
      'version': 1,
      'symbols': ['btctry', 'ETHUSDT'],
    });

    final cubit = FavoritePairsCubit(storage: storage);

    expect(cubit.state.symbols, {'BTCTRY', 'ETHUSDT'});
    expect(cubit.storagePrefix, 'favorite_pairs_cubit');
    await cubit.close();
  });

  test('falls back to an empty state for an unknown schema', () async {
    when(() => storage.read(any())).thenReturn({
      'version': 2,
      'symbols': ['BTCTRY'],
    });

    final cubit = FavoritePairsCubit(storage: storage);

    expect(cubit.state, const FavoritePairsState());
    await cubit.close();
  });

  test('serializes only the schema version and sorted symbols', () async {
    final cubit = FavoritePairsCubit(storage: storage);

    final json = cubit.toJson(
      const FavoritePairsState(symbols: {'ETHUSDT', 'BTCTRY'}),
    );

    expect(json, {
      'version': 1,
      'symbols': ['BTCTRY', 'ETHUSDT'],
    });
    await cubit.close();
  });
}
