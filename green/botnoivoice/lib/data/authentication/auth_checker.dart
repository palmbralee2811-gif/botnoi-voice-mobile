import 'package:botnoivoice/data/authentication/init_screen.dart';
import 'package:botnoivoice/presentation/providers/apple/apple_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class AuthChecker extends StatelessWidget {
  final Logger _logger = Logger();

  AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer4<AppleLoginProvider, GoogleLoginProvider, LineLoginProvider, EmailLoginProvider>(
      builder: (context, appleProvider, googleProvider, lineProvider, emailProvider, child) {
        String? loginProvider = _getLoginProvider(appleProvider, googleProvider, lineProvider, emailProvider);

        if (loginProvider != null) {
          _logger.d('Authenticated with $loginProvider');
          if (loginProvider == 'email' && !emailProvider.user!.emailVerified) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              emailProvider.signOutWithEmail(context);
            });
          }
          return const InitScreen();
        } else {
          _logger.d('Not Authenticated');
          return const LoginScreen();
        }
      },
    );
  }

  String? _getLoginProvider(
    AppleLoginProvider appleProvider,
    GoogleLoginProvider googleProvider,
    LineLoginProvider lineProvider,
    EmailLoginProvider emailProvider,
  ) {
    if (appleProvider.isAuthenticated && appleProvider.user?.providerData[0].providerId == 'apple.com') return 'apple';
    if (googleProvider.isAuthenticated && googleProvider.user?.providerData[0].providerId == 'google.com') return 'google';
    if (lineProvider.isAuthenticated) return 'line';
    if (emailProvider.isAuthenticated && emailProvider.user?.providerData[0].providerId == 'password') return 'email';
    return null;
  }
}