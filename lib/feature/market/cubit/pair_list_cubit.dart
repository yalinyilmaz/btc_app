import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:btc_app/core/constants/api_constants.dart';
import 'package:btc_app/feature/market/cubit/pair_list_state.dart';
import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/models/ticker_socket_update.dart';
import 'package:btc_app/feature/market/repo/market_repository.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';

class PairListCubit extends Cubit<PairListState> {
  final MarketRepository repository;

  StreamSubscription<List<TickerSocketUpdate>>? _tickerSubscription;
  Timer? _reconnectTimer;
  bool _isClosing = false;

  PairListCubit({required this.repository}) : super(const PairListState());

  Future<void> load({bool refresh = false}) async {
    if (state.status == PairListStatus.loading) {
      return;
    }

    emit(state.copyWith(status: PairListStatus.loading));

    try {
      final pairs = await repository.getTickers(refresh: refresh);
      emit(
        state.copyWith(
          status: PairListStatus.success,
          pairs: pairs,
          realtimeStatus: RealtimeStatus.connecting,
        ),
      );
      await _startTickerUpdates();
    } on MarketRepositoryException catch (error) {
      emit(
        state.copyWith(
          status: PairListStatus.failure,
          failure: error.failure,
          errorMessage: error.serverMessage,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: PairListStatus.failure,
          failure: MarketFailure.unexpected,
        ),
      );
    }
  }

  Future<void> _startTickerUpdates() async {
    _reconnectTimer?.cancel();
    await _tickerSubscription?.cancel();

    if (isClosed || state.status != PairListStatus.success) {
      return;
    }

    emit(state.copyWith(realtimeStatus: RealtimeStatus.connecting));

    try {
      _tickerSubscription = repository.watchTickerUpdates().listen(
        _applyTickerUpdates,
        onError: (_, _) => _handleTickerDisconnect(),
        onDone: _handleTickerDisconnect,
      );
    } catch (_) {
      _handleTickerDisconnect();
    }
  }

  void _applyTickerUpdates(List<TickerSocketUpdate> updates) {
    if (isClosed || updates.isEmpty) {
      return;
    }

    final updatesByPair = {for (final update in updates) update.pair: update};
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final pairs = _applyUpdates(state.pairs, updatesByPair, timestamp);

    emit(
      state.copyWith(pairs: pairs, realtimeStatus: RealtimeStatus.connected),
    );
  }

  List<TickerModel>? _applyUpdates(
    List<TickerModel> tickers,
    Map<String, TickerSocketUpdate> updatesByPair,
    int timestamp,
  ) {
    var hasChanges = false;
    final updatedTickers = tickers
        .map((ticker) {
          final update = updatesByPair[ticker.pair];
          if (update == null) {
            return ticker;
          }

          hasChanges = true;
          return update.applyTo(ticker, timestamp: timestamp);
        })
        .toList(growable: false);

    return hasChanges ? List.unmodifiable(updatedTickers) : null;
  }

  void _handleTickerDisconnect() {
    if (_isClosing || isClosed || state.status != PairListStatus.success) {
      return;
    }

    emit(state.copyWith(realtimeStatus: RealtimeStatus.disconnected));
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(
      ApiConstants.socketReconnectDelay,
      () => unawaited(_startTickerUpdates()),
    );
  }

  @override
  Future<void> close() async {
    _isClosing = true;
    _reconnectTimer?.cancel();
    await _tickerSubscription?.cancel();
    await repository.closeTickerUpdates();
    return super.close();
  }
}
