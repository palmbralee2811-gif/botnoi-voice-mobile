// import 'package:botnoivoice/config/revenuecat_config.dart';
// import 'package:botnoivoice/screen/main/speaker/model/speaker_model.dart';
// import 'package:botnoivoice/service/email/check_user_is_show_email.dart';
// import 'package:botnoivoice/service/email/email_username_api.dart';
// import 'package:botnoivoice/service/login/apple_login.dart';
// import 'package:botnoivoice/service/login/email_login.dart';
// import 'package:botnoivoice/service/login/google_login.dart';
// import 'package:botnoivoice/service/login/line_login.dart';
// import 'package:botnoivoice/service/notification/push_notification_service.dart';
// import 'package:botnoivoice/service/token/apple_token.dart';
// import 'package:botnoivoice/service/token/email_token.dart';
// import 'package:botnoivoice/service/token/google_token.dart';
// import 'package:botnoivoice/service/token/line_token.dart';
// import 'package:botnoivoice/screen/main/home/home_screen.dart';
// import 'package:botnoivoice/screen/splash/splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// /// Token Management for Google, Apple, LINE, and Email. | Json Web Token (JWT),  User Profile, and User Credentials.
// ///
// /// การจัดการ Token สำหรับ Google, Apple, LINE, และ Email | Json Web Token (JWT), ข้อมูลโปรไฟล์ผู้ใช้, และข้อมูลรหัสสำหรับใช้งาน API สร้างเสียง
// class TokenChecker extends StatefulWidget {
//   const TokenChecker({super.key});

//   @override
//   State<TokenChecker> createState() => _TokenCheckerState();
// }

// class _TokenCheckerState extends State<TokenChecker> {
//   bool _initialized = false;
//   bool _isDisposed = false;

//   /// Check is User Subscription (Free or Pro)
//   bool _isSubscribed = false;

//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       if (mounted) {
//         initApp();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _isDisposed = true;
//     super.dispose();
//   }

//   /// Function to check how the user logs in and loading data
//   Future<void> initApp() async {
//     if (_isDisposed) return;

//     final appleProvider = context.read<AppleLogin>();
//     final googleProvider = context.read<GoogleLogin>();
//     final lineProvider = context.read<LineLogin>();
//     final emailProvider = context.read<EmailLogin>();

//     if (_isDisposed) return;

//     /// Check if the user logs in with Apple
//     if (appleProvider.isLoggedIn &&
//         appleProvider.user?.providerData[0].providerId == 'apple.com') {
//       await _loadAppleCredentials();
//       return;
//     }

//     /// Check if the user logs in with Google
//     if (googleProvider.isLoggedIn &&
//         googleProvider.user?.providerData[0].providerId == 'google.com') {
//       await _loadGoogleCredentials();
//       return;
//     }

//     /// Check if the user logs in with LINE
//     if (lineProvider.isLoggedIn) {
//       await _loadLineCredentials();
//       return;
//     }

//     /// Check if the user logs in with Email
//     if (emailProvider.isLoggedIn &&
//         emailProvider.user?.providerData[0].providerId == 'password') {
//       await _loadEmailCredentials();
//       return;
//     }

//     if (_isDisposed) return;

//     /// If no login is found from any provider
//     if (mounted) {
//       setState(() {
//         _initialized = true;
//       });
//     }
//   }

//   /// Load data when logging in with Apple
//   Future<void> _loadAppleCredentials() async {
//     if (_isDisposed) return;

//     final appleTokenProvider = context.read<AppleToken>();
//     if (!_isDisposed) await appleTokenProvider.loadJwtToken(context);
//     if (!_isDisposed) await appleTokenProvider.loadCredentials();
//     if (!_isDisposed) await appleTokenProvider.loadRemainingCredits();

//     // Load Speaker Data by User Subscription (Free or Pro)
//     if (!_isDisposed) _isSubscribed = appleTokenProvider.isSubscription;
//     await SpeakerModel.loadSpeakers(
//         isSubscribed: _isSubscribed, jwtToken: appleTokenProvider.getJwtToken!);

//     if (!_isDisposed) await configureRevenueCat(context);

//     /// ✅ แก้ไขการเรียก Push Notification Service ให้ตรวจสอบ mounted ก่อน
//     if (mounted) {
//       Future.delayed(Duration.zero, () async {
//         await PushNotificationService.init(context);
//       });
//     }

//     if (mounted) {
//       setState(() {
//         _initialized = true;
//       });
//     }
//   }

