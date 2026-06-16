import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weather_forecast/constants.dart';
import 'package:weather_forecast/pages/home/widgets/api_key_panel.dart';
import 'package:weather_forecast/pages/home/widgets/weather_initial_view.dart';
import 'package:weather_forecast/pages/home/widgets/weather_data_view.dart';
import 'package:weather_forecast/pages/home/widgets/weather_error_view.dart';
import 'package:weather_forecast/utils/shared_pref.dart';
import 'package:weather_forecast/utils/snack_bar_utils.dart';
import 'package:weather_forecast/widgets/edit_text_bar/app_search_bar.dart';

import 'home_notifier.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final RefreshController _refreshController = RefreshController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        ref.read(homeNotifier.notifier).reset();
      }
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _searchController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeNotifier);

    // 同步 API Key 欄位的數值
    if (state.showApiKeyPanel) {
      _apiKeyController.text = SharedPref().getValue(SharedPrefKeys.cwaApiKey, ApiConstants.defaultApiKey).toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('台灣氣象預報'),
        actions: [
          // API Key 設定按鈕
          IconButton(
            icon: Icon(
              Icons.vpn_key_rounded,
              color: Colors.white,
            ),
            tooltip: '設定氣象局 API 金鑰',
            onPressed: () {
              ref.read(homeNotifier.notifier).updateApiKeyPanel(!state.showApiKeyPanel);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ApiKey 設定面板
            ApiKeyPanel(
              showPanel: state.showApiKeyPanel,
              controller: _apiKeyController,
              onSave: () async {
                await ref.read(homeNotifier.notifier).updateApiKey(_apiKeyController.text);
                SnackBarUtils.showDefaultSnackBar(context, 'API 金鑰已更新並成功保存！');
              },
            ),

            // 搜尋輸入框
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: AppSearchBar(
                      controller: _searchController,
                      hintText: '搜尋台灣縣市 (如：臺北市、宜蘭縣...)',
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 確認按鈕
                  ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      ref.read(homeNotifier.notifier).searchWeather(_searchController.text);
                    },
                    child: const Text(
                      '確認',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 天氣預報內容
            Expanded(
              child: Builder(
                builder: (context) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.error != null) {
                    return WeatherErrorView(
                      errorMessage: state.error!,
                      onGoHome: () {
                        _searchController.clear();
                      },
                    );
                  }

                  if (state.weatherData != null) {
                    return WeatherDataView(
                      refreshController: _refreshController,
                      weatherData: state.weatherData!,
                      onRefresh: () {
                        ref.read(homeNotifier.notifier).searchWeather(_searchController.text);
                      },
                    );
                  }

                  return WeatherInitialView(
                    onCitySelected: (city) {
                      _searchController.text = city;
                      ref.read(homeNotifier.notifier).searchWeather(city);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
