import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/models/ticker_socket_update.dart';

TickerModel tickerFixture({String pair = 'BTCUSDT', int order = 1}) {
  return TickerModel(
    pair: pair,
    pairNormalized: 'BTC_USDT',
    timestamp: 1,
    last: 100,
    high: 110,
    low: 90,
    bid: 99,
    ask: 101,
    open: 95,
    volume: 10,
    average: 98,
    daily: 5,
    dailyPercent: 5.26,
    denominatorSymbol: 'USDT',
    numeratorSymbol: 'BTC',
    order: order,
  );
}

TickerSocketUpdate tickerSocketUpdateFixture({
  String pair = 'BTCUSDT',
  double last = 200,
}) {
  return TickerSocketUpdate(
    pair: pair,
    high: 210,
    low: 90,
    last: last,
    volume: 20,
    average: 150,
    daily: 100,
    denominatorSymbol: 'USDT',
    numeratorSymbol: 'BTC',
    open: 100,
    bid: 199,
    ask: 201,
    dailyPercent: 100,
  );
}
