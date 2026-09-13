// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticker_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TickerResponse _$TickerResponseFromJson(Map<String, dynamic> json) =>
    TickerResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => TickerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      success: json['success'] as bool,
      message: json['message'] as String?,
      code: (json['code'] as num).toInt(),
    );
