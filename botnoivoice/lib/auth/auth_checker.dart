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









// lib/auth/auth_checker.dart (ใช้ Riverpod ConsumerWidget)
import 'package:botnoivoice/auth/internet_checker.dart';
import 'package:botnoivoice/auth/token_checker.dart';
import 'package:botnoivoice/shared/function/open_logout_function.dart'; // สมมติว่ามี
import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/screen/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // **NEW IMPORT**
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

/// Widget ตรวจสอบสถานะการล็อกอินของผู้ใช้
class AuthChecker extends ConsumerWidget { // **เปลี่ยนเป็น ConsumerWidget**
  AuthChecker({super.key});

  final Logger _logger = Logger();
  final _internetChecker = InternetChecker();

  @override
  Widget build(BuildContext context, WidgetRef ref) { // **รับ WidgetRef**
    
    // 1. WATCH Notifiers เพื่อดึงสถานะและ logic isAuthenticated
    final appleNotifier = ref.watch(appleLoginNotifierProvider.notifier);
    final googleNotifier = ref.watch(googleLoginNotifierProvider.notifier);
    final emailNotifier = ref.watch(emailLoginNotifierProvider.notifier);
    final lineState = ref.watch(lineLoginNotifierProvider); // Line ใช้ State เพราะไม่มี isAuthenticated ใน Notifier Base

    // 2. WATCH State เพื่อดึงข้อมูล User/isLoggedIn
    final emailState = ref.watch(emailLoginNotifierProvider);

    String? loginProvider;

    // ตรวจสอบว่าเป็นการล็อกอินด้วย Email หรือไม่ (ใช้ isAuthenticated จาก Notifier)
    if (emailNotifier.isAuthenticated && emailNotifier.user?.providerData[0].providerId == 'password') {
      // ถ้า email ยังไม่ได้ยืนยัน จะบังคับให้ logout
      if (emailState.user != null && !emailState.user!.emailVerified) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            // openEmailLogout ต้องถูกปรับให้ใช้ Riverpod/Ref เพื่อสั่ง Sign Out ได้
            openEmailLogout(ref); 
          }
        });
        loginProvider = null;
      } else {
        loginProvider = 'email';
      }

    // ตรวจสอบการล็อกอินผ่าน Google
    } else if (googleNotifier.isAuthenticated && googleNotifier.user?.providerData[0].providerId == 'google.com') {
      loginProvider = 'google';

    // ตรวจสอบการล็อกอินผ่าน Apple
    } else if (appleNotifier.isAuthenticated && appleNotifier.user?.providerData[0].providerId == 'apple.com') {
      loginProvider = 'apple';

    // ตรวจสอบการล็อกอินผ่าน Line
    } else if (lineState.isLoggedIn) {
      loginProvider = 'line';
    }


    if (loginProvider != null) {
      _logger.d("Authenticated $loginProvider");

      SchedulerBinding.instance.addPostFrameCallback((_) {
        _internetChecker.startListeningToInternetChanges(context,
            (isAvailable) {
          if (!isAvailable) {
            if (context.mounted) {
              context.go('/login');
            }
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