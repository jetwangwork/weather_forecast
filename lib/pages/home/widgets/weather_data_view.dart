import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weather_forecast/theme/app_colors.dart';
import '../../../api/models/weather_response.dart';

class WeatherDataView extends StatelessWidget {
  final WeatherLocation weatherData;
  final VoidCallback onRefresh;
  final RefreshController refreshController;

  const WeatherDataView({
    super.key,
    required this.weatherData,
    required this.onRefresh,
    required this.refreshController,
  });

  @override
  Widget build(BuildContext context) {
    // 獲取三個預報時段的資料
    final wx = weatherData.getWx();
    final pop = weatherData.getPoP();
    final minT = weatherData.getMinT();
    final maxT = weatherData.getMaxT();
    final ci = weatherData.getCI();

    // 確保資料庫完整性，如果遺失必要欄位，觸發格式不正確異常以利測試
    if (wx == null || pop == null || minT == null || maxT == null || ci == null) {
      throw const FormatException('API 格式錯誤：天氣預報元素 (Wx, PoP, MinT, MaxT, CI) 缺失或不全');
    }

    // 當前(第一個時段)的詳細資料
    final currentWx = wx.timeList[0].parameter.parameterName;
    final currentWxCode = wx.timeList[0].parameter.parameterValue ?? '1';
    final currentMinT = minT.timeList[0].parameter.parameterName;
    final currentMaxT = maxT.timeList[0].parameter.parameterName;
    final currentPop = pop.timeList[0].parameter.parameterName;
    final currentCI = ci.timeList[0].parameter.parameterName;

    return SmartRefresher(
      controller: refreshController,
      enablePullDown: true,
      onRefresh: () async {
        try {
          onRefresh();
          refreshController.refreshCompleted();
        } catch (e) {
          refreshController.refreshFailed();
        }
      },
      header: ClassicHeader(
        refreshingText: '刷新中...',
        completeText: '刷新完成',
        idleText: '下拉刷新',
        failedText: '刷新失敗',
        releaseText: '釋放立即刷新',
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 地區與時間標題
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, color: AppColors.primaryColor, size: 24),
                    const SizedBox(width: 6),
                    Text(
                      weatherData.locationName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  '今明 36 小時天氣狀況預報',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.secondaryTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 天氣資訊大卡片
            _buildMainWeatherCard(
              currentWxCode: currentWxCode,
              currentWx: currentWx,
              currentMinT: currentMinT,
              currentMaxT: currentMaxT,
              currentPop: currentPop,
              currentCI: currentCI,
              startTime: wx.timeList[0].startTime,
              endTime: wx.timeList[0].endTime,
            ),
            const SizedBox(height: 32),

            // 時段天氣預報時間軸
            const Text(
              '36 小時時段預報',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                final periodWx = wx.timeList[index].parameter.parameterName;
                final periodWxCode = wx.timeList[index].parameter.parameterValue ?? '1';
                final periodMin = minT.timeList[index].parameter.parameterName;
                final periodMax = maxT.timeList[index].parameter.parameterName;
                final periodPop = pop.timeList[index].parameter.parameterName;
                final periodCI = ci.timeList[index].parameter.parameterName;

                return _buildForecastPeriodItem(
                  index: index,
                  startTime: wx.timeList[index].startTime,
                  endTime: wx.timeList[index].endTime,
                  periodWx: periodWx,
                  periodWxCode: periodWxCode,
                  periodMin: periodMin,
                  periodMax: periodMax,
                  periodPop: periodPop,
                  periodCI: periodCI,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 建立天氣資訊大卡片
  Widget _buildMainWeatherCard({
    required String currentWxCode,
    required String currentWx,
    required String currentMinT,
    required String currentMaxT,
    required String currentPop,
    required String currentCI,
    required String startTime,
    required String endTime,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: _getWeatherGradient(currentWxCode),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _getWeatherShadowColor(currentWxCode).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getFriendlyTimeLabel(startTime, endTime, 0),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '舒適度: $currentCI',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$currentMinT°',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Text(
                            '~',
                            style: TextStyle(fontSize: 28, color: Colors.white70),
                          ),
                        ),
                        Text(
                          '$currentMaxT°',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentWx,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              // 大天氣圖示
              Hero(
                tag: 'weather_icon_main',
                child: Icon(
                  _getWeatherIcon(currentWxCode),
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMainCardDetailItem(
                Icons.umbrella_rounded,
                '降雨機率',
                '$currentPop%',
              ),
              _buildMainCardDetailItem(
                Icons.thermostat_rounded,
                '溫差幅度',
                '${int.parse(currentMaxT) - int.parse(currentMinT)}°C',
              ),
              _buildMainCardDetailItem(
                Icons.nights_stay_rounded,
                '未來預報',
                '共 3 個時段',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 建立時段天氣預報時間軸項目
  Widget _buildForecastPeriodItem({
    required int index,
    required String startTime,
    required String endTime,
    required String periodWx,
    required String periodWxCode,
    required String periodMin,
    required String periodMax,
    required String periodPop,
    required String periodCI,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.mediumGrey.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.mediumGrey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // 時間標籤
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getFriendlyTimeLabel(
                    startTime,
                    endTime,
                    index,
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  periodCI,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          // 天氣名稱與圖示
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getWeatherIcon(periodWxCode),
                  color: _getWeatherColor(periodWxCode),
                  size: 28,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    periodWx,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // 溫度與降雨機率
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$periodMin° ~ $periodMax°',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.umbrella_rounded, size: 12, color: AppColors.secondaryColor),
                    const SizedBox(width: 2),
                    Text(
                      '$periodPop%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCardDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // 取得人性化的時間顯示
  String _getFriendlyTimeLabel(String startStr, String endStr, int index) {
    try {
      final start = DateTime.parse(startStr);
      final isDay = start.hour >= 6 && start.hour < 18;
      
      String dayLabel = '';
      if (index == 0) {
        dayLabel = '首段：';
      } else if (index == 1) {
        dayLabel = '中段：';
      } else {
        dayLabel = '末段：';
      }

      final monthStr = '${start.month}/${start.day}';
      final hourStr = start.hour.toString().padLeft(2, '0');
      final periodStr = isDay ? '白天' : '晚上';

      return '$dayLabel$monthStr $hourStr:00 ($periodStr)';
    } catch (_) {
      if (index == 0) return '今日今晚';
      if (index == 1) return '明日白天';
      return '明日晚上';
    }
  }

  // 根據 Wx 天氣代碼獲取 Icon
  IconData _getWeatherIcon(String code) {
    final intCode = int.tryParse(code) ?? 1;
    if (intCode == 1) {
      return Icons.wb_sunny_rounded; // 晴天
    } else if (intCode <= 3) {
      return Icons.wb_cloudy_rounded; // 晴時多雲、多雲時晴
    } else if (intCode <= 7) {
      return Icons.cloud_rounded; // 多雲、陰天
    } else if (intCode <= 14 || intCode == 19 || intCode == 20 || intCode == 29 || intCode == 30) {
      return Icons.umbrella_rounded; // 短暫雨、陣雨
    } else if (intCode <= 22 || intCode == 33 || intCode == 34) {
      return Icons.thunderstorm_rounded; // 雷雨
    }
    return Icons.wb_cloudy_rounded;
  }

  // 根據 Wx 天氣代碼獲取顏色
  Color _getWeatherColor(String code) {
    final intCode = int.tryParse(code) ?? 1;
    if (intCode == 1) return AppColors.primaryColor;
    if (intCode <= 3) return AppColors.primaryColor.withValues(alpha: 0.8);
    if (intCode <= 7) return AppColors.mediumGrey;
    return AppColors.secondaryColor;
  }

  // 根據 Wx 天氣代碼獲取卡片背景漸變
  Gradient _getWeatherGradient(String code) {
    final intCode = int.tryParse(code) ?? 1;
    if (intCode == 1) {
      // 晴朗的陽光漸變
      return const LinearGradient(
        colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (intCode <= 3) {
      // 晴時多雲的舒適暖橘藍，改以品牌色點綴
      return const LinearGradient(
        colors: [AppColors.primaryColor, AppColors.secondaryColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (intCode <= 7) {
      // 多雲陰天的灰色調
      return const LinearGradient(
        colors: [Color(0xFF90A4AE), Color(0xFF455A64)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      // 下雨雷雨的深藍色調
      return const LinearGradient(
        colors: [Color(0xFF1E88E5), Color(0xFF1565C0), Color(0xFF0D47A1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  Color _getWeatherShadowColor(String code) {
    final intCode = int.tryParse(code) ?? 1;
    if (intCode == 1) return Colors.orange.shade800;
    if (intCode <= 3) return AppColors.primaryColor.withValues(alpha: 0.8);
    if (intCode <= 7) return Colors.blueGrey.shade800;
    return Colors.blue.shade900;
  }
}
