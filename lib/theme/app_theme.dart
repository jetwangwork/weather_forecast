import 'package:flutter/material.dart';
import 'package:weather_forecast/theme/app_colors.dart';
import 'package:weather_forecast/theme/app_value.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundGrey,
    textTheme: textTheme,
    appBarTheme: appBarLightTheme,
    elevatedButtonTheme: elevatedButtonThemeData,
    outlinedButtonTheme: outlinedButtonThemeData,
    inputDecorationTheme: inputDecorationTheme,
    progressIndicatorTheme: progressIndicatorThemeData,
  );
}

TextTheme textTheme = const TextTheme(
  bodyMedium: TextStyle(fontSize: 16, color: AppColors.primaryTextColor),
);

const AppBarTheme appBarLightTheme = AppBarTheme(
  backgroundColor: AppColors.primaryColor,
  iconTheme: IconThemeData(color: Colors.white),
  titleTextStyle: TextStyle(
    fontSize: 20,
    color: Colors.white,
  ),
  centerTitle: true,
);

ElevatedButtonThemeData elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10
    ),
    backgroundColor: AppColors.primaryColor,
    foregroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppValue.defaultBorderRadius)),
    ),
  ),
);

OutlinedButtonThemeData outlinedButtonThemeData = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10
    ),
    side: const BorderSide(width: 1.5, color: AppColors.primaryColor),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppValue.defaultBorderRadius)),
    ),
  ),
);

InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
  filled: true,
  fillColor: Colors.white,
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppValue.defaultBorderRadius),
    borderSide: BorderSide(color: Colors.grey.shade400),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppValue.defaultBorderRadius),
    borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
  ),
);

ProgressIndicatorThemeData progressIndicatorThemeData = ProgressIndicatorThemeData(
  color: AppColors.primaryColor,
);