import 'package:botnoivoice/domain/repositories/init_screen.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/screens/login/login_screen.dart';
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
    return Consumer3<GoogleLoginProvider, LineLoginProvider,
        EmailLoginProvider>(
      builder: (context, googleProvider, lineProvider, emailProvider, child) {
        // ตรวจสอบ provider ที่ล็อกอิน
        String? loginProvider;

        if (emailProvider.isAuthenticated &&
            emailProvider.user?.providerData[0].providerId == 'password') {
          // ตรวจสอบสถานะการยืนยันอีเมล
          if (!emailProvider.user!.emailVerified) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              emailProvider.signOutWithEmail(context); // ออกจากระบบหากยังไม่ได้ยืนยันอีเมล
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
        }

        // ตรวจสอบสถานะการล็อกอิน
        if (loginProvider != null) {
          _logger.d("Authenticated $loginProvider");
          return const InitScreen();
        } else {
          _logger.d("Not Authenticated");
          return const LoginScreen();
        }
      },
    );
  }
}
