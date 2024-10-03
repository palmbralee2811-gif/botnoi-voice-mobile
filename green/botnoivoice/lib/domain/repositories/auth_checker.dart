import 'package:botnoivoice/domain/repositories/init_screen.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Check if the user is authenticated
class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<GoogleLoginProvider, LineLoginProvider, EmailLoginProvider>(
      builder: (context, googleProvider, lineProvider, emailProvider, child) {
        bool isGoogleLogin = googleProvider.isAuthenticated;
        bool isLineLogin = lineProvider.isAuthenticated;
        bool isEmailLogin = emailProvider.isAuthenticated;

        if (isLineLogin || isGoogleLogin || isEmailLogin) {
          return const InitScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

