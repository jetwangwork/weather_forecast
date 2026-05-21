import 'package:flutter/material.dart';
import 'package:weather_forecast/theme/app_colors.dart';
import 'package:weather_forecast/theme/app_value.dart';

class ApiKeyPanel extends StatelessWidget {
  final bool showPanel;
  final TextEditingController controller;
  final VoidCallback onSave;

  const ApiKeyPanel({
    super.key,
    required this.showPanel,
    required this.controller,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: const SizedBox(width: double.infinity,height: 0,),
      secondChild: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppValue.defaultPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: AppColors.mediumGrey.withValues(alpha: 0.5)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '中央氣象署 API 金鑰設定',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '請至中央氣象署開放資料平台註冊以取得金鑰 (CWA-xxx)。',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.secondaryTextColor,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: '輸入你的 CWA-XXXXXXXXXXXXXXXX',
                      hintStyle: TextStyle(
                        color: AppColors.secondaryTextColor.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => onSave(),
                  child: const Text(
                    '儲存',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      crossFadeState: showPanel ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }
}
