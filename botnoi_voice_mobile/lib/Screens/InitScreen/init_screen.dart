import 'package:botnoi_voice_mobile/MainServer/main_server_provider.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/home_screen.dart';
import 'package:botnoi_voice_mobile/Screens/SplashScreen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  /// Check if the app is initialized
  bool _initialized = false;

  @override
  void initState() {
    initApp();
    super.initState();
  }

  /// Initialize the app
  Future<void> initApp() async {
    await Provider.of<MainServerProvider>(context, listen: false)
        .getJwtToken(context);
    await Provider.of<MainServerProvider>(context, listen: false)
        .getCredentials();
    await Provider.of<MainServerProvider>(context, listen: false)
        .getRemainingCredits();
    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      return const HomeScreen();
    } else {
      return const SplashScreen();
    }
  }
}
