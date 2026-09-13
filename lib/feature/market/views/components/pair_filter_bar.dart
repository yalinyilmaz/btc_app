import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:btc_app/app/localization/locale_keys.g.dart';
import 'package:btc_app/core/extensions/build_context_extensions.dart';
import 'package:btc_app/feature/market/cubit/pair_list_state.dart';

class PairFilterBar extends StatelessWidget {
  final PairFilterType selectedFilter;
  final ValueChanged<PairFilterType> onSelected;

  const PairFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        color: context.colors.surface.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 40,
          child: Row(
            children: [
              Expanded(
                child: _FilterButton(
                  filter: PairFilterType.tryMarket,
                  isSelected: selectedFilter == PairFilterType.tryMarket,
                  onTap: onSelected,
                ),
              ),
              _divider(context),
              Expanded(
                child: _FilterButton(
                  filter: PairFilterType.usdt,
                  isSelected: selectedFilter == PairFilterType.usdt,
                  onTap: onSelected,
                ),
              ),
              _divider(context),
              Expanded(
                child: _FilterButton(
                  filter: PairFilterType.all,
                  isSelected: selectedFilter == PairFilterType.all,
                  onTap: onSelected,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      width: 1,
      height: 24,
      color: context.colors.textSecondary.withValues(alpha: 0.28),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final PairFilterType filter;
  final bool isSelected;
  final ValueChanged<PairFilterType> onTap;

  const _FilterButton({
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? context.colors.selectedSurface : null,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onTap(filter),
        child: Center(
          child: Text(
            context.tr(_labelKey),
            style: context.labelLarge?.copyWith(
              color: isSelected
                  ? context.colors.textPrimary
                  : context.colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  String get _labelKey => switch (filter) {
    PairFilterType.tryMarket => LocaleKeys.market_pairs_filters_try,
    PairFilterType.usdt => LocaleKeys.market_pairs_filters_usdt,
    PairFilterType.all => LocaleKeys.market_pairs_filters_all,
  };
}
