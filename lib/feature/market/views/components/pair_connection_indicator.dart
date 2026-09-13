import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:btc_app/app/localization/locale_keys.g.dart';
import 'package:btc_app/core/extensions/build_context_extensions.dart';
import 'package:btc_app/feature/market/cubit/pair_list_cubit.dart';
import 'package:btc_app/feature/market/cubit/pair_list_state.dart';

class PairConnectionIndicator extends StatelessWidget {
  const PairConnectionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PairListCubit, PairListState, RealtimeStatus>(
      selector: (state) => state.realtimeStatus,
      builder: (context, status) {
        final label = context.tr(_labelKey(status));
        final color = switch (status) {
          RealtimeStatus.connected => context.colors.positive,
          RealtimeStatus.disconnected => context.colors.negative,
          RealtimeStatus.idle ||
          RealtimeStatus.connecting => context.colors.textSecondary,
        };

        return Tooltip(
          message: label,
          child: Semantics(
            label: label,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ),
          ),
        );
      },
    );
  }

  String _labelKey(RealtimeStatus status) {
    return switch (status) {
      RealtimeStatus.idle => LocaleKeys.market_pairs_realtime_idle,
      RealtimeStatus.connecting => LocaleKeys.market_pairs_realtime_connecting,
      RealtimeStatus.connected => LocaleKeys.market_pairs_realtime_connected,
      RealtimeStatus.disconnected =>
        LocaleKeys.market_pairs_realtime_disconnected,
    };
  }
}
