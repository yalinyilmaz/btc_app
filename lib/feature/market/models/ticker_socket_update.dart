import 'package:equatable/equatable.dart';

import 'package:btc_app/feature/market/models/ticker_model.dart';

class TickerSocketUpdate extends Equatable {
  final String pair;
  final double high;
  final double low;
  final double last;
  final double volume;
  final double average;
  final double daily;
  final String denominatorSymbol;
  final String numeratorSymbol;
  final double open;
  final double bid;
  final double ask;
  final double dailyPercent;

  const TickerSocketUpdate({
    required this.pair,
    required this.high,
    required this.low,
    required this.last,
    required this.volume,
    required this.average,
    required this.daily,
    required this.denominatorSymbol,
    required this.numeratorSymbol,
    required this.open,
    required this.bid,
    required this.ask,
    required this.dailyPercent,
  });

  factory TickerSocketUpdate.fromJson(Map<String, dynamic> json) {
    return TickerSocketUpdate(
      pair: json['PS'] as String,
      high: _toDouble(json['H']),
      low: _toDouble(json['L']),
      last: _toDouble(json['LA'] ?? json['La']),
      volume: _toDouble(json['V']),
      average: _toDouble(json['AV']),
      daily: _toDouble(json['D']),
      denominatorSymbol: json['DS'] as String,
      numeratorSymbol: json['NS'] as String,
      open: _toDouble(json['O']),
      bid: _toDouble(json['B']),
      ask: _toDouble(json['A']),
      dailyPercent: _toDouble(json['DP']),
    );
  }

  TickerModel applyTo(TickerModel ticker, {required int timestamp}) {
    if (ticker.pair != pair) {
      return ticker;
    }

    return ticker.copyWith(
      timestamp: timestamp,
      high: high,
      low: low,
      last: last,
      volume: volume,
      average: average,
      daily: daily,
      denominatorSymbol: denominatorSymbol,
      numeratorSymbol: numeratorSymbol,
      open: open,
      bid: bid,
      ask: ask,
      dailyPercent: dailyPercent,
    );
  }

  static double _toDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.parse(value);
    }
    throw const FormatException();
  }

  @override
  List<Object> get props => [
    pair,
    high,
    low,
    last,
    volume,
    average,
    daily,
    denominatorSymbol,
    numeratorSymbol,
    open,
    bid,
    ask,
    dailyPercent,
  ];
}
