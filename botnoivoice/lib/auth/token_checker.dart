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









// lib/auth/token_checker.dart (ใช้ Riverpod ConsumerStatefulWidget)
import 'package:botnoivoice/config/revenuecat_config.dart'; // สมมติว่ามี
import 'package:botnoivoice/screen/main/speaker/model/speaker_model.dart'; // สมมติว่ามี
import 'package:botnoivoice/service/email/check_user_is_show_email.dart'; // สมมติว่ามี
import 'package:botnoivoice/service/email/email_username_api.dart'; // สมมติว่ามี
import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/service/notification/push_notification_service.dart'; // สมมติว่ามี
import 'package:botnoivoice/service/token/user_token_notifier.dart'; // **NEW IMPORT**
import 'package:botnoivoice/screen/main/home/home_screen.dart';
import 'package:botnoivoice/screen/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // **NEW IMPORT**

/// Token Management for Google, Apple, LINE, and Email.
class TokenChecker extends ConsumerStatefulWidget { // **เปลี่ยนเป็น ConsumerStatefulWidget**
  const TokenChecker({super.key});

  @override
  ConsumerState<TokenChecker> createState() => _TokenCheckerState();
}

class _TokenCheckerState extends ConsumerState<TokenChecker> { // **ใช้ ConsumerState**
  bool _initialized = false;
  bool _isDisposed = false;
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

    // 1. อ่าน Notifier เพื่อเข้าถึง isAuthenticated และ logic
    final appleNotifier = ref.read(appleLoginNotifierProvider.notifier);
    final googleNotifier = ref.read(googleLoginNotifierProvider.notifier);
    final emailNotifier = ref.read(emailLoginNotifierProvider.notifier);
    final lineState = ref.read(lineLoginNotifierProvider); // Line ใช้ State

    if (_isDisposed) return;

    // 2. ตรวจสอบผู้ให้บริการที่ล็อกอินอยู่ (ใช้ isAuthenticated ที่ถูกต้อง)
    if (appleNotifier.isAuthenticated) {
      await _loadAppleCredentials();
    } else if (googleNotifier.isAuthenticated) {
      await _loadGoogleCredentials();
    } else if (lineState.isLoggedIn) { // Line ยังคงใช้ isLoggedIn จาก State
      await _loadLineCredentials();
    } else if (emailNotifier.isAuthenticated) {
      await _loadEmailCredentials();
    }

    if (_isDisposed) return;

    if (mounted) {
      setState(() {
        _initialized = true;
      });
    }
  }

  /// Load data when logging in with Apple
  Future<void> _loadAppleCredentials() async {
    if (_isDisposed) return;
    
    // ✅ ใช้ Token Notifier ใหม่
    final tokenNotifier = ref.read(appleTokenNotifierProvider.notifier);

    if (!_isDisposed) await tokenNotifier.loadJwtToken();
    if (!_isDisposed) await tokenNotifier.loadCredentials();
    if (!_isDisposed) await tokenNotifier.loadRemainingCredits();

    final tokenState = ref.read(appleTokenNotifierProvider); // อ่าน State
    
    // Load Speaker Data by User Subscription (Free or Pro)
    _isSubscribed = tokenState.isSubscription;
    await SpeakerModel.loadSpeakers(
        isSubscribed: _isSubscribed, 
        jwtToken: tokenState.jwtToken!);

    if (!_isDisposed) await configureRevenueCat(ref);

    if (mounted) {
      Future.delayed(Duration.zero, () async {
        await PushNotificationService.init(ref);
      });
      setState(() {
        _initialized = true;
      });
    }
  }

  /// Load data when logging in with Google
  Future<void> _loadGoogleCredentials() async {
    if (_isDisposed) return;

    final tokenNotifier = ref.read(googleTokenNotifierProvider.notifier);

    if (!_isDisposed) await tokenNotifier.loadJwtToken();
    if (!_isDisposed) await tokenNotifier.loadCredentials();
    if (!_isDisposed) await tokenNotifier.loadRemainingCredits();

    final tokenState = ref.read(googleTokenNotifierProvider);
    
    _isSubscribed = tokenState.isSubscription;
    await SpeakerModel.loadSpeakers(
        isSubscribed: _isSubscribed,
        jwtToken: tokenState.jwtToken!);

    if (!_isDisposed) await configureRevenueCat(ref);

    if (mounted) {
      Future.delayed(Duration.zero, () async {
        await PushNotificationService.init(ref);
      });
      setState(() {
        _initialized = true;
      });
    }
  }

  /// Load data when logging in with LINE
  Future<void> _loadLineCredentials() async {
    if (_isDisposed) return;

    final tokenNotifier = ref.read(lineTokenNotifierProvider.notifier);

    if (!_isDisposed) await tokenNotifier.loadJwtToken();
    if (!_isDisposed) await tokenNotifier.loadCredentials();
    if (!_isDisposed) await tokenNotifier.loadRemainingCredits();

    final tokenState = ref.read(lineTokenNotifierProvider);
    
    _isSubscribed = tokenState.isSubscription;
    await SpeakerModel.loadSpeakers(
        isSubscribed: _isSubscribed, jwtToken: tokenState.jwtToken!);

    if (!_isDisposed) await configureRevenueCat(ref);

    if (mounted) {
      Future.delayed(Duration.zero, () async {
        await PushNotificationService.init(ref);
      });
      setState(() {
        _initialized = true;
      });
    }
  }

  /// Load data when logging in with Email
  Future<void> _loadEmailCredentials() async {
    if (_isDisposed) return;

    final tokenNotifier = ref.read(emailTokenNotifierProvider.notifier);

    // 1. Load Tokens & Credits
    if (!_isDisposed) await tokenNotifier.loadJwtToken();
    if (!_isDisposed) await tokenNotifier.loadCredentials();
    if (!_isDisposed) await tokenNotifier.loadRemainingCredits();

    final tokenState = ref.read(emailTokenNotifierProvider);
    final emailLoginState = ref.read(emailLoginNotifierProvider);

    // 2. Load Speaker Data
    _isSubscribed = tokenState.isSubscription;
    await SpeakerModel.loadSpeakers(
        isSubscribed: _isSubscribed, jwtToken: tokenState.jwtToken!);

    // 3. Load Email Specific Data
    if (!_isDisposed) {
      /// Load get username by email
      String? email = emailLoginState.user?.email; // อ่าน email จาก Login state
      if (email != null) {
          final emailUsernameApiNotifier = ref.read(emailUsernameApiNotifierProvider.notifier);
          await emailUsernameApiNotifier.loadGetUsername(email);
      }
      
      /// Load user info show mail (email permission)
      final checkUserIsShowEmailNotifier = ref.read(checkUserIsShowEmailNotifierProvider.notifier);
      // NOTE: getUserInfoShowMail ไม่ต้องรับ context แล้ว
      await checkUserIsShowEmailNotifier.getUserInfoShowMail(); 
    }

    // 4. Load RevenueCat & Notification
    if (!_isDisposed) await configureRevenueCat(ref);

    if (mounted) {
      Future.delayed(Duration.zero, () async {
        await PushNotificationService.init(ref);
      });
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