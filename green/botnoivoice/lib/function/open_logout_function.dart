import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/ui/dialog/notification/notification_popup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Open Email Logout Function and Redirect to AuthChecker
Future<void> openEmailLogout(BuildContext context) async {
  try {
    await Provider.of<EmailLogin>(context, listen: false).signOutWithEmail(context);
    // Redirect to AuthChecker
    context.go('/auth');
  } catch (e) {
    NotificationPopup(
      context: context,
      text: e.toString(),
    ).showAsError();
  }
}

/// Open Apple Logout Function and Redirect to AuthChecker
Future<void> openAppleLogout(BuildContext context) async {
  try {
    await Provider.of<AppleLogin>(context, listen: false).signOutWithApple(context);
    // Redirect to AuthChecker
    context.go('/auth');
  } catch (e) {
    NotificationPopup(
      context: context,
      text: e.toString(),
    ).showAsError();
  }
}

/// Open Google Logout Function and Redirect to AuthChecker
Future<void> openGoogleLogout(BuildContext context) async {
  try {
    await Provider.of<GoogleLogin>(context, listen: false).signOutWithGoogle(context);
    // Redirect to AuthChecker
    context.go('/auth');
  } catch (e) {
    NotificationPopup(
      context: context,
      text: e.toString(),
    ).showAsError();
  }
}

/// Open Line Logout Function and Redirect to AuthChecker
Future<void> openLineLogout(BuildContext context) async {
  try {
    await Provider.of<LineLogin>(context, listen: false).signOutWithLine(context);
    // Redirect to AuthChecker
    context.go('/auth');
  } catch (e) {
    NotificationPopup(
      context: context,
      text: e.toString(),
    ).showAsError();
  }
}
