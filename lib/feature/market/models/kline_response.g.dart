// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kline_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KlineResponse _$KlineResponseFromJson(Map<String, dynamic> json) =>
    KlineResponse(
      status: json['s'] as String,
      timestamps:
          (json['t'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      highs:
          (json['h'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      opens:
          (json['o'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      lows:
          (json['l'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      closes:
          (json['c'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      volumes:
          (json['v'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
    );
