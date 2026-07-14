import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/ripple_state.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rippleState = ref.watch(rippleStateProvider);
    
    // Adjust animation speed and colors based on state
    String stateText = "고요함";
    Color shadowColor = const Color(0xFF1A504A); // Emerald Green
    double spreadMultiplier = 20;

    switch (rippleState) {
      case RippleState.calm:
        _controller.duration = const Duration(seconds: 4);
        stateText = "고요함";
        break;
      case RippleState.walking:
        _controller.duration = const Duration(seconds: 2);
        stateText = "걷는 중";
        spreadMultiplier = 30;
        break;
      case RippleState.busy:
        _controller.duration = const Duration(milliseconds: 800);
        stateText = "바쁨";
        spreadMultiplier = 40;
        shadowColor = Colors.orange;
        break;
      case RippleState.danger:
        _controller.duration = const Duration(milliseconds: 300);
        stateText = "위험 구역";
        spreadMultiplier = 60;
        shadowColor = Colors.red;
        break;
    }
    
    // Ensure animation continues with new duration
    if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0B202A),
                  Color(0xFF1A504A),
                ],
              ),
            ),
          ),
          Opacity(
            opacity: 0.3,
            child: Image.network(
              'https://image.pollinations.ai/prompt/dark%20calm%20ocean%20waves%20abstract?width=800&height=800&nologo=true',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  width: 200 + (_controller.value * spreadMultiplier),
                  height: 200 + (_controller.value * spreadMultiplier),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor.withOpacity(0.5),
                        blurRadius: 50,
                        spreadRadius: _controller.value * spreadMultiplier,
                      )
                    ],
                  ),
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            stateText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildGlassBottomNav(),
    );
  }

  Widget _buildGlassBottomNav() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          color: Colors.black.withOpacity(0.2),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: '잔물결'),
              BottomNavigationBarItem(icon: Icon(Icons.waves), label: '소리'),
              BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: '물길'),
              BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: '기록'),
              BottomNavigationBarItem(icon: Icon(Icons.shield_outlined), label: '안전'),
            ],
          ),
        ),
      ),
    );
  }
}
