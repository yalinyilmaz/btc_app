import 'dart:convert';

import 'package:web_socket_channel/status.dart' as socket_status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:btc_app/core/constants/api_constants.dart';
import 'package:btc_app/feature/market/models/ticker_socket_update.dart';
import 'package:btc_app/feature/market/services/ticker_socket_message_parser.dart';

class BtcTurkMarketSocketService {
  WebSocketChannel? _channel;

  Stream<List<TickerSocketUpdate>> watchTickers() async* {
    await close();

    final channel = WebSocketChannel.connect(
      Uri.parse(ApiConstants.tickerSocketUrl),
    );
    _channel = channel;

    try {
      await channel.ready;
      channel.sink.add(jsonEncode(_subscriptionMessage));

      await for (final message in channel.stream) {
        final List<TickerSocketUpdate> updates = TickerSocketMessageParser.parse(message);
        if (updates.isNotEmpty) {
          yield updates;
        }
      }
    } finally {
      if (identical(_channel, channel)) {
        _channel = null;
        await channel.sink.close(socket_status.normalClosure);
      }
    }
  }

  Future<void> close() async {
    final channel = _channel;
    _channel = null;
    await channel?.sink.close(socket_status.normalClosure);
  }

  static const _subscriptionMessage = [
    ApiConstants.socketSubscriptionType,
    {
      'type': ApiConstants.socketSubscriptionType,
      'channel': ApiConstants.socketTickerChannel,
      'event': ApiConstants.socketAllEvent,
      'join': true,
    },
  ];
}
