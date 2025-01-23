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
import 'package:botnoivoice/presentation/providers/coupon/get_coupon_name.dart'; // Import CouponNameProvider
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
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initApp());
  }

  Future<void> initApp() async {
    final appleProvider = Provider.of<AppleLoginProvider>(context, listen: false);
    final googleProvider = Provider.of<GoogleLoginProvider>(context, listen: false);
    final lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
    final emailProvider = Provider.of<EmailLoginProvider>(context, listen: false);
    final couponNameProvider = Provider.of<CouponNameProvider>(context, listen: false); // Get CouponNameProvider

    if (appleProvider.isLoggedIn && appleProvider.user?.providerData[0].providerId == 'apple.com') {
      await _loadCredentials(appleProvider, Provider.of<AppleTokenProvider>(context, listen: false));
    } else if (googleProvider.isLoggedIn && googleProvider.user?.providerData[0].providerId == 'google.com') {
      await _loadCredentials(googleProvider, Provider.of<GoogleTokenProvider>(context, listen: false));
    } else if (lineProvider.isLoggedIn) {
      await _loadCredentials(lineProvider, Provider.of<LineTokenProvider>(context, listen: false));
    } else if (emailProvider.isLoggedIn && emailProvider.user?.providerData[0].providerId == 'password') {
      await _loadEmailCredentials(emailProvider);
    } else {
      setState(() {
        _initialized = true;
      });
    }

    // Load coupon code name
    await couponNameProvider.loadCodeName(context);
  }

  Future<void> _loadCredentials(dynamic provider, dynamic tokenProvider) async {
    if (!mounted) return;
    await tokenProvider.loadJwtToken(context);
    await tokenProvider.loadCredentials();
    await tokenProvider.loadRemainingCredits();
    await configureRevenueCat(context);

    if (mounted) {
      setState(() {
        _initialized = true;
      });
    }
  }

  Future<void> _loadEmailCredentials(EmailLoginProvider emailProvider) async {
    if (!mounted) return;
    final emailTokenProvider = Provider.of<EmailTokenProvider>(context, listen: false);
    await emailTokenProvider.loadJwtToken(context);
    await emailTokenProvider.loadCredentials();
    await emailTokenProvider.loadRemainingCredits();

    final email = emailProvider.getUserEmail;
    await Provider.of<EmailUsernameApiProvider>(context, listen: false).loadGetUsername(email);
    await Provider.of<UserInfoProvider>(context, listen: false).getUserInfoShowMail(context);
    await configureRevenueCat(context);

    if (mounted) {
      setState(() {
        _initialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _initialized ? const HomeScreen() : const SplashScreen();
  }
}