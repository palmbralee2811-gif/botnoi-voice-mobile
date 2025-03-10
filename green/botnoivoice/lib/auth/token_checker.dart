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

/*
//TODO: Fix the error | [DONE] 10/3/2023, 10:48 AM

[ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: This widget has been unmounted, so the State no longer has a context (and should be considered defunct).
Consider canceling any active work during "dispose" or using the "mounted" getter to determine if the State is still active.
#0      State.context.<anonymous closure> (package:flutter/src/widgets/framework.dart:951:9)
framework.dart:951
#1      State.context (package:flutter/src/widgets/framework.dart:957:6)
framework.dart:957
#2      _TokenCheckerState._loadGoogleCredentials (package:botnoivoice/auth/token_checker.dart:98:31)
token_checker.dart:98
<asynchronous suspension>
#3      _TokenCheckerState.initApp (package:botnoivoice/auth/token_checker.dart:51:7)
token_checker.dart:51
<asynchronous suspension>
*/

// Token Management for Google, Apple, LINE, and Email
class TokenChecker extends StatefulWidget {
  const TokenChecker({super.key});

  @override
  State<TokenChecker> createState() => _TokenCheckerState();
}

class _TokenCheckerState extends State<TokenChecker> {
  bool _initialized = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        initApp();
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  /// Function to check how the user logs in and loading data
  Future<void> initApp() async {
    if (_isDisposed) return;

    final appleProvider = Provider.of<AppleLogin>(context, listen: false);
    final googleProvider = Provider.of<GoogleLogin>(context, listen: false);
    final lineProvider = Provider.of<LineLogin>(context, listen: false);
    final emailProvider = Provider.of<EmailLogin>(context, listen: false);

    if (_isDisposed) return;

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

    if (_isDisposed) return;

    /// If no login is found from any provider
    if (mounted) {
      setState(() {
        _initialized = true;
      });
    }
  }

  /// Load data when logging in with Apple
  Future<void> _loadAppleCredentials() async {
    if (_isDisposed) return;

    final appleTokenProvider = Provider.of<AppleToken>(context, listen: false);
    if (!_isDisposed) await appleTokenProvider.loadJwtToken(context);
    if (!_isDisposed) await appleTokenProvider.loadCredentials();
    if (!_isDisposed) await appleTokenProvider.loadRemainingCredits();

    if (!_isDisposed) await configureRevenueCat(context);

    if (mounted) {
      setState(() {
        _initialized = true;
      });
    }
  }

  /// Load data when logging in with Google
  Future<void> _loadGoogleCredentials() async {
    if (_isDisposed) return;

    final googleTokenProvider =
        Provider.of<GoogleToken>(context, listen: false);
    if (!_isDisposed) await googleTokenProvider.loadJwtToken(context);
    if (!_isDisposed) await googleTokenProvider.loadCredentials();
    if (!_isDisposed) await googleTokenProvider.loadRemainingCredits();

    if (!_isDisposed) await configureRevenueCat(context);

    if (mounted) {
      setState(() {
        _initialized = true;
      });
    }
  }

  /// Load data when logging in with LINE
  Future<void> _loadLineCredentials() async {
    if (_isDisposed) return;

    final lineTokenProvider = Provider.of<LineToken>(context, listen: false);
    if (!_isDisposed) await lineTokenProvider.loadJwtToken(context);
    if (!_isDisposed) await lineTokenProvider.loadCredentials();
    if (!_isDisposed) await lineTokenProvider.loadRemainingCredits();

    if (!_isDisposed) await configureRevenueCat(context);

    if (mounted) {
      setState(() {
        _initialized = true;
      });
    }
  }

  /// Load data when logging in with Email
  Future<void> _loadEmailCredentials() async {
    if (_isDisposed) return;

    final emailTokenProvider = Provider.of<EmailToken>(context, listen: false);
    if (!_isDisposed) await emailTokenProvider.loadJwtToken(context);
    if (!_isDisposed) await emailTokenProvider.loadCredentials();
    if (!_isDisposed) await emailTokenProvider.loadRemainingCredits();

    if (!_isDisposed) {
      /// Load get username by email
      String? email =
          Provider.of<EmailLogin>(context, listen: false).getUserEmail;
      await Provider.of<EmailUsernameApi>(context, listen: false)
          .loadGetUsername(email);

      /// Load user info show mail (email permission)
      await Provider.of<CheckUserIsShowEmail>(context, listen: false)
          .getUserInfoShowMail(context);
    }

    if (!_isDisposed) await configureRevenueCat(context);

    if (mounted) {
      setState(() {
        _initialized = true;
      });
    }
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
