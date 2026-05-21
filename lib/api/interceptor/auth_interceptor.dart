import 'package:dio/dio.dart';
import 'package:weather_forecast/constants.dart';
import 'package:weather_forecast/utils/shared_pref.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final key = SharedPref().getValue(SharedPrefKeys.cwaApiKey, ApiConstants.defaultApiKey).toString();
    options.headers['Authorization'] = key;
    handler.next(options);
  }
}