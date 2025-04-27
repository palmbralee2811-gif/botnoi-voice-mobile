import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/shared/dialog/notification/notification_popup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Open Email Logout Function and Redirect to `login_screen.dart`
Future<void> openEmailLogout(BuildContext context) async {
  try {
    await context.read<EmailLogin>().signOutWithEmail(context);
    // Redirect to `login_screen.dart`
    context.go('/login');
  } catch (e) {
    NotificationPopup(
      context: context,
      text: e.toString(),
    ).showAsError();
  }
}

/// Open Apple Logout Function and Redirect to `login_screen.dart`
Future<void> openAppleLogout(BuildContext context) async {
  try {
    await context.read<AppleLogin>().signOutWithApple(context);
    // Redirect to `login_screen.dart`
    context.go('/login');
  } catch (e) {
    NotificationPopup(
      context: context,
      text: e.toString(),
    ).showAsError();
  }
}

/// Open Google Logout Function and Redirect to `login_screen.dart`
Future<void> openGoogleLogout(BuildContext context) async {
  try {
    await context.read<GoogleLogin>().signOutWithGoogle(context);
    // Redirect to `login_screen.dart`
    context.go('/login');
  } catch (e) {
    NotificationPopup(
      context: context,
      text: e.toString(),
    ).showAsError();
  }
}

/// Open Line Logout Function and Redirect to `login_screen.dart`
Future<void> openLineLogout(BuildContext context) async {
  try {
    await context.read<LineLogin>().signOutWithLine(context);
    // Redirect to `login_screen.dart`
    context.go('/login');
  } catch (e) {
    NotificationPopup(
      context: context,
      text: e.toString(),
    ).showAsError();
  }
}
