import 'package:botnoivoice/config/revenuecat_config.dart';
import 'package:botnoivoice/screen/main/speaker/model/speaker_model.dart';
import 'package:botnoivoice/service/email/check_user_is_show_email.dart';
import 'package:botnoivoice/service/email/email_username_api.dart';
import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/service/notification/push_notification_service.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:botnoivoice/screen/main/home/home_screen.dart';
import 'package:botnoivoice/screen/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenChecker extends ConsumerStatefulWidget {
  const TokenChecker({super.key});

  @override
  ConsumerState<TokenChecker> createState() => _TokenCheckerState();
}

class _TokenCheckerState extends ConsumerState<TokenChecker> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // เริ่มทำงานทันทีหลัง build แรกเสร็จ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initApp();
    });
  }

  /// Function to check how the user logs in and load data
  Future<void> initApp() async {
    if (!mounted) return;

    // 1. อ่าน Notifier เพื่อเข้าถึง isAuthenticated และ logic
    // ใช้ read ตรงนี้ได้เพราะอยู่ใน method ไม่ใช่ build
    final appleNotifier = ref.read(appleLoginNotifierProvider.notifier);
    final googleNotifier = ref.read(googleLoginNotifierProvider.notifier);
    final emailNotifier = ref.read(emailLoginNotifierProvider.notifier);
    final lineState = ref.read(lineLoginNotifierProvider);

    // 2. ตรวจสอบผู้ให้บริการ และเรียกฟังก์ชันโหลดข้อมูล
    // ต้องใส่ await เพื่อรอให้ process จบก่อน setState
    if (appleNotifier.isAuthenticated) {
      await _loadCredentials(
        tokenNotifierProvider: appleTokenNotifierProvider,
        providerType: 'apple',
      );
    } else if (googleNotifier.isAuthenticated) {
      await _loadCredentials(
        tokenNotifierProvider: googleTokenNotifierProvider,
        providerType: 'google',
      );
    } else if (lineState.isLoggedIn) {
      await _loadCredentials(
        tokenNotifierProvider: lineTokenNotifierProvider,
        providerType: 'line',
      );
    } else if (emailNotifier.isAuthenticated) {
      await _loadEmailCredentials();
    }

    if (!mounted) return;

    setState(() {
      _initialized = true;
    });
  }

  /// Refactored: Generic load function for Apple, Google, Line (Logic เหมือนกัน)
  Future<void> _loadCredentials({
    required tokenNotifierProvider,
    required String providerType,
  }) async {
    if (!mounted) return;

    final tokenNotifier = ref.read(tokenNotifierProvider.notifier);

    // 1. Load Tokens
    await tokenNotifier.loadJwtToken();
    if (!mounted) return; // **สำคัญ** เช็ค mounted หลัง await ทุกครั้ง

    await tokenNotifier.loadCredentials();
    if (!mounted) return;

    await tokenNotifier.loadRemainingCredits();
    if (!mounted) return;

    // 2. Load Speaker Data
    // อ่านค่า State ล่าสุด (หลังจาก load เสร็จ)
    final tokenState = ref.read(tokenNotifierProvider);
    final isSubscribed = tokenState.isSubscription;
    final jwtToken = tokenState.jwtToken;

    if (jwtToken != null) {
      await SpeakerModel.loadSpeakers(
        isSubscribed: isSubscribed,
        jwtToken: jwtToken,
      );
    }
    if (!mounted) return;

    // 3. RevenueCat & Notification
    await configureRevenueCat(ref);
    if (!mounted) return;

    await PushNotificationService.init(ref);
  }

  /// Specific load function for Email (มี logic เพิ่มเติม)
  Future<void> _loadEmailCredentials() async {
    if (!mounted) return;

    final tokenNotifier = ref.read(emailTokenNotifierProvider.notifier);

    // 1. Load Tokens
    await tokenNotifier.loadJwtToken();
    if (!mounted) return;

    await tokenNotifier.loadCredentials();
    if (!mounted) return;

    await tokenNotifier.loadRemainingCredits();
    if (!mounted) return;

    // 2. Load Speaker Data
    final tokenState = ref.read(emailTokenNotifierProvider);
    if (tokenState.jwtToken != null) {
      await SpeakerModel.loadSpeakers(
        isSubscribed: tokenState.isSubscription,
        jwtToken: tokenState.jwtToken!,
      );
    }
    if (!mounted) return;

    // 3. Load Email Specific Data
    final emailLoginState = ref.read(emailLoginNotifierProvider);
    String? email = emailLoginState.user?.email;

    if (email != null) {
      final emailUsernameApiNotifier = ref.read(emailUsernameApiNotifierProvider.notifier);
      await emailUsernameApiNotifier.loadGetUsername(email);
    }
    if (!mounted) return;

    // Load user info show mail permission
    final checkUserIsShowEmailNotifier = ref.read(checkUserIsShowEmailNotifierProvider.notifier);
    await checkUserIsShowEmailNotifier.getUserInfoShowMail();
    if (!mounted) return;

    // 4. RevenueCat & Notification
    await configureRevenueCat(ref);
    if (!mounted) return;

    await PushNotificationService.init(ref);
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