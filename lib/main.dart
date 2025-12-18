import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared/core/theme/app_theme.dart';
import 'features/auth/presentation/screens/splash_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: EconomaxApp(),
    ),
  );
}

class EconomaxApp extends StatelessWidget {
  const EconomaxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECONOMAX',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
