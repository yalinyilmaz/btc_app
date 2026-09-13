import 'package:json_annotation/json_annotation.dart';

part 'kline_response.g.dart';

@JsonSerializable(createToJson: false)
class KlineResponse {
  @JsonKey(name: 's')
  final String status;
  @JsonKey(name: 't', defaultValue: [])
  final List<int> timestamps;
  @JsonKey(name: 'h', defaultValue: [])
  final List<double> highs;
  @JsonKey(name: 'o', defaultValue: [])
  final List<double> opens;
  @JsonKey(name: 'l', defaultValue: [])
  final List<double> lows;
  @JsonKey(name: 'c', defaultValue: [])
  final List<double> closes;
  @JsonKey(name: 'v', defaultValue: [])
  final List<double> volumes;

  const KlineResponse({
    required this.status,
    required this.timestamps,
    required this.highs,
    required this.opens,
    required this.lows,
    required this.closes,
    required this.volumes,
  });

  factory KlineResponse.fromJson(Map<String, dynamic> json) =>
      _$KlineResponseFromJson(json);
}
