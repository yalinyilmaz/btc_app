import 'package:flutter_test/flutter_test.dart';

import 'package:btc_app/feature/market/models/kline_candle.dart';

void main() {
  test('converts the Unix timestamp from UTC to the device time zone', () {
    const timestamp = 2_000_000_000;
    const candle = KlineCandle(
      timestamp: timestamp,
      high: 12,
      open: 9,
      low: 8,
      close: 10,
      volume: 1,
    );

    final expected = DateTime.fromMillisecondsSinceEpoch(
      timestamp * Duration.millisecondsPerSecond,
      isUtc: true,
    ).toLocal();

    expect(candle.dateTime, expected);
    expect(candle.dateTime.isUtc, isFalse);
  });
}
