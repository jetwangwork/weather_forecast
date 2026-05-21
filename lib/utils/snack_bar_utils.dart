import 'package:flutter/material.dart';
import 'package:weather_forecast/theme/app_colors.dart';

class SnackBarUtils {
  SnackBarUtils._internal();

  static void showDefaultSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18
          )
        ),
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating, // 讓 SnackBar 浮起來
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}