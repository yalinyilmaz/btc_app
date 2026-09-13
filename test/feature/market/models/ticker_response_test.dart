import 'package:flutter_test/flutter_test.dart';

import 'package:btc_app/feature/market/models/ticker_response.dart';

void main() {
  test('parses the complete BtcTurk response envelope', () {
    final response = TickerResponse.fromJson({
      'data': [
        {
          'pair': 'BTCTRY',
          'pairNormalized': 'BTC_TRY',
          'timestamp': 1570024156166,
          'last': 47500,
          'high': 48710,
          'low': 47000,
          'bid': 47472,
          'ask': 47670,
          'open': 47988,
          'volume': 304.41,
          'average': 47850.41,
          'daily': -318,
          'dailyPercent': -1.02,
          'denominatorSymbol': 'TRY',
          'numeratorSymbol': 'BTC',
        },
      ],
      'success': true,
      'message': null,
      'code': 0,
    });

    expect(response.success, isTrue);
    expect(response.message, isNull);
    expect(response.code, 0);
    expect(response.data.single.pair, 'BTCTRY');
    expect(response.data.single.order, 0);
  });
}
