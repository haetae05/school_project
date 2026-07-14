import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/home_screen.dart';
import 'services/geofencing_service.dart';
import 'services/audio_service.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyHealingApp(),
    ),
  );
}

class MyHealingApp extends ConsumerStatefulWidget {
  const MyHealingApp({super.key});

  @override
  ConsumerState<MyHealingApp> createState() => _MyHealingAppState();
}

class _MyHealingAppState extends ConsumerState<MyHealingApp> {
  @override
  void initState() {
    super.initState();
    // Initialize Geofencing and Audio engines
    Future.microtask(() {
      ref.read(geofencingServiceProvider).init();
      ref.read(audioServiceProvider).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '잔물결',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B202A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A504A),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
