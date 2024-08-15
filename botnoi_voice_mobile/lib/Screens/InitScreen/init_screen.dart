import 'package:botnoi_voice_mobile/MainServer/main_server_provider.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/home_screen.dart';
import 'package:botnoi_voice_mobile/Screens/InitScreen/bottom_navbar.dart';
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

  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      return Scaffold(
        bottomNavigationBar: BottomNavBar(
          onButtonTapped: (buttonIndex) {
            _pageController.animateToPage(
              buttonIndex,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            HomeScreen(),
            Scaffold(),
          ],
        ),
      );
    } else {
      return const SplashScreen();
    }
  }
}
