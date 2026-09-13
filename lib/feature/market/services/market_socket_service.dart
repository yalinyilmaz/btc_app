import 'package:btc_app/feature/market/models/ticker_socket_update.dart';

abstract interface class MarketSocketService {
  Stream<List<TickerSocketUpdate>> watchTickers();

  Future<void> close();
}
