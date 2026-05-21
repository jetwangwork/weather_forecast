import 'package:weather_forecast/theme/app_value.dart';
import 'package:flutter/material.dart';

class ErrorIcon extends StatelessWidget {
  const ErrorIcon({
    super.key,
    required this.size,
    this.color = const Color(0xFF757575),
    this.errorMsg,
  });

  final double size;
  final Color color;
  final String? errorMsg;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error,
          color: color,
          size: size,
        ),
        if (errorMsg != null)
          SizedBox(height: AppValue.defaultPadding / 4),
        if (errorMsg != null)
          Text(errorMsg!)
      ],
    );
  }
}
