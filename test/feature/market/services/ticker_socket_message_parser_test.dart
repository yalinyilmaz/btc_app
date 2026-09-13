import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:btc_app/feature/market/services/ticker_socket_message_parser.dart';

void main() {
  const tickerJson = {
    'PS': 'BTCTRY',
    'H': '48710',
    'L': '47000',
    'LA': '47500',
    'V': '304.41',
    'AV': '47850.41',
    'D': '-318',
    'DS': 'TRY',
    'NS': 'BTC',
    'O': 47988,
    'B': '47472',
    'A': '47670',
    'DP': '-1.02',
  };

  test('parses a ticker-all message', () {
    final message = jsonEncode([
      401,
      {
        'type': 401,
        'items': [tickerJson],
      },
    ]);

    final result = TickerSocketMessageParser.parse(message);

    expect(result, hasLength(1));
    expect(result.single.pair, 'BTCTRY');
    expect(result.single.last, 47500);
    expect(result.single.dailyPercent, -1.02);
  });

  test('parses a single-pair ticker message', () {
    final documentedTickerJson = {...tickerJson, 'La': '47500'}..remove('LA');
    final result = TickerSocketMessageParser.parse([402, documentedTickerJson]);

    expect(result, hasLength(1));
    expect(result.single.denominatorSymbol, 'TRY');
  });

  test('ignores unsupported and malformed messages', () {
    expect(TickerSocketMessageParser.parse([100, {}]), isEmpty);
    expect(TickerSocketMessageParser.parse('invalid'), isEmpty);
  });
}
