import 'package:botnoivoice/presentation/providers/google/google_token_provider.dart';
import 'package:botnoivoice/presentation/screens/home/home_screen.dart';
import 'package:botnoivoice/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Check if the app is initialized
class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  bool _initialized = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => initApp());
    super.initState();
  }

  /// Initialize the app
  Future<void> initApp() async {
    await Provider.of<GoogleTokenProvider>(context, listen: false)
        .loadJwtToken(context);
    await Provider.of<GoogleTokenProvider>(context, listen: false)
        .loadCredentials(context);
    await Provider.of<GoogleTokenProvider>(context, listen: false)
        .loadRemainingCredits(context);
    setState(() {
      _initialized = true;
    });
  }

  //final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      return const Scaffold(
        // bottomNavigationBar: BottomNavBar(
        //   onButtonTapped: (buttonIndex) {
        //     _pageController.animateToPage(
        //       buttonIndex,
        //       duration: const Duration(milliseconds: 500),
        //       curve: Curves.easeInOut,
        //     );
        //   },
        // ),
        //body: PageView(
        //  controller: _pageController,
        //  physics: const NeverScrollableScrollPhysics(),
        //  children: const [
        //    HomeScreen(),
        //    // Scaffold(),
        //  ],
        //),
        body: HomeScreen(),
      );
    } else {
      return const SplashScreen();
    }
  }
}
