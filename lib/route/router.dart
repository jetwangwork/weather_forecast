import 'package:flutter/material.dart';
import 'screen_export.dart';
import 'route_constants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {

    case homeScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const HomePage(),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const HomePage(),
      );
  }
}
