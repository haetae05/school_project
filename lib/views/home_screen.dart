import 'dart:ui';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient (Deep Ocean Blue to Emerald Green)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0B202A), // Deep Ocean Blue
                  Color(0xFF1A504A), // Emerald Green
                ],
              ),
            ),
          ),
          
          // Image Fallback Background (Pollinations.ai)
          Opacity(
            opacity: 0.3,
            child: Image.network(
              'https://image.pollinations.ai/prompt/dark%20calm%20ocean%20waves%20abstract?width=800&height=800&nologo=true',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Glassmorphism Ripple Orb
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  width: 200 + (_controller.value * 20),
                  height: 200 + (_controller.value * 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1A504A).withOpacity(0.5),
                        blurRadius: 50,
                        spreadRadius: _controller.value * 20,
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
                        child: const Center(
                          child: Text(
                            "잔잔함",
                            style: TextStyle(
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
