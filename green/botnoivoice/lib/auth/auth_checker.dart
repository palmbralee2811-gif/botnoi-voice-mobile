import 'package:botnoivoice/auth/token_checker.dart';
import 'package:botnoivoice/function/open_logout_function.dart';
import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/ui/screen/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

/// Check if the user is authenticated
class AuthChecker extends StatelessWidget {
  AuthChecker({super.key});

  final Logger _logger = Logger(); // For debugging

  @override
  Widget build(BuildContext context) {
    return Consumer4<AppleLogin, GoogleLogin, LineLogin, EmailLogin>(
      builder: (context, appleProvider, googleProvider, lineProvider,
          emailProvider, child) {
        // ตรวจสอบ provider ที่ล็อกอิน
        String? loginProvider;

        if (emailProvider.isAuthenticated &&
            emailProvider.user?.providerData[0].providerId == 'password') {
          // ตรวจสอบสถานะการยืนยันอีเมล
          if (!emailProvider.user!.emailVerified) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              // Logout and Redirect to AuthChecker
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
          return const TokenChecker();
        } else {
          _logger.d("Not Authenticated");
          return const LoginScreen();
        }
      },
    );
  }
}
