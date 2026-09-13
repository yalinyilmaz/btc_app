import 'package:btc_app/feature/market/models/kline_candle.dart';
import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/models/ticker_socket_update.dart';

abstract interface class MarketRepository {
  Future<List<TickerModel>> getTickers({bool refresh = false});

  Future<List<KlineCandle>> getKlines({
    required String pairSymbol,
    required int resolution,
    required int from,
    required int to,
  });

  Stream<List<TickerSocketUpdate>> watchTickerUpdates();

  Future<void> closeTickerUpdates();
}
