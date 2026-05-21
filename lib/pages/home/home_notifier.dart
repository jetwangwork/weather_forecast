import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_forecast/pages/home/home_state.dart';
import 'package:weather_forecast/repository/weather_repository.dart';
import 'package:weather_forecast/utils/shared_pref.dart';

import '../../api/api_result.dart';

final homeNotifier = NotifierProvider.autoDispose<HomeNotifier, HomeState>(() {
  return HomeNotifier();
});

class HomeNotifier extends AutoDisposeNotifier<HomeState> {

  late final WeatherRepository _repo;

  @override
  HomeState build() {
    _repo = ref.read(weatherRepositoryProvider);
    return HomeState();
  }

  /// 更新 ApiKey 面板狀態
  Future<void> updateApiKeyPanel(bool showApiKeyPanel) async {
    state = state.copyWith(showApiKeyPanel: showApiKeyPanel);
  }

  /// 儲存並更新 API Key
  Future<void> updateApiKey(String key) async {
    await SharedPref().setValue(SharedPrefKeys.cwaApiKey, key);
    state = state.copyWith(
      showApiKeyPanel: false
    );
  }

  /// 搜尋指定縣市的天氣預報
  Future<void> searchWeather(String city) async {
    if (city.trim().isEmpty) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
      weatherData: null,
    );

    final result = await _repo.fetchWeatherForecast(
      locationName: city,
    );

    switch (result) {
      case ApiSuccess():
        final location = result.data.records?.locationList.first;
        if (location == null) {
          state = state.copyWith(
            isLoading: false,
            error: 'API 資料異常：找不到該縣市的氣象紀錄。',
            weatherData: null,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            weatherData: location,
          );
        }
      case ApiError():
        state = state.copyWith(
          isLoading: false,
          error: result.message,
          weatherData: null,
        );
    }
  }

  /// 重設至初始狀態
  void reset() {
    state = HomeState();
  }
}