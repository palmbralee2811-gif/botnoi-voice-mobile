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
          image: DecorationImage(
            image: AssetImage('assets/images/splash_screen/background-320x684.png'), // ระบุตำแหน่งของไฟล์รูป
            fit: BoxFit.cover, // ให้รูปภาพเต็มหน้าจอ
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

