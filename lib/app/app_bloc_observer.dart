import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<Object?> bloc, Change<Object?> change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      debugPrint('${bloc.runtimeType}: $change');
    }
  }

  @override
  void onError(BlocBase<Object?> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (kDebugMode) {
      debugPrint('${bloc.runtimeType}: $error');
    }
  }
}
