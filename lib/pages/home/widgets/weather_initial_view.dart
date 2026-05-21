import 'package:flutter/material.dart';
import 'package:weather_forecast/theme/app_colors.dart';

class WeatherInitialView extends StatelessWidget {
  final Function(String) onCitySelected;

  const WeatherInitialView({
    super.key,
    required this.onCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    
    // 台灣 22 個縣市清單
    const taiwanCounties = [
      '臺北市', '新北市', '桃園市', '臺中市', '臺南市', '高雄市',
      '基隆市', '新竹市', '嘉義市', '新竹縣', '苗栗縣', '彰化縣',
      '南投縣', '雲林縣', '嘉義縣', '屏東縣', '宜蘭縣', '花蓮縣',
      '臺東縣', '澎湖縣', '金門縣', '連江縣'
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wb_twilight_rounded,
                size: 72,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '探索今日好天氣',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryTextColor,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '請在上方輸入框輸入台灣縣市名稱，或點擊下方熱門縣市進行快速查詢！',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.secondaryTextColor,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Popular quick chips section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
                child: Text(
                  '熱門搜尋地區',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryTextColor.withValues(alpha: 0.8),
                  ),
                ),
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.start,
                children: taiwanCounties.map((city) {
                  return GestureDetector(
                    onTap: () => onCitySelected(city),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.mediumGrey.withValues(alpha: 0.5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        city,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
