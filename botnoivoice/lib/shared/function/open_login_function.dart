import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/shared/dialog/notification/notification_popup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Open Email Login Screen
void openEmailLogin(BuildContext context) {
  // Redirect to EmailLoginScreen
  context.go('/email-login');
}

/// Open Apple Login Function and Redirect to AuthChecker
Future<void> openAppleLogin(BuildContext context) async {
  try {
    await context.read<AppleLogin>().signInWithApple();
    // Redirect to AuthChecker
    context.go('/auth');
  } catch (e) {
    NotificationPopup(
      context: context,
      text: e.toString(),
    ).showAsError();
  }
}

/// Open Google Login Function and Redirect to AuthChecker
Future<void> openGoogleLogin(BuildContext context) async {
  try {
    await context.read<GoogleLogin>().signInWithGoogle();
    // Redirect to AuthChecker
    context.go('/auth');
  } catch (e) {
    NotificationPopup(
      context: context,
      text: e.toString(),
    ).showAsError();
  }
}

/// Open Line Login Function and Redirect to AuthChecker
Future<void> openLineLogin(BuildContext context) async {
  try {
    await context.read<LineLogin>().signInWithLine();
    // Redirect to AuthChecker
    context.go('/auth');
  } catch (e) {
    NotificationPopup(
      context: context,
      text: e.toString(),
    ).showAsError();
  }
}
