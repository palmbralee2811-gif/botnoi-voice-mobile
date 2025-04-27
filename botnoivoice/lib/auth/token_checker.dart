import 'package:botnoivoice/config/revenuecat_config.dart';
import 'package:botnoivoice/screen/main/speaker/model/speaker_model.dart';
import 'package:botnoivoice/service/email/check_user_is_show_email.dart';
import 'package:botnoivoice/service/email/email_username_api.dart';
import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/service/notification/push_notification_service.dart';
import 'package:botnoivoice/service/token/apple_token.dart';
import 'package:botnoivoice/service/token/email_token.dart';
import 'package:botnoivoice/service/token/google_token.dart';
import 'package:botnoivoice/service/token/line_token.dart';
import 'package:botnoivoice/screen/main/home/home_screen.dart';
import 'package:botnoivoice/screen/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Token Management for Google, Apple, LINE, and Email. | Json Web Token (JWT),  User Profile, and User Credentials.
///
/// การจัดการ Token สำหรับ Google, Apple, LINE, และ Email | Json Web Token (JWT), ข้อมูลโปรไฟล์ผู้ใช้, และข้อมูลรหัสสำหรับใช้งาน API สร้างเสียง
class TokenChecker extends StatefulWidget {
  const TokenChecker({super.key});

  @override
  State<TokenChecker> createState() => _TokenCheckerState();
}

class _TokenCheckerState extends State<TokenChecker> {
  bool _initialized = false;
  bool _isDisposed = false;

  /// Check is User Subscription (Free or Pro)
  bool _isSubscribed = false;

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

    final appleProvider = context.read<AppleLogin>();
    final googleProvider = context.read<GoogleLogin>();
    final lineProvider = context.read<LineLogin>();
    final emailProvider = context.read<EmailLogin>();

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

    final appleTokenProvider = context.read<AppleToken>();
    if (!_isDisposed) await appleTokenProvider.loadJwtToken(context);
    if (!_isDisposed) await appleTokenProvider.loadCredentials();
    if (!_isDisposed) await appleTokenProvider.loadRemainingCredits();

    // Load Speaker Data by User Subscription (Free or Pro)
    if (!_isDisposed) _isSubscribed = appleTokenProvider.isSubscription;
    await SpeakerModel.loadSpeakers(
        isSubscribed: _isSubscribed, jwtToken: appleTokenProvider.getJwtToken!);

    if (!_isDisposed) await configureRevenueCat(context);

    /// ✅ แก้ไขการเรียก Push Notification Service ให้ตรวจสอบ mounted ก่อน
    if (mounted) {
      Future.delayed(Duration.zero, () async {
        await PushNotificationService.init(context);
      });
    }

    if (mounted) {
      setState(() {
        _initialized = true;
      });
    }
  }

  /// Load data when logging in with Google
  Future<void> _loadGoogleCredentials() async {
    if (_isDisposed) return;

    final googleTokenProvider = context.read<GoogleToken>();
    if (!_isDisposed) await googleTokenProvider.loadJwtToken(context);
    if (!_isDisposed) await googleTokenProvider.loadCredentials();
    if (!_isDisposed) await googleTokenProvider.loadRemainingCredits();

    // Load Speaker Data by User Subscription (Free or Pro)
    if (!_isDisposed) _isSubscribed = googleTokenProvider.isSubscription;
    await SpeakerModel.loadSpeakers(
        isSubscribed: _isSubscribed,
        jwtToken: googleTokenProvider.getJwtToken!);

    if (!_isDisposed) await configureRevenueCat(context);

    /// ✅ แก้ไขการเรียก Push Notification Service ให้ตรวจสอบ mounted ก่อน
    if (mounted) {
      Future.delayed(Duration.zero, () async {
        await PushNotificationService.init(context);
      });
    }

    if (mounted) {
      setState(() {
        _initialized = true;
      });
    }
  }

  /// Load data when logging in with LINE
  Future<void> _loadLineCredentials() async {
    if (_isDisposed) return;

    final lineTokenProvider = context.read<LineToken>();
    if (!_isDisposed) await lineTokenProvider.loadJwtToken(context);
    if (!_isDisposed) await lineTokenProvider.loadCredentials();
    if (!_isDisposed) await lineTokenProvider.loadRemainingCredits();

    // Load Speaker Data by User Subscription (Free or Pro)
    if (!_isDisposed) _isSubscribed = lineTokenProvider.isSubscription;
    await SpeakerModel.loadSpeakers(
        isSubscribed: _isSubscribed, jwtToken: lineTokenProvider.getJwtToken!);

    if (!_isDisposed) await configureRevenueCat(context);

    /// ✅ แก้ไขการเรียก Push Notification Service ให้ตรวจสอบ mounted ก่อน
    if (mounted) {
      Future.delayed(Duration.zero, () async {
        await PushNotificationService.init(context);
      });
    }

    if (mounted) {
      setState(() {
        _initialized = true;
      });
    }
  }

  /// Load data when logging in with Email
  Future<void> _loadEmailCredentials() async {
    if (_isDisposed) return;

    final emailTokenProvider = context.read<EmailToken>();
    if (!_isDisposed) await emailTokenProvider.loadJwtToken(context);
    if (!_isDisposed) await emailTokenProvider.loadCredentials();
    if (!_isDisposed) await emailTokenProvider.loadRemainingCredits();

    // Load Speaker Data by User Subscription (Free or Pro)
    if (!_isDisposed) _isSubscribed = emailTokenProvider.isSubscription;
    await SpeakerModel.loadSpeakers(
        isSubscribed: _isSubscribed, jwtToken: emailTokenProvider.getJwtToken!);

    if (!_isDisposed) {
      /// Load get username by email
      String? email = context.read<EmailLogin>().getUserEmail;
      await context.read<EmailUsernameApi>().loadGetUsername(email);

      /// Load user info show mail (email permission)
      await context.read<CheckUserIsShowEmail>().getUserInfoShowMail(context);
    }

    if (!_isDisposed) await configureRevenueCat(context);

    /// ✅ แก้ไขการเรียก Push Notification Service ให้ตรวจสอบ mounted ก่อน
    if (mounted) {
      Future.delayed(Duration.zero, () async {
        await PushNotificationService.init(context);
      });
    }

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
