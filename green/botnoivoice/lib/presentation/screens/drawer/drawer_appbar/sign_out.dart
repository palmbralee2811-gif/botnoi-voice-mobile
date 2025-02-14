import 'package:botnoivoice/data/authentication/auth_checker.dart';
import 'package:botnoivoice/presentation/providers/apple/apple_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ฟังก์ชันสำหรับการออกจากระบบ
Future<void> signOut(BuildContext context) async {
  final appleProvider = Provider.of<AppleLoginProvider>(context, listen: false);
  final googleProvider =
      Provider.of<GoogleLoginProvider>(context, listen: false);
  final lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
  final emailProvider = Provider.of<EmailLoginProvider>(context, listen: false);

  if (appleProvider.isLoggedIn &&
      appleProvider.user?.providerData[0].providerId == 'apple.com') {
    await appleProvider.signOutWithApple(context);
  }

  if (googleProvider.isLoggedIn &&
      googleProvider.user?.providerData[0].providerId == 'google.com') {
    await googleProvider.signOutWithGoogle(context);
  }

  if (lineProvider.isLoggedIn) {
    await lineProvider.signOutWithLine(context);
  }

  if (emailProvider.isLoggedIn &&
      emailProvider.user?.providerData[0].providerId == 'password') {
    await emailProvider.signOutWithEmail(context);
  }

  // Navigator.of(context).popUntil((route) => route.isFirst);
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => AuthChecker(),
    ),
    (Route<dynamic> route) => false,
  );
}
