import 'package:flutter/material.dart';

class AppValue {
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 16.0;
  static const double defaultShadowAlpha = 0.05;
  static const double defaultShadowElevation = 3.0;
  static final BoxShadow defaultBoxShadow = BoxShadow(
    color: Colors.black.withValues(alpha: AppValue.defaultShadowAlpha),
    blurRadius: 8,
    offset: const Offset(0, 4),
  );
}
