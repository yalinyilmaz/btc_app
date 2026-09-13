import 'package:btc_app/app/localization/locale_keys.g.dart';

enum MarketFailure {
  connection(LocaleKeys.market_errors_connection),
  server(LocaleKeys.market_errors_server),
  unexpected(LocaleKeys.market_errors_unexpected);

  const MarketFailure(this.messageKey);

  final String messageKey;
}

class MarketRepositoryException implements Exception {
  final MarketFailure failure;
  final String? serverMessage;
  final int? code;

  const MarketRepositoryException(
    this.failure, {
    this.serverMessage,
    this.code,
  });
}
