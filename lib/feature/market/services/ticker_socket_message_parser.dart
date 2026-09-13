import 'dart:convert';

import 'package:btc_app/core/constants/api_constants.dart';
import 'package:btc_app/feature/market/models/ticker_socket_update.dart';

abstract final class TickerSocketMessageParser {
  static List<TickerSocketUpdate> parse(Object? message) {
    try {
      final decoded = message is String ? jsonDecode(message) : message;
      if (decoded is! List || decoded.length < 2) {
        return const [];
      }

      final type = (decoded.first as num?)?.toInt();
      final payload = decoded[1];
      if (payload is! Map) {
        return const [];
      }

      final json = Map<String, dynamic>.from(payload);
      return switch (type) {
        ApiConstants.socketTickerAllType => _parseItems(json['items']),
        ApiConstants.socketTickerPairType => _parseItems([json]),
        _ => const [],
      };
    } catch (_) {
      return const [];
    }
  }

  static List<TickerSocketUpdate> _parseItems(Object? items) {
    if (items is! List) {
      return const [];
    }

    return items
        .whereType<Map>()
        .map(Map<String, dynamic>.from)
        .map(_tryParse)
        .whereType<TickerSocketUpdate>()
        .toList(growable: false);
  }

  static TickerSocketUpdate? _tryParse(Map<String, dynamic> json) {
    try {
      return TickerSocketUpdate.fromJson(json);
    } catch (_) {
      return null;
    }
  }
}
