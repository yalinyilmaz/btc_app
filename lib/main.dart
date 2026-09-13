import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'package:btc_app/app.dart';
import 'package:btc_app/app/app_bloc_observer.dart';
import 'package:btc_app/app/localization/app_locale.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  Bloc.observer = const AppBlocObserver();

  final storageDirectory = kIsWeb
      ? HydratedStorageDirectory.web
      : HydratedStorageDirectory(
          (await getApplicationDocumentsDirectory()).path,
        );
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: storageDirectory,
  );

  runApp(
    EasyLocalization(
      supportedLocales: AppLocale.supportedLocales,
      path: AppLocale.translationsPath,
      fallbackLocale: AppLocale.fallbackLocale,
      useOnlyLangCode: true,
      child: const App(),
    ),
  );
}
