import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:btc_app/app/components/app_error_view.dart';
import 'package:btc_app/app/localization/locale_keys.g.dart';
import 'package:btc_app/feature/market/cubit/pair_list_cubit.dart';
import 'package:btc_app/feature/market/cubit/pair_list_state.dart';
import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/repo/market_repository_exception.dart';
import 'package:btc_app/feature/market/views/components/favorite_pairs_section.dart';
import 'package:btc_app/feature/market/views/components/pair_collection.dart';
import 'package:btc_app/feature/market/views/extensions/market_failure_extensions.dart';

typedef _PairListViewData = ({
  PairListStatus status,
  List<TickerModel> pairs,
  MarketFailure? failure,
  String? errorMessage,
});

class PairListView extends StatelessWidget {
  final void Function(String pairSymbol) onPairTap;

  const PairListView({super.key, required this.onPairTap});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PairListCubit, PairListState, _PairListViewData>(
      selector: (state) => (
        status: state.status,
        pairs: state.pairs,
        failure: state.failure,
        errorMessage: state.errorMessage,
      ),
      builder: (context, data) {
        return switch (data.status) {
          PairListStatus.initial || PairListStatus.loading => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          PairListStatus.success => _buildContent(context, data.pairs),
          PairListStatus.failure => AppErrorView(
            messageKey: (data.failure ?? MarketFailure.unexpected).messageKey,
            message: data.errorMessage,
            onRetry: () => context.read<PairListCubit>().load(refresh: true),
          ),
        };
      },
    );
  }

  Widget _buildContent(BuildContext context, List<TickerModel> pairs) {
    if (pairs.isEmpty) {
      return Center(child: Text(context.tr(LocaleKeys.market_pairs_empty)));
    }

    return Column(
      children: [
        FavoritePairsSection(pairs: pairs, onPairTap: onPairTap),
        Expanded(
          child: PairCollection(pairs: pairs, onPairTap: onPairTap),
        ),
      ],
    );
  }
}
