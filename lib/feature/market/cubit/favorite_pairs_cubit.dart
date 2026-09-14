import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:btc_app/feature/market/cubit/favorite_pairs_state.dart';

class FavoritePairsCubit extends HydratedCubit<FavoritePairsState> {
  static const _schemaVersion = 1;
  static const _versionKey = 'version';
  static const _symbolsKey = 'symbols';

  FavoritePairsCubit({super.storage}) : super(const FavoritePairsState());

  void toggle(String pairSymbol) {
    final normalizedSymbol = pairSymbol.trim().toUpperCase();
    if (normalizedSymbol.isEmpty) {
      return;
    }

    final Set<String> symbols = {...state.symbols};
    if (!symbols.add(normalizedSymbol)) {
      symbols.remove(normalizedSymbol);
    }

    emit(FavoritePairsState(symbols: Set.unmodifiable(symbols)));
  }

  @override
  FavoritePairsState? fromJson(Map<String, dynamic> json) {
    if (json[_versionKey] != _schemaVersion) {
      return const FavoritePairsState();
    }

    final storedSymbols = json[_symbolsKey];
    if (storedSymbols is! List) {
      return const FavoritePairsState();
    }

    final Set<String> symbols = storedSymbols
        .whereType<String>()
        .map((symbol) => symbol.trim().toUpperCase())
        .where((symbol) => symbol.isNotEmpty)
        .toSet();

    return FavoritePairsState(symbols: Set.unmodifiable(symbols));
  }

  @override
  Map<String, dynamic> toJson(FavoritePairsState state) {
    return {
      _versionKey: _schemaVersion,
      _symbolsKey: state.symbols.toList(growable: false)..sort(),
    };
  }

  @override
  String get storagePrefix => 'favorite_pairs_cubit';
}
