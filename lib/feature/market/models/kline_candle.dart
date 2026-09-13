import 'package:equatable/equatable.dart';

class KlineCandle extends Equatable {
  final int timestamp;
  final double high;
  final double open;
  final double low;
  final double close;
  final double volume;

  const KlineCandle({
    required this.timestamp,
    required this.high,
    required this.open,
    required this.low,
    required this.close,
    required this.volume,
  });

  DateTime get dateTime =>
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  @override
  List<Object> get props => [timestamp, high, open, low, close, volume];
}
