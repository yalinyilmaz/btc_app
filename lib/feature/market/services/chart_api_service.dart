import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:btc_app/core/constants/api_constants.dart';
import 'package:btc_app/feature/market/models/kline_response.dart';

part 'chart_api_service.g.dart';

@RestApi()
abstract class ChartApiService {
  factory ChartApiService(Dio dio) = _ChartApiService;

  @GET(ApiConstants.klinePath)
  Future<KlineResponse> getKlines({
    @Query('symbol') required String symbol,
    @Query('resolution') required int resolution,
    @Query('from') required int from,
    @Query('to') required int to,
  });
}
