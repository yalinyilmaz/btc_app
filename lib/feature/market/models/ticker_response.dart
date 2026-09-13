import 'package:json_annotation/json_annotation.dart';

import 'package:btc_app/feature/market/models/ticker_model.dart';

part 'ticker_response.g.dart';

@JsonSerializable(createToJson: false)
class TickerResponse {
  final List<TickerModel> data;
  final bool success;
  final String? message;
  final int code;

  const TickerResponse({
    required this.data,
    required this.success,
    required this.message,
    required this.code,
  });

  factory TickerResponse.fromJson(Map<String, dynamic> json) =>
      _$TickerResponseFromJson(json);
}
