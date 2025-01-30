import 'package:botnoivoice/presentation/configurations/revenuecat_config.dart';
import 'package:botnoivoice/presentation/providers/apple/apple_login_provider.dart';
import 'package:botnoivoice/presentation/providers/apple/apple_token_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_token_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_username_api_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_token_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_token_provider.dart';
import 'package:botnoivoice/presentation/providers/user/user_info_provider.dart';
import 'package:botnoivoice/presentation/screens/home/home_screen.dart';
import 'package:botnoivoice/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Check how the user logs in (Google, LINE, or Email)
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

  //TODO: fix this error
  /*
   [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: This widget has been unmounted, so the State no longer has a context (and should be considered defunct).
    E/flutter (26127): Consider canceling any active work during "dispose" or using the "mounted" getter to determine if the State is still active.
    E/flutter (26127): #0      State.context.<anonymous closure> (package:flutter/src/widgets/framework.dart:951:9)
    E/flutter (26127): #1      State.context (package:flutter/src/widgets/framework.dart:957:6)
    E/flutter (26127): #2      _InitScreenState._loadGoogleCredentials (package:botnoivoice/data/authentication/init_screen.dart:102:31)
    E/flutter (26127): <asynchronous suspension>
    E/flutter (26127): #3      _InitScreenState.initApp (package:botnoivoice/data/authentication/init_screen.dart:54:7)
    E/flutter (26127): <asynchronous suspension>
  */

  /// Function to check how the user logs in and loading data
  Future<void> initApp() async {
    final appleProvider =
        Provider.of<AppleLoginProvider>(context, listen: false);
    final googleProvider =
        Provider.of<GoogleLoginProvider>(context, listen: false);
    final lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
    final emailProvider =
        Provider.of<EmailLoginProvider>(context, listen: false);

    /// Check if the user logs in with Apple
    if (appleProvider.isLoggedIn &&
        appleProvider.user?.providerData[0].providerId == 'apple.com') {
      await _loadAppleCredentials();
      return;
    }

    /// Check if the user logs in with Google
    if (googleProvider.isLoggedIn &&
        googleProvider.user?.providerData[0].providerId == 'google.com') {
      await _loadGoogleCredentials();
      return;
    }

    /// Check if the user logs in with LINE
    if (lineProvider.isLoggedIn) {
      await _loadLineCredentials();
      return;
    }

    /// Check if the user logs in with Email
    if (emailProvider.isLoggedIn &&
        emailProvider.user?.providerData[0].providerId == 'password') {
      await _loadEmailCredentials();
      return;
    }

    /// If no login is found from any provider
    setState(() {
      _initialized = true;
    });
  }

  /// Load data when logging in with Apple
  Future<void> _loadAppleCredentials() async {
    final appleTokenProvider =
        Provider.of<AppleTokenProvider>(context, listen: false);
    await appleTokenProvider.loadJwtToken(context);
    await appleTokenProvider.loadCredentials();
    await appleTokenProvider.loadRemainingCredits();

    /// Configure RevenueCat with User ID for In-App Purchase (IAP)
    await configureRevenueCat(context);

    setState(() {
      _initialized = true;
    });
  }

  /// Load data when logging in with Google
  Future<void> _loadGoogleCredentials() async {
    final googleTokenProvider =
        Provider.of<GoogleTokenProvider>(context, listen: false);
    await googleTokenProvider.loadJwtToken(context);
    await googleTokenProvider.loadCredentials();
    await googleTokenProvider.loadRemainingCredits();

    /// Configure RevenueCat with User ID for In-App Purchase (IAP)
    await configureRevenueCat(context);

    setState(() {
      _initialized = true;
    });
  }

  /// Load data when logging in with LINE
  Future<void> _loadLineCredentials() async {
    final lineTokenProvider =
        Provider.of<LineTokenProvider>(context, listen: false);
    await lineTokenProvider.loadJwtToken(context);
    await lineTokenProvider.loadCredentials();
    await lineTokenProvider.loadRemainingCredits();

    /// Configure RevenueCat with User ID for In-App Purchase (IAP)
    await configureRevenueCat(context);

    setState(() {
      _initialized = true;
    });
  }

  /// Load data when logging in with Email
  Future<void> _loadEmailCredentials() async {
    final emailTokenProvider =
        Provider.of<EmailTokenProvider>(context, listen: false);
    await emailTokenProvider.loadJwtToken(context);
    await emailTokenProvider.loadCredentials();
    await emailTokenProvider.loadRemainingCredits();

    /// Load get username by email
    String? email =
        Provider.of<EmailLoginProvider>(context, listen: false).getUserEmail;
    await Provider.of<EmailUsernameApiProvider>(context, listen: false)
        .loadGetUsername(email);

    /// Load user info show mail (email permission)
    await Provider.of<UserInfoProvider>(context, listen: false)
        .getUserInfoShowMail(context);

    /// Configure RevenueCat with User ID for In-App Purchase (IAP)
    await configureRevenueCat(context);

    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      return const HomeScreen();

      /// Return to HomeScreen when successfully loaded
    } else {
      return const SplashScreen(); // Loading Screen
    }
  }
}