import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:btc_app/app/localization/app_locale.dart';
import 'package:btc_app/app/theme/theme.dart';
import 'package:btc_app/feature/market/models/kline_candle.dart';
import 'package:btc_app/feature/market/views/components/pair_chart_content.dart';
import 'package:btc_app/feature/market/views/components/pair_line_chart.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const sharedPreferencesChannel = MethodChannel(
    'plugins.flutter.io/shared_preferences',
  );

  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(sharedPreferencesChannel, (call) async {
          return call.method == 'getAll' ? <String, Object>{} : true;
        });
    await EasyLocalization.ensureInitialized();
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(sharedPreferencesChannel, null);
  });

  final candles = List.generate(
    24,
    (index) => KlineCandle(
      timestamp: 2_000_000_000 + (index * 3600),
      high: 105 + index.toDouble(),
      open: 100 + index.toDouble(),
      low: 95 + index.toDouble(),
      close: 102 + index.toDouble(),
      volume: 10 + index.toDouble(),
    ),
    growable: false,
  );

  Future<void> pumpChart(WidgetTester tester, {required Size size}) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: AppLocale.supportedLocales,
        path: AppLocale.translationsPath,
        fallbackLocale: AppLocale.fallbackLocale,
        useOnlyLangCode: true,
        child: Builder(
          builder: (context) => MaterialApp(
            theme: AppTheme.dark,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            home: Scaffold(body: PairChartContent(candles: candles)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('adapts to mobile and desktop and supports point selection', (
    tester,
  ) async {
    await pumpChart(tester, size: const Size(390, 844));

    expect(find.text('Latest value'), findsOneWidget);
    expect(find.byType(PairLineChart), findsOneWidget);
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(1280, 800);
    await tester.pumpAndSettle();

    expect(find.text('Latest value'), findsOneWidget);
    expect(find.byType(PairLineChart), findsOneWidget);
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();

    final chartCenter = tester.getCenter(find.byType(PairLineChart));
    final gesture = await tester.startGesture(chartCenter);
    await tester.pump(kLongPressTimeout + const Duration(milliseconds: 100));

    expect(find.text('Selected point'), findsOneWidget);

    await gesture.up();
    await tester.pump();
    expect(find.text('Latest value'), findsOneWidget);
  });
}
