import 'dart:convert';
import 'package:weather_forecast/api/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../api/api_result.dart';
import '../api/models/weather_response.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final api = ref.watch(apiServiceProvider);
  return WeatherRepository._internal(api);
});

class WeatherRepository {
  WeatherRepository._internal(this._api);

  final ApiService _api;

  /// 獲取天氣預報資訊
  Future<ApiResult<WeatherResponse>> fetchWeatherForecast({
    required String locationName,
  }) async {
    final normalized = locationName.trim().replaceAll('台', '臺');

    final result = await _api.getWeatherForecast(
      locationName: normalized,
    );

    switch (result) {
      case ApiSuccess<Response>():
        try {
          final data = result.data.data;
          
          // 如果返回空值，或是解析失敗
          if (data == null) {
            return const ApiError('API 返回資料為空');
          }

          // 如果回傳型態為 String，嘗試 parse JSON
          Map<String, dynamic> jsonMap;
          if (data is String) {
            jsonMap = jsonDecode(data) as Map<String, dynamic>;
          } else if (data is Map<String, dynamic>) {
            jsonMap = data;
          } else {
            return const ApiError('API 返回數據格式不正確：無法識別的資料結構');
          }

          // 解析為 WeatherResponse
          final response = WeatherResponse.fromJson(jsonMap);

          // CWA 如果沒查到對應縣市
          if (response.records == null || response.records!.locationList.isEmpty) {
            return ApiError('無此地區的天氣資料：$normalized');
          }

          return ApiSuccess(response);
        } on FormatException catch (e) {
          // 捕捉資料解析異常，並呈現錯誤
          return ApiError('API 格式錯誤：${e.message}');
        } catch (e) {
          return ApiError('解析 API 響應時發生錯誤: $e');
        }
      case ApiError<Response>():
        // 映射網路錯誤，例如：API 金鑰無效或網路超時
        return ApiError(result.message);
    }
  }
}
