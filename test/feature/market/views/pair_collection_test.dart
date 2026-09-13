import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:btc_app/app/localization/app_locale.dart';
import 'package:btc_app/app/theme/theme.dart';
import 'package:btc_app/feature/market/cubit/favorite_pairs_cubit.dart';
import 'package:btc_app/feature/market/views/components/pair_collection.dart';
import 'package:btc_app/feature/market/views/components/pair_tile.dart';

import '../ticker_fixture.dart';

class _MockStorage extends Mock implements Storage {}

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

  testWidgets('builds only visible mobile cards while scrolling', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    final pairs = List.generate(
      40,
      (index) => tickerFixture(pair: 'PAIR$index', order: index),
      growable: false,
    );
    final storage = _MockStorage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any())).thenAnswer((_) async {});

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
            home: BlocProvider(
              create: (_) => FavoritePairsCubit(storage: storage),
              child: Scaffold(
                body: PairCollection(pairs: pairs, onPairTap: (_) {}),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PairTile).evaluate().length, lessThan(pairs.length));

    await tester.drag(find.byType(ListView), const Offset(0, -3000));
    await tester.pump();

    expect(find.byType(PairTile).evaluate().length, lessThan(pairs.length));
    expect(tester.takeException(), isNull);
  });
}
