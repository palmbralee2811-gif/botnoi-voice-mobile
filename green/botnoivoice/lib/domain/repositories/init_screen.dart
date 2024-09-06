import 'package:botnoivoice/data/managers/token_manager.dart';
import 'package:botnoivoice/presentation/screens/home/home_screen.dart';
import 'package:botnoivoice/presentation/screens/splash/splash_screen.dart';
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
    await Provider.of<TokenManager>(context, listen: false)
        .loadJwtToken(context);
    await Provider.of<TokenManager>(context, listen: false)
        .loadCredentials();
    await Provider.of<TokenManager>(context, listen: false)
        .loadRemainingCredits();
    setState(() {
      _initialized = true;
    });
  }

  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      return Scaffold(
        // bottomNavigationBar: BottomNavBar(
        //   onButtonTapped: (buttonIndex) {
        //     _pageController.animateToPage(
        //       buttonIndex,
        //       duration: const Duration(milliseconds: 500),
        //       curve: Curves.easeInOut,
        //     );
        //   },
        // ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            HomeScreen(),
            // Scaffold(),
          ],
        ),
      );
    } else {
      return const SplashScreen();
    }
  }
}
