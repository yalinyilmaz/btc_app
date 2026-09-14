import 'package:flutter/material.dart';

import 'package:btc_app/app/components/app_responsive_builder.dart';
import 'package:btc_app/feature/market/models/ticker_model.dart';
import 'package:btc_app/feature/market/views/components/pair_tile.dart';

class PairCollection extends StatelessWidget {
  final List<TickerModel> pairs;
  final ValueChanged<String> onPairTap;

  const PairCollection({
    super.key,
    required this.pairs,
    required this.onPairTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppResponsiveBuilder(
      mobile: _buildList,
      tablet: _buildGrid,
      desktop: _buildGrid,
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: pairs.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (_, index) => _buildTile(pairs[index]),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 24),
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 560,
        mainAxisExtent: 88,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: pairs.length,
      itemBuilder: (_, index) => _buildTile(pairs[index]),
    );
  }

  Widget _buildTile(TickerModel ticker) {
    return PairTile(ticker: ticker, onTap: () => onPairTap(ticker.pair));
  }
}
