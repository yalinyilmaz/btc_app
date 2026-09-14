import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:btc_app/core/constants/api_constants.dart';
import 'package:btc_app/feature/market/cubit/pair_list_state.dart';
import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/models/ticker_socket_update.dart';
import 'package:btc_app/feature/market/repo/btcturk_market_repository.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';

class PairListCubit extends Cubit<PairListState> {
  final BtcTurkMarketRepository repository;

  StreamSubscription<List<TickerSocketUpdate>>? _tickerSubscription;
  Timer? _reconnectTimer;
  bool _isClosing = false;

  PairListCubit({required this.repository}) : super(const PairListState());

  Future<void> load({bool refresh = false}) async {
    if (state.status == PairListStatus.loading) {
      return;
    }

    if (!refresh) {
      emit(state.copyWith(status: PairListStatus.loading));
    }

    try {
      final List<TickerModel> allPairs = await repository.getTickers(
        refresh: refresh,
      );
      final List<TickerModel> pairs = _filterPairs(
        allPairs,
        state.filter,
        state.searchQuery,
      );

      emit(
        state.copyWith(
          status: PairListStatus.success,
          allPairs: allPairs,
          filteredPairs: pairs,
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

  void searchPairs(String query) {
    if (query == state.searchQuery) {
      return;
    }

    emit(
      state.copyWith(
        searchQuery: query,
        filteredPairs: _filterPairs(state.allPairs, state.filter, query),
      ),
    );
  }

  void clearSearch() {
    searchPairs('');
  }

  void selectFilter(PairFilterType filter) {
    if (filter == state.filter) {
      return;
    }

    emit(
      state.copyWith(
        filter: filter,
        filteredPairs: _filterPairs(state.allPairs, filter, state.searchQuery),
      ),
    );
  }

  List<TickerModel> _filterPairs(
    List<TickerModel> pairs,
    PairFilterType filter,
    String query,
  ) {
    final String searchText = query.trim().replaceAll(' ', '').toUpperCase();

    return pairs
        .where((pair) {
          return filter.includes(pair) &&
              pair.pair.toUpperCase().contains(searchText);
        })
        .toList(growable: false);
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
        onError: (_, _) {
          _handleTickerDisconnect();
        },
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

    final Map<String, TickerSocketUpdate> updatesByPair = {};
    for (final update in updates) {
      updatesByPair[update.pair] = update;
    }

    final int timestamp = DateTime.now().millisecondsSinceEpoch;

    final List<TickerModel> allPairs = _mergeTickerUpdates(
      state.allPairs,
      updatesByPair,
      timestamp,
    );

    final List<TickerModel> filteredPairs = _filterPairs(
      allPairs,
      state.filter,
      state.searchQuery,
    );

    emit(
      state.copyWith(
        allPairs: allPairs,
        filteredPairs: filteredPairs,
        realtimeStatus: RealtimeStatus.connected,
      ),
    );
  }

  List<TickerModel> _mergeTickerUpdates(
    List<TickerModel> tickers,
    Map<String, TickerSocketUpdate> updatesByPair,
    int timestamp,
  ) {
    final List<TickerModel> updatedTickers = tickers
        .map((ticker) {
          final TickerSocketUpdate? update = updatesByPair[ticker.pair];

          if (update == null) {
            return ticker;
          }

          return update.applyTo(ticker, timestamp: timestamp);
        })
        .toList(growable: false);

    return List.unmodifiable(updatedTickers);
  }

  void _handleTickerDisconnect() {
    if (_isClosing || isClosed || state.status != PairListStatus.success) {
      return;
    }

    emit(state.copyWith(realtimeStatus: RealtimeStatus.disconnected));
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(ApiConstants.socketReconnectDelay, () {
      unawaited(_startTickerUpdates());
    });
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
