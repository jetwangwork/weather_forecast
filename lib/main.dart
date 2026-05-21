import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_forecast/route/route_constants.dart';
import 'package:weather_forecast/route/router.dart' as router;
import 'package:weather_forecast/theme/app_theme.dart';
import 'package:weather_forecast/utils/shared_pref.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref().init();
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '台灣天氣預報',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      onGenerateRoute: router.generateRoute,
      initialRoute: homeScreenRoute,
    );
  }
}