//   /// Load data when logging in with Google
//   Future<void> _loadGoogleCredentials() async {
//     if (_isDisposed) return;

//     final googleTokenProvider = context.read<GoogleToken>();
//     if (!_isDisposed) await googleTokenProvider.loadJwtToken(context);
//     if (!_isDisposed) await googleTokenProvider.loadCredentials();
//     if (!_isDisposed) await googleTokenProvider.loadRemainingCredits();

//     // Load Speaker Data by User Subscription (Free or Pro)
//     if (!_isDisposed) _isSubscribed = googleTokenProvider.isSubscription;
//     await SpeakerModel.loadSpeakers(
//         isSubscribed: _isSubscribed,
//         jwtToken: googleTokenProvider.getJwtToken!);

//     if (!_isDisposed) await configureRevenueCat(context);

//     /// ✅ แก้ไขการเรียก Push Notification Service ให้ตรวจสอบ mounted ก่อน
//     if (mounted) {
//       Future.delayed(Duration.zero, () async {
//         await PushNotificationService.init(context);
//       });
//     }

//     if (mounted) {
//       setState(() {
//         _initialized = true;
//       });
//     }
//   }

//   /// Load data when logging in with LINE
//   Future<void> _loadLineCredentials() async {
//     if (_isDisposed) return;

//     final lineTokenProvider = context.read<LineToken>();
//     if (!_isDisposed) await lineTokenProvider.loadJwtToken(context);
//     if (!_isDisposed) await lineTokenProvider.loadCredentials();
//     if (!_isDisposed) await lineTokenProvider.loadRemainingCredits();

//     // Load Speaker Data by User Subscription (Free or Pro)
//     if (!_isDisposed) _isSubscribed = lineTokenProvider.isSubscription;
//     await SpeakerModel.loadSpeakers(
//         isSubscribed: _isSubscribed, jwtToken: lineTokenProvider.getJwtToken!);

//     if (!_isDisposed) await configureRevenueCat(context);

//     /// ✅ แก้ไขการเรียก Push Notification Service ให้ตรวจสอบ mounted ก่อน
//     if (mounted) {
//       Future.delayed(Duration.zero, () async {
//         await PushNotificationService.init(context);
//       });
//     }

//     if (mounted) {
//       setState(() {
//         _initialized = true;
//       });
//     }
//   }

//   /// Load data when logging in with Email
//   Future<void> _loadEmailCredentials() async {
//     if (_isDisposed) return;

//     final emailTokenProvider = context.read<EmailToken>();
//     if (!_isDisposed) await emailTokenProvider.loadJwtToken(context);
//     if (!_isDisposed) await emailTokenProvider.loadCredentials();
//     if (!_isDisposed) await emailTokenProvider.loadRemainingCredits();

//     // Load Speaker Data by User Subscription (Free or Pro)
//     if (!_isDisposed) _isSubscribed = emailTokenProvider.isSubscription;
//     await SpeakerModel.loadSpeakers(
//         isSubscribed: _isSubscribed, jwtToken: emailTokenProvider.getJwtToken!);

//     if (!_isDisposed) {
//       /// Load get username by email
//       String? email = context.read<EmailLogin>().getUserEmail;
//       await context.read<EmailUsernameApi>().loadGetUsername(email);

//       /// Load user info show mail (email permission)
//       await context.read<CheckUserIsShowEmail>().getUserInfoShowMail(context);
//     }

//     if (!_isDisposed) await configureRevenueCat(context);

//     /// ✅ แก้ไขการเรียก Push Notification Service ให้ตรวจสอบ mounted ก่อน
//     if (mounted) {
//       Future.delayed(Duration.zero, () async {
//         await PushNotificationService.init(context);
//       });
//     }

//     if (mounted) {
//       setState(() {
//         _initialized = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_initialized) {
//       return const HomeScreen();
//     } else {
//       return const SplashScreen();
//     }
//   }
// }






















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
import 'package:botnoivoice/service/token/user_token_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenChecker extends ConsumerStatefulWidget {
  const TokenChecker({super.key});

  @override
  ConsumerState<TokenChecker> createState() => _TokenCheckerState();
}

class _TokenCheckerState extends ConsumerState<TokenChecker> {
  bool _initialized = false;
  // ไม่จำเป็นต้องใช้ _isDisposed เอง เพราะ ConsumerState มี property "mounted" ให้ใช้อยู่แล้ว

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