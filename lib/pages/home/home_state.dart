import '../../api/models/weather_response.dart';

class HomeState {
  final WeatherLocation? weatherData;
  final bool isLoading;
  final String? error;
  final bool showApiKeyPanel;

  const HomeState({
    this.weatherData,
    this.isLoading = false,
    this.error,
    this.showApiKeyPanel = false,
  });

  HomeState copyWith({
    WeatherLocation? weatherData,
    bool? isLoading,
    String? error,
    bool? showApiKeyPanel,
  }) {
    return HomeState(
      weatherData: weatherData ?? this.weatherData,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      showApiKeyPanel: showApiKeyPanel ?? this.showApiKeyPanel,
    );
  }
}
