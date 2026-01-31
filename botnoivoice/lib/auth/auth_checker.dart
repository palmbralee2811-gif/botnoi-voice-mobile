import 'package:botnoivoice/auth/token_checker.dart';
import 'package:botnoivoice/shared/function/open_logout_function.dart';
import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/screen/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class AuthChecker extends ConsumerWidget {
  AuthChecker({super.key});

  final Logger _logger = Logger();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch Auth State changes (แก้ไข: Watch State โดยตรงเพื่อให้ UI Rebuild)
    final appleState = ref.watch(appleLoginNotifierProvider);
    final googleState = ref.watch(googleLoginNotifierProvider);
    final emailState = ref.watch(emailLoginNotifierProvider);
    final lineState = ref.watch(lineLoginNotifierProvider);

    String? loginProvider;

    // --- Logic Check Providers ---
    // ใช้ State ที่ได้มาตรวจสอบสถานะ isLoggedIn และ User Data โดยตรง

    // Check Email Login
    if (emailState.isLoggedIn &&
        emailState.user?.providerData.isNotEmpty == true &&
        emailState.user?.providerData[0].providerId == 'password') {
      
      // ตรวจสอบ Email Verification
      if (emailState.user != null && !emailState.user!.emailVerified) {
        // ใช้ Future.microtask เพื่อเลี่ยงการ update state ระหว่าง build
        Future.microtask(() {
          if (context.mounted) {
            // เรียกฟังก์ชัน Logout
            openEmailLogout(ref); 
          }
        });
        loginProvider = null; // ถือว่ายังไม่ได้ login ที่สมบูรณ์
      } else {
        loginProvider = 'email';
      }

    // Check Google Login
    } else if (googleState.isLoggedIn &&
        googleState.user?.providerData.isNotEmpty == true &&
        googleState.user?.providerData[0].providerId == 'google.com') {
      loginProvider = 'google';

    // Check Apple Login
    } else if (appleState.isLoggedIn &&
        appleState.user?.providerData.isNotEmpty == true &&
        appleState.user?.providerData[0].providerId == 'apple.com') {
      loginProvider = 'apple';

    // Check Line Login
    } else if (lineState.isLoggedIn) {
      loginProvider = 'line';
    }

    // --- Return Widget ---

    if (loginProvider != null) {
      _logger.d("Authenticated with $loginProvider");

      return const TokenChecker();
    } else {
      _logger.d("Not Authenticated");
      return const LoginScreen();
    }
  }
}