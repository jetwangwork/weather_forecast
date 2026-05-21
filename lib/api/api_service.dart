import 'package:weather_forecast/api/api_result.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_manager.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final api = ref.watch(apiManagerProvider);
  return ApiService._internal(api);
});

class ApiService {
  ApiService._internal(this._api);

  final ApiManager _api;

  // 獲取今明 36 小時天氣預報
  Future<ApiResult<Response>> getWeatherForecast({
    required String locationName,
  }) {
    final Map<String, dynamic> params = {};
    params['locationName'] = locationName;
    return _api.get(
      '/v1/rest/datastore/F-C0032-001',
      params: params,
    );
  }
}