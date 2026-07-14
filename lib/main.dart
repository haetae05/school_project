import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/home_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyHealingApp(),
    ),
  );
}

class MyHealingApp extends StatelessWidget {
  const MyHealingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '잔물결',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B202A), // Deep Ocean Blue
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A504A), // Emerald Green
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
