import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:btc_app/app/components/app_page_body.dart';
import 'package:btc_app/app/localization/locale_keys.g.dart';
import 'package:btc_app/feature/market/cubit/pair_chart_cubit.dart';
import 'package:btc_app/feature/market/cubit/pair_list_cubit.dart';
import 'package:btc_app/feature/market/repo/btcturk_market_repository.dart';
import 'package:btc_app/feature/market/views/pair_chart_page.dart';
import 'package:btc_app/feature/market/views/pair_list_page.dart';

abstract final class AppRouteNames {
  static const pairList = '/';
  static const pairChart = '/chart/:pairSymbol';

  static String pairChartPath(String pairSymbol) {
    return '/chart/${Uri.encodeComponent(pairSymbol)}';
  }
}

final appRouter = GoRouter(
  initialLocation: AppRouteNames.pairList,
  routes: [
    GoRoute(
      path: AppRouteNames.pairList,
      builder: (context, state) {
        return BlocProvider(
          create: (_) =>
              PairListCubit(repository: context.read<BtcTurkMarketRepository>())
                ..load(),
          child: const PairListPage(),
        );
      },
    ),
    GoRoute(
      path: AppRouteNames.pairChart,
      builder: (context, state) {
        final pairSymbol = state.pathParameters['pairSymbol']!;
        return BlocProvider(
          create: (_) => PairChartCubit(
            repository: context.read<BtcTurkMarketRepository>(),
            pairSymbol: pairSymbol,
          )..load(),
          child: PairChartPage(pairSymbol: pairSymbol),
        );
      },
    ),
  ],
  errorBuilder: (context, state) {
    return Scaffold(
      body: AppPageBody(
        child: Center(child: Text(context.tr(LocaleKeys.common_pageNotFound))),
      ),
    );
  },
);
