import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ticker_model.g.dart';

@JsonSerializable(createToJson: false)
class TickerModel extends Equatable {
  final String pair;
  final String pairNormalized;
  final int timestamp;
  final double last;
  final double high;
  final double low;
  final double bid;
  final double ask;
  final double open;
  final double volume;
  final double average;
  final double daily;
  final double dailyPercent;
  final String denominatorSymbol;
  final String numeratorSymbol;
  @JsonKey(defaultValue: 0)
  final int order;

  const TickerModel({
    required this.pair,
    required this.pairNormalized,
    required this.timestamp,
    required this.last,
    required this.high,
    required this.low,
    required this.bid,
    required this.ask,
    required this.open,
    required this.volume,
    required this.average,
    required this.daily,
    required this.dailyPercent,
    required this.denominatorSymbol,
    required this.numeratorSymbol,
    required this.order,
  });

  factory TickerModel.fromJson(Map<String, dynamic> json) =>
      _$TickerModelFromJson(json);

  TickerModel copyWith({
    String? pair,
    String? pairNormalized,
    int? timestamp,
    double? last,
    double? high,
    double? low,
    double? bid,
    double? ask,
    double? open,
    double? volume,
    double? average,
    double? daily,
    double? dailyPercent,
    String? denominatorSymbol,
    String? numeratorSymbol,
    int? order,
  }) {
    return TickerModel(
      pair: pair ?? this.pair,
      pairNormalized: pairNormalized ?? this.pairNormalized,
      timestamp: timestamp ?? this.timestamp,
      last: last ?? this.last,
      high: high ?? this.high,
      low: low ?? this.low,
      bid: bid ?? this.bid,
      ask: ask ?? this.ask,
      open: open ?? this.open,
      volume: volume ?? this.volume,
      average: average ?? this.average,
      daily: daily ?? this.daily,
      dailyPercent: dailyPercent ?? this.dailyPercent,
      denominatorSymbol: denominatorSymbol ?? this.denominatorSymbol,
      numeratorSymbol: numeratorSymbol ?? this.numeratorSymbol,
      order: order ?? this.order,
    );
  }

  @override
  List<Object> get props => [
    pair,
    pairNormalized,
    timestamp,
    last,
    high,
    low,
    bid,
    ask,
    open,
    volume,
    average,
    daily,
    dailyPercent,
    denominatorSymbol,
    numeratorSymbol,
    order,
  ];
}
