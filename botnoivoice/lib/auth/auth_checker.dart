// import 'package:botnoivoice/auth/internet_checker.dart';
// import 'package:botnoivoice/auth/token_checker.dart';
// import 'package:botnoivoice/shared/function/open_logout_function.dart';
// import 'package:botnoivoice/service/login/apple_login.dart';
// import 'package:botnoivoice/service/login/email_login.dart';
// import 'package:botnoivoice/service/login/google_login.dart';
// import 'package:botnoivoice/service/login/line_login.dart';
// import 'package:botnoivoice/screen/login/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:go_router/go_router.dart';
// import 'package:logger/logger.dart';
// import 'package:provider/provider.dart';

// /// Widget ตรวจสอบสถานะการล็อกอินของผู้ใช้
// /// รองรับการล็อกอินผ่าน Email, Google, Apple, และ Line
// class AuthChecker extends StatelessWidget {
//   AuthChecker({super.key});

//   final Logger _logger = Logger(); // ตัวแปรสำหรับพิมพ์ log
//   final _internetChecker = InternetChecker(); // ใช้เช็คการเชื่อมต่ออินเทอร์เน็ต

//   @override
//   Widget build(BuildContext context) {
//     return Consumer4<AppleLogin, GoogleLogin, LineLogin, EmailLogin>(
//       builder: (
//         context,
//         appleProvider,
//         googleProvider,
//         lineProvider,
//         emailProvider,
//         child,
//       ) {
//         String? loginProvider; // เก็บชื่อ provider ที่ผู้ใช้ล็อกอินสำเร็จ

//         // ตรวจสอบว่าเป็นการล็อกอินด้วย Email หรือไม่
//         if (emailProvider.isAuthenticated &&
//             emailProvider.user?.providerData[0].providerId == 'password') {
//           // ถ้า email ยังไม่ได้ยืนยัน จะบังคับให้ logout และกลับไปที่ Login Screen
//           if (!emailProvider.user!.emailVerified) {
//             // **ข้อควรระวัง**: openEmailLogout ต้องใช้ context ปลอดภัย และเรียกหลัง build เสร็จ
//             SchedulerBinding.instance.addPostFrameCallback((_) {
//               if (context.mounted) {
//                 openEmailLogout(context);
//               }
//             });
//             loginProvider = null; // ไม่นับว่าเป็นการล็อกอินสำเร็จ
//           } else {
//             loginProvider = 'email'; // ล็อกอินด้วย email และยืนยันแล้ว
//           }

//           // ตรวจสอบการล็อกอินผ่าน Line
//         } else if (lineProvider.isAuthenticated) {
//           loginProvider = 'line';

//           // ตรวจสอบการล็อกอินผ่าน Google
//         } else if (googleProvider.isAuthenticated &&
//             googleProvider.user?.providerData[0].providerId == 'google.com') {
//           loginProvider = 'google';

//           // ตรวจสอบการล็อกอินผ่าน Apple
//         } else if (appleProvider.isAuthenticated &&
//             appleProvider.user?.providerData[0].providerId == 'apple.com') {
//           loginProvider = 'apple';
//         }

//         // ถ้าตรวจสอบแล้วพบว่า มีการล็อกอินสำเร็จ
//         if (loginProvider != null) {
//           _logger.d("Authenticated $loginProvider");

//           // เช็ค Internet หลังจาก widget สร้างเสร็จแล้ว
//           SchedulerBinding.instance.addPostFrameCallback((_) {
//             _internetChecker.startListeningToInternetChanges(context,
//                 (isAvailable) {
//               if (!isAvailable) {
//                 // ถ้า internet หลุด พา user ไปหน้า login ทันที
//                 if (context.mounted) {
//                   context.go('/login');
//                 }
//               }
//             });
//           });

//           // เมื่อล็อกอินสำเร็จ และเช็ค internet แล้ว ให้ตรวจสอบ token ต่อ
//           return const TokenChecker();
//         } else {
//           // กรณีไม่ผ่านเงื่อนไขล็อกอิน
//           _logger.d("Not Authenticated");
//           return const LoginScreen(); // ส่งผู้ใช้ไปยังหน้า Login ทันที
//         }
//       },
//     );
//   }
// }















import 'package:botnoivoice/auth/internet_checker.dart';
import 'package:botnoivoice/auth/token_checker.dart';
import 'package:botnoivoice/shared/function/open_logout_function.dart'; 
import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/screen/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

class AuthChecker extends ConsumerWidget {
  AuthChecker({super.key});

  final Logger _logger = Logger();
  final _internetChecker = InternetChecker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch Auth State changes
    final appleNotifier = ref.watch(appleLoginNotifierProvider.notifier);
    final googleNotifier = ref.watch(googleLoginNotifierProvider.notifier);
    final emailNotifier = ref.watch(emailLoginNotifierProvider.notifier);
    final lineState = ref.watch(lineLoginNotifierProvider);

    // 2. Watch User Data (Specific for Email verification check)
    final emailState = ref.watch(emailLoginNotifierProvider);

    String? loginProvider;

    // --- Logic Check Providers ---
    
    // Check Email Login
    if (emailNotifier.isAuthenticated &&
        emailNotifier.user?.providerData[0].providerId == 'password') {
      
      // ตรวจสอบ Email Verification
      if (emailState.user != null && !emailState.user!.emailVerified) {
        // ใช้ Future.microtask เพื่อเลี่ยงการ update state ระหว่าง build
        Future.microtask(() {
          if (context.mounted) {
            // เรียกฟังก์ชัน Logout (ต้องแน่ใจว่า openEmailLogout รองรับ ref หรือ context)
            openEmailLogout(ref); 
          }
        });
        loginProvider = null; // ถือว่ายังไม่ได้ login ที่สมบูรณ์
      } else {
        loginProvider = 'email';
      }

    // Check Google Login
    } else if (googleNotifier.isAuthenticated &&
        googleNotifier.user?.providerData[0].providerId == 'google.com') {
      loginProvider = 'google';

    // Check Apple Login
    } else if (appleNotifier.isAuthenticated &&
        appleNotifier.user?.providerData[0].providerId == 'apple.com') {
      loginProvider = 'apple';

    // Check Line Login
    } else if (lineState.isLoggedIn) {
      loginProvider = 'line';
    }

    // --- Return Widget ---

    if (loginProvider != null) {
      _logger.d("Authenticated with $loginProvider");

      // Internet check logic (ใส่ postFrameCallback เพื่อความปลอดภัย)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _internetChecker.startListeningToInternetChanges(context, (isAvailable) {
          if (!isAvailable && context.mounted) {
            context.go('/login');
          }
        });
      });

      return const TokenChecker();
    } else {
      _logger.d("Not Authenticated");
      return const LoginScreen();
    }
  }
}