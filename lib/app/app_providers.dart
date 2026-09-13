import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:btc_app/core/network/app_dio.dart';
import 'package:btc_app/core/constants/api_constants.dart';
import 'package:btc_app/feature/market/cubit/favorite_pairs_cubit.dart';
import 'package:btc_app/feature/market/repo/btcturk_market_repository.dart';
import 'package:btc_app/feature/market/repo/market_repository.dart';
import 'package:btc_app/feature/market/services/market_api_service.dart';
import 'package:btc_app/feature/market/services/chart_api_service.dart';
import 'package:btc_app/feature/market/services/btcturk_market_socket_service.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MarketRepository>(
          create: (_) {
            final apiService = MarketApiService(
              AppDio.create(baseUrl: ApiConstants.restBaseUrl),
            );
            final chartApiService = ChartApiService(
              AppDio.create(baseUrl: ApiConstants.graphBaseUrl),
            );
            final socketService = BtcTurkMarketSocketService();
            return BtcTurkMarketRepository(
              apiService: apiService,
              chartApiService: chartApiService,
              socketService: socketService,
            );
          },
        ),
      ],
      child: BlocProvider(create: (_) => FavoritePairsCubit(), child: child),
    );
  }
}
