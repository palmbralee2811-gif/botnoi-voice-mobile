import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFB1E9FD),
              Color(0xFFF9D8FD),
            ],
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/logo/splash-icon.png',
            width: 100,
            height: 113.3,
          ),
        ),
      ),
    );
  }
}
