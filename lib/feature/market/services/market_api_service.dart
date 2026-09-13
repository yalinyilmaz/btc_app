import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:btc_app/core/constants/api_constants.dart';
import 'package:btc_app/feature/market/models/ticker_response.dart';

part 'market_api_service.g.dart';

@RestApi()
abstract class MarketApiService {
  factory MarketApiService(Dio dio) = _MarketApiService;

  @GET(ApiConstants.tickerPath)
  Future<TickerResponse> getTickers();
}
