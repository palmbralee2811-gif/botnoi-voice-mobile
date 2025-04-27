import 'package:botnoivoice/auth/internet_checker.dart';
import 'package:botnoivoice/auth/token_checker.dart';
import 'package:botnoivoice/shared/function/open_logout_function.dart';
import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/screen/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

/// Check if the user is authenticated.
/// Who is User Login with Email, Google, Apple, or LINE.
/// 
/// ตรวจสอบว่าผู้ใช้ล็อกอินแล้วหรือยัง
/// ใครเป็นผู้ใช้ที่ล็อกอินด้วยอีเมล, กูเกิ้ล, แอปเปิ้ล, หรือไลน์
class AuthChecker extends StatelessWidget {
  AuthChecker({super.key});

  final Logger _logger = Logger(); // For debugging
  final _internetChecker = InternetChecker(); // For checking internet connection

  @override
  Widget build(BuildContext context) {
    return Consumer4<AppleLogin, GoogleLogin, LineLogin, EmailLogin>(builder: (context, appleProvider, googleProvider, lineProvider, emailProvider, child) {
        // ตรวจสอบ provider ที่ล็อกอิน
        String? loginProvider;

        if (emailProvider.isAuthenticated &&
            emailProvider.user?.providerData[0].providerId == 'password') {
          // ตรวจสอบสถานะการยืนยันอีเมล
          if (!emailProvider.user!.emailVerified) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              // Logout and Redirect to `login_screen.dart`
              openEmailLogout(context);
            });
            loginProvider = null;
          } else {
            loginProvider = 'email';
          }
        } else if (lineProvider.isAuthenticated) {
          loginProvider = 'line';
        } else if (googleProvider.isAuthenticated &&
            googleProvider.user?.providerData[0].providerId == 'google.com') {
          loginProvider = 'google';
        } else if (appleProvider.isAuthenticated &&
            appleProvider.user?.providerData[0].providerId == 'apple.com') {
          loginProvider = 'apple';
        }

        // ตรวจสอบสถานะการล็อกอิน
        if (loginProvider != null) {
          _logger.d("Authenticated $loginProvider");

          /*
          TODO: Fix this error
          [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: This BuildContext is no longer valid.
The showDialog function context parameter is a BuildContext that is no longer valid.
This can commonly occur when the showDialog function is called after awaiting a Future. In this situation the BuildContext might refer to a widget that has already been disposed during the await. Consider using a parent context instead.
#0      _debugIsActive (package:flutter/src/material/dialog.dart:1499:5)
dialog.dart:1499
#1      showDialog (package:flutter/src/material/dialog.dart:1420:10)
dialog.dart:1420
#2      NotificationDialog._showModal (package:botnoivoice/ui/dialog/notification/notification_dialog.dart:28:5)
notification_dialog.dart:28
#3      NotificationDialog.showErrorModal (package:botnoivoice/ui/dialog/notification/notification_dialog.dart:96:5)
notification_dialog.dart:96
#4      InternetChecker.startListeningToInternetChanges.<anonymous closure> (package:botnoivoice/auth/internet_checker.dart:26:13)
internet_checker.dart:26
#5      _RootZone.runUnaryGuarded (dart:async/zone.dart:1594:10)
zone.dart:1594
#6      _Buffe<…>
          */
          _internetChecker.startListeningToInternetChanges(context, (isAvailable) {
            if (!isAvailable) {
              return const LoginScreen();
            }
          });
          return const TokenChecker();
        } else {
          _logger.d("Not Authenticated");
          return const LoginScreen();
        }
      },
    );
  }
}
