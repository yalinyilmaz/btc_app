import 'package:btc_app/app/localization/locale_keys.g.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';

extension MarketFailureX on MarketFailure {
  String get messageKey => switch (this) {
    MarketFailure.connection => LocaleKeys.market_errors_connection,
    MarketFailure.server => LocaleKeys.market_errors_server,
    MarketFailure.unexpected => LocaleKeys.market_errors_unexpected,
  };
}
