import 'package:flutter/material.dart';
import 'package:investigator/core/di/service_locator.dart';
import 'package:investigator/features/home/animation_splash_screen.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: AnimatedSplashScreen());
  }
}
