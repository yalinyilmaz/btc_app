import 'dart:convert';

import 'package:web_socket_channel/status.dart' as socket_status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:btc_app/core/constants/api_constants.dart';
import 'package:btc_app/feature/market/models/ticker_socket_update.dart';
import 'package:btc_app/feature/market/services/market_socket_service.dart';
import 'package:btc_app/feature/market/services/ticker_socket_message_parser.dart';

typedef SocketChannelFactory = WebSocketChannel Function(Uri uri);

class BtcTurkMarketSocketService implements MarketSocketService {
  final SocketChannelFactory channelFactory;

  WebSocketChannel? _channel;

  BtcTurkMarketSocketService({SocketChannelFactory? channelFactory})
    : channelFactory =
          channelFactory ?? ((uri) => WebSocketChannel.connect(uri));

  @override
  Stream<List<TickerSocketUpdate>> watchTickers() async* {
    await close();

    final channel = channelFactory(Uri.parse(ApiConstants.tickerSocketUrl));
    _channel = channel;
    await channel.ready;
    channel.sink.add(jsonEncode(_tickerSubscription));

    try {
      await for (final message in channel.stream) {
        final updates = TickerSocketMessageParser.parse(message);
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

  @override
  Future<void> close() async {
    final channel = _channel;
    _channel = null;
    await channel?.sink.close(socket_status.normalClosure);
  }

  static const _tickerSubscription = [
    ApiConstants.socketSubscriptionType,
    {
      'type': ApiConstants.socketSubscriptionType,
      'channel': ApiConstants.socketTickerChannel,
      'event': ApiConstants.socketAllEvent,
      'join': true,
    },
  ];
}
