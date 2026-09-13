// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticker_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TickerModel _$TickerModelFromJson(Map<String, dynamic> json) => TickerModel(
  pair: json['pair'] as String,
  pairNormalized: json['pairNormalized'] as String,
  timestamp: (json['timestamp'] as num).toInt(),
  last: (json['last'] as num).toDouble(),
  high: (json['high'] as num).toDouble(),
  low: (json['low'] as num).toDouble(),
  bid: (json['bid'] as num).toDouble(),
  ask: (json['ask'] as num).toDouble(),
  open: (json['open'] as num).toDouble(),
  volume: (json['volume'] as num).toDouble(),
  average: (json['average'] as num).toDouble(),
  daily: (json['daily'] as num).toDouble(),
  dailyPercent: (json['dailyPercent'] as num).toDouble(),
  denominatorSymbol: json['denominatorSymbol'] as String,
  numeratorSymbol: json['numeratorSymbol'] as String,
  order: (json['order'] as num?)?.toInt() ?? 0,
);
