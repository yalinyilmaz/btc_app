import 'package:equatable/equatable.dart';

class FavoritePairsState extends Equatable {
  final Set<String> symbols;

  const FavoritePairsState({this.symbols = const {}});

  bool contains(String pairSymbol) => symbols.contains(pairSymbol);

  @override
  List<Object> get props => [symbols];
}
