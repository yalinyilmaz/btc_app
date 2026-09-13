import 'dart:math';

import 'package:dio/dio.dart';

import 'package:btc_app/core/constants/api_constants.dart';
import 'package:btc_app/feature/market/models/kline_candle.dart';
import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';
import 'package:btc_app/feature/market/services/chart_api_service.dart';
import 'package:btc_app/feature/market/services/market_api_service.dart';

class BtcTurkMarketRepository {
  final MarketApiService apiService;
  final ChartApiService chartApiService;

  List<TickerModel>? _tickerCache;

  BtcTurkMarketRepository({
    required this.apiService,
    required this.chartApiService,
  });

  Future<List<TickerModel>> getTickers({bool refresh = false}) async {
    final cachedTickers = _tickerCache;
    if (!refresh && cachedTickers != null) {
      return cachedTickers;
    }

    return _fetchTickers();
  }

  Future<List<TickerModel>> _fetchTickers() async {
    try {
      final response = await apiService.getTickers();
      if (!response.success) {
        throw MarketRepositoryException(
          MarketFailure.server,
          serverMessage: response.message,
          code: response.code,
        );
      }

      final tickers = [...response.data]
        ..sort((first, second) => first.order.compareTo(second.order));

      return _tickerCache = List.unmodifiable(tickers);
    } on DioException catch (error) {
      throw MarketRepositoryException(_mapDioFailure(error.type));
    } on MarketRepositoryException {
      rethrow;
    } catch (_) {
      throw const MarketRepositoryException(MarketFailure.unexpected);
    }
  }

  Future<List<KlineCandle>> getKlines({
    required String pairSymbol,
    required int resolution,
    required int from,
    required int to,
  }) async {
    try {
      final response = await chartApiService.getKlines(
        symbol: pairSymbol,
        resolution: resolution,
        from: from,
        to: to,
      );
      if (response.status == ApiConstants.klineNoDataStatus) {
        return const [];
      }
      if (response.status != ApiConstants.klineSuccessStatus) {
        throw const MarketRepositoryException(MarketFailure.server);
      }

      final candleCount = [
        response.timestamps.length,
        response.highs.length,
        response.opens.length,
        response.lows.length,
        response.closes.length,
        response.volumes.length,
      ].reduce(min);

      final candles = List.generate(
        candleCount,
        (index) => KlineCandle(
          timestamp: response.timestamps[index],
          high: response.highs[index],
          open: response.opens[index],
          low: response.lows[index],
          close: response.closes[index],
          volume: response.volumes[index],
        ),
        growable: false,
      )..sort((first, second) => first.timestamp.compareTo(second.timestamp));

      return List.unmodifiable(candles);
    } on DioException catch (error) {
      throw MarketRepositoryException(_mapDioFailure(error.type));
    } on MarketRepositoryException {
      rethrow;
    } catch (_) {
      throw const MarketRepositoryException(MarketFailure.unexpected);
    }
  }

  MarketFailure _mapDioFailure(DioExceptionType type) {
    return switch (type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => MarketFailure.connection,
      DioExceptionType.badResponse => MarketFailure.server,
      _ => MarketFailure.unexpected,
    };
  }
}
