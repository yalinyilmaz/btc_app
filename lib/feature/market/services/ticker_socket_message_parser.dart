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

      final type = decoded.first;
      final payload = decoded[1];
      if (type is! num || payload is! Map) {
        return const [];
      }

      final json = Map<String, dynamic>.from(payload);
      if (type.toInt() == ApiConstants.socketTickerAllType) {
        return _parseItems(json['items']);
      }

      return const [];
    } catch (_) {
      return const [];
    }
  }

  static List<TickerSocketUpdate> _parseItems(Object? items) {
    if (items is! List) {
      return const [];
    }

    final List<TickerSocketUpdate> updates = [];
    for (final item in items) {
      if (item is! Map) {
        continue;
      }

      try {
        updates.add(
          TickerSocketUpdate.fromJson(Map<String, dynamic>.from(item)),
        );
      } catch (_) {
        continue;
      }
    }

    return updates;
  }
}

// Example message:

// [
//   401,
//   {
//     "type": 401,
//     "items": [
//       {
//         "PS": "BTCTRY",
//         "H": "48710",
//         "L": "47000",
//         "La": "47500",
//         "V": "304.41",
//         "AV": "47850.41",
//         "D": "-318",
//         "DS": "TRY",
//         "NS": "BTC",
//         "PID": 1,
//         "O": 47988,
//         "B": "47472",
//         "A": "47670",
//         "BA": "0.125",
//         "AA": "0.240",
//         "DP": "-1.02"
//       },
//       {
//         "PS": "ETHTRY",
//         "H": "105000",
//         "L": "99000",
//         "La": "102500",
//         "V": "825.74",
//         "AV": "101250.30",
//         "D": "1500",
//         "DS": "TRY",
//         "NS": "ETH",
//         "PID": 2,
//         "O": 101000,
//         "B": "102450",
//         "A": "102550",
//         "BA": "1.42",
//         "AA": "0.85",
//         "DP": "1.48"
//       }
//     ]
//   }
// ]
