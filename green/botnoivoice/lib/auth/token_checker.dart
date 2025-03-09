import 'package:botnoivoice/config/revenuecat_config.dart';
import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/token/apple_token.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/token/email_token.dart';
import 'package:botnoivoice/service/email/email_username_api.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/token/google_token.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/service/token/line_token.dart';
import 'package:botnoivoice/service/email/check_user_is_show_email.dart';
import 'package:botnoivoice/ui/screen/main/home/home_screen.dart';
import 'package:botnoivoice/ui/screen/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Token Management for Google, Apple, LINE, and Email
class TokenChecker extends StatefulWidget {
  const TokenChecker({super.key});

  @override
  State<TokenChecker> createState() => _TokenCheckerState();
}

class _TokenCheckerState extends State<TokenChecker> {
  bool _initialized = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => initApp());
    super.initState();
  }

  /// Function to check how the user logs in and loading data
  Future<void> initApp() async {
    final appleProvider = Provider.of<AppleLogin>(context, listen: false);
    final googleProvider = Provider.of<GoogleLogin>(context, listen: false);
    final lineProvider = Provider.of<LineLogin>(context, listen: false);
    final emailProvider = Provider.of<EmailLogin>(context, listen: false);

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
    final appleTokenProvider = Provider.of<AppleToken>(context, listen: false);
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
        Provider.of<GoogleToken>(context, listen: false);
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
    final lineTokenProvider = Provider.of<LineToken>(context, listen: false);
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
    final emailTokenProvider = Provider.of<EmailToken>(context, listen: false);
    await emailTokenProvider.loadJwtToken(context);
    await emailTokenProvider.loadCredentials();
    await emailTokenProvider.loadRemainingCredits();

    /// Load get username by email
    String? email =
        Provider.of<EmailLogin>(context, listen: false).getUserEmail;
    await Provider.of<EmailUsernameApi>(context, listen: false)
        .loadGetUsername(email);

    /// Load user info show mail (email permission)
    await Provider.of<CheckUserIsShowEmail>(context, listen: false)
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
