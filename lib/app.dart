import 'package:flutter/material.dart';
import 'package:rentify_flat_management/core/app_theme/app_theme.dart';
import 'package:rentify_flat_management/view/splash_screen_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenView(),
      theme: getApplicationTheme(),
    );
  }
}
