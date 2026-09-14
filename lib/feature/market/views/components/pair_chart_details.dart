import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:btc_app/app/localization/locale_keys.g.dart';
import 'package:btc_app/core/extensions/build_context_extensions.dart';
import 'package:btc_app/core/extensions/num_extensions.dart';
import 'package:btc_app/feature/market/models/kline_candle.dart';
import 'package:btc_app/feature/market/models/ticker_model.dart';

class PairChartDetails extends StatelessWidget {
  final KlineCandle candle;
  final TickerModel? ticker;

  const PairChartDetails({super.key, required this.candle, this.ticker});

  @override
  Widget build(BuildContext context) {
    final String locale = context.locale.toLanguageTag();
    final String date = DateFormat.yMMMd(locale).add_Hm().format(candle.dateTime);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date, style: context.titleMedium),
            const SizedBox(height: 12),
            if (ticker != null)
              _MarketDetails(candle: candle, ticker: ticker!)
            else
              _DetailItem(
                label: context.tr(LocaleKeys.market_chart_close),
                value: candle.close.formatDecimal(context.locale),
              ),
            const SizedBox(height: 12),
            Text(
              context.tr(LocaleKeys.market_chart_interactionHint),
              style: context.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketDetails extends StatelessWidget {
  final KlineCandle candle;
  final TickerModel ticker;

  const _MarketDetails({required this.candle, required this.ticker});

  @override
  Widget build(BuildContext context) {
    final String priceSymbol = ticker.denominatorSymbol;
    final String volume = ticker.volume.floor().formatDecimal(context.locale);

    String price(double value) {
      return '${value.formatDecimal(context.locale)} $priceSymbol';
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth < 320
            ? constraints.maxWidth
            : (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: width,
              child: _DetailItem(
                label: context.tr(LocaleKeys.market_chart_close),
                value: price(candle.close),
              ),
            ),
            SizedBox(
              width: width,
              child: _DetailItem(
                label: context.tr(LocaleKeys.market_chart_volume),
                note: context.tr(LocaleKeys.market_chart_last24Hours),
                value: '$volume ${ticker.numeratorSymbol}',
              ),
            ),
            SizedBox(
              width: width,
              child: _DetailItem(
                label: context.tr(LocaleKeys.market_chart_high),
                note: context.tr(LocaleKeys.market_chart_last24Hours),
                value: price(ticker.high),
              ),
            ),
            SizedBox(
              width: width,
              child: _DetailItem(
                label: context.tr(LocaleKeys.market_chart_low),
                note: context.tr(LocaleKeys.market_chart_last24Hours),
                value: price(ticker.low),
              ),
            ),
            SizedBox(
              width: width,
              child: _DetailItem(
                label: context.tr(LocaleKeys.market_chart_bid),
                value: price(ticker.bid),
              ),
            ),
            SizedBox(
              width: width,
              child: _DetailItem(
                label: context.tr(LocaleKeys.market_chart_ask),
                value: price(ticker.ask),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String? note;
  final String value;

  const _DetailItem({required this.label, this.note, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: context.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            if (note != null) ...[
              const SizedBox(width: 4),
              Text(
                note!,
                style: context.labelSmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.labelLarge,
        ),
      ],
    );
  }
}
