import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:btc_app/feature/market/models/ticker_response.dart';
import 'package:btc_app/feature/market/models/kline_response.dart';
import 'package:btc_app/feature/market/repo/btcturk_market_repository.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';
import 'package:btc_app/feature/market/services/chart_api_service.dart';
import 'package:btc_app/feature/market/services/market_api_service.dart';
import 'package:btc_app/feature/market/services/market_socket_service.dart';

import '../ticker_fixture.dart';

class _MockMarketApiService extends Mock implements MarketApiService {}

class _MockChartApiService extends Mock implements ChartApiService {}

class _MockMarketSocketService extends Mock implements MarketSocketService {}

void main() {
  late MarketApiService apiService;
  late ChartApiService chartApiService;
  late MarketSocketService socketService;
  late BtcTurkMarketRepository repository;

  setUp(() {
    apiService = _MockMarketApiService();
    chartApiService = _MockChartApiService();
    socketService = _MockMarketSocketService();
    repository = BtcTurkMarketRepository(
      apiService: apiService,
      chartApiService: chartApiService,
      socketService: socketService,
    );
  });

  test('returns tickers sorted by API order', () async {
    final second = tickerFixture(pair: 'ETHUSDT', order: 2);
    final first = tickerFixture(order: 1);
    when(() => apiService.getTickers()).thenAnswer(
      (_) async => TickerResponse(
        data: [second, first],
        success: true,
        message: null,
        code: 0,
      ),
    );

    final result = await repository.getTickers(refresh: true);

    expect(result, [first, second]);
  });

  test('maps Dio connection errors to a typed failure', () async {
    when(() => apiService.getTickers()).thenThrow(
      DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.connectionError,
      ),
    );

    expect(
      () => repository.getTickers(refresh: true),
      throwsA(
        isA<MarketRepositoryException>().having(
          (error) => error.failure,
          'failure',
          MarketFailure.connection,
        ),
      ),
    );
  });

  test('preserves backend message and code when success is false', () async {
    when(() => apiService.getTickers()).thenAnswer(
      (_) async => const TickerResponse(
        data: [],
        success: false,
        message: 'maintenance',
        code: 500,
      ),
    );

    expect(
      () => repository.getTickers(refresh: true),
      throwsA(
        isA<MarketRepositoryException>()
            .having((error) => error.failure, 'failure', MarketFailure.server)
            .having(
              (error) => error.serverMessage,
              'serverMessage',
              'maintenance',
            )
            .having((error) => error.code, 'code', 500),
      ),
    );
  });

  test(
    'serves subsequent ticker requests from the cached API snapshot',
    () async {
      final first = tickerFixture(order: 1);
      final second = tickerFixture(pair: 'ETHUSDT', order: 2);
      final third = tickerFixture(pair: 'XRPUSDT', order: 3);
      when(() => apiService.getTickers()).thenAnswer(
        (_) async => TickerResponse(
          data: [first, second, third],
          success: true,
          message: null,
          code: 0,
        ),
      );

      final freshTickers = await repository.getTickers(refresh: true);
      final cachedTickers = await repository.getTickers();

      expect(freshTickers, [first, second, third]);
      expect(cachedTickers, same(freshTickers));
      verify(() => apiService.getTickers()).called(1);
    },
  );

  test('maps parallel kline arrays to sorted candles', () async {
    when(
      () => chartApiService.getKlines(
        symbol: 'BTCTRY',
        resolution: 60,
        from: 100,
        to: 200,
      ),
    ).thenAnswer(
      (_) async => const KlineResponse(
        status: 'ok',
        timestamps: [200, 100],
        highs: [22, 12],
        opens: [19, 9],
        lows: [18, 8],
        closes: [20, 10],
        volumes: [2, 1],
      ),
    );

    final result = await repository.getKlines(
      pairSymbol: 'BTCTRY',
      resolution: 60,
      from: 100,
      to: 200,
    );

    expect(result.map((candle) => candle.timestamp), [100, 200]);
    expect(result.map((candle) => candle.close), [10, 20]);
  });

  test('safely truncates inconsistent kline arrays', () async {
    when(
      () => chartApiService.getKlines(
        symbol: 'BTCTRY',
        resolution: 60,
        from: 100,
        to: 200,
      ),
    ).thenAnswer(
      (_) async => const KlineResponse(
        status: 'ok',
        timestamps: [100, 200],
        highs: [12],
        opens: [9, 19],
        lows: [8, 18],
        closes: [10, 20],
        volumes: [1, 2],
      ),
    );

    final result = await repository.getKlines(
      pairSymbol: 'BTCTRY',
      resolution: 60,
      from: 100,
      to: 200,
    );

    expect(result, hasLength(1));
    expect(result.single.timestamp, 100);
  });

  test('rejects unsuccessful kline status', () async {
    when(
      () => chartApiService.getKlines(
        symbol: 'BTCTRY',
        resolution: 60,
        from: 100,
        to: 200,
      ),
    ).thenAnswer(
      (_) async => const KlineResponse(
        status: 'error',
        timestamps: [],
        highs: [],
        opens: [],
        lows: [],
        closes: [],
        volumes: [],
      ),
    );

    expect(
      () => repository.getKlines(
        pairSymbol: 'BTCTRY',
        resolution: 60,
        from: 100,
        to: 200,
      ),
      throwsA(
        isA<MarketRepositoryException>().having(
          (error) => error.failure,
          'failure',
          MarketFailure.server,
        ),
      ),
    );
  });

  test('returns an empty list for a no-data kline status', () async {
    when(
      () => chartApiService.getKlines(
        symbol: 'BTCTRY',
        resolution: 60,
        from: 100,
        to: 200,
      ),
    ).thenAnswer(
      (_) async => const KlineResponse(
        status: 'no_data',
        timestamps: [],
        highs: [],
        opens: [],
        lows: [],
        closes: [],
        volumes: [],
      ),
    );

    final result = await repository.getKlines(
      pairSymbol: 'BTCTRY',
      resolution: 60,
      from: 100,
      to: 200,
    );

    expect(result, isEmpty);
  });
}
