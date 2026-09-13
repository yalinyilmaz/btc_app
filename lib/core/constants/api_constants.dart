abstract final class ApiConstants {
  static const restBaseUrl = 'https://api.btcturk.com';
  static const graphBaseUrl = 'https://graph-api.btcturk.com';
  static const tickerPath = '/api/v2/ticker';
  static const klinePath = '/v1/klines/history';

  static const klineSuccessStatus = 'ok';
  static const klineNoDataStatus = 'no_data';
  static const defaultKlineResolution = 60;
  static const defaultKlineRange = Duration(days: 7);

  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 15);
}
