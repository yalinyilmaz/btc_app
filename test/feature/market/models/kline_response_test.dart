import 'package:flutter_test/flutter_test.dart';

import 'package:btc_app/feature/market/models/kline_response.dart';

void main() {
  test('parses the graph API response', () {
    final response = KlineResponse.fromJson({
      's': 'ok',
      't': [1, 2],
      'h': [12, 22],
      'o': [9, 19],
      'l': [8, 18],
      'c': [10, 20],
      'v': [1, 2],
    });

    expect(response.status, 'ok');
    expect(response.timestamps, [1, 2]);
    expect(response.closes, [10, 20]);
  });

  test('defaults omitted arrays for a no-data response', () {
    final response = KlineResponse.fromJson({'s': 'no_data'});

    expect(response.status, 'no_data');
    expect(response.timestamps, isEmpty);
    expect(response.closes, isEmpty);
  });
}
