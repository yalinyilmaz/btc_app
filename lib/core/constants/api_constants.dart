abstract final class ApiConstants {
  static const restBaseUrl = 'https://api.btcturk.com';
  static const graphBaseUrl = 'https://graph-api.btcturk.com';
  static const tickerPath = '/api/v2/ticker';
  static const klinePath = '/v1/klines/history';
  static const tickerSocketUrl = 'wss://ws-feed-pro.btcturk.com/';

  static const klineSuccessStatus = 'ok';
  static const klineNoDataStatus = 'no_data';
  static const defaultKlineResolution = 60;
  static const defaultKlineRange = Duration(days: 7);

  static const socketSubscriptionType = 151;
  static const socketTickerAllType = 401;
  static const socketTickerPairType = 402;
  static const socketTickerChannel = 'ticker';
  static const socketAllEvent = 'all';

  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 15);
  static const socketReconnectDelay = Duration(seconds: 3);
}
