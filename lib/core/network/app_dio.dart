import 'package:dio/dio.dart';

import 'package:btc_app/core/constants/api_constants.dart';

abstract final class AppDio {
  static Dio create({required String baseUrl}) {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
      ),
    );
  }
}
