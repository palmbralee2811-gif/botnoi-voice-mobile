import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/shared/dialog/notification/notification_popup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Open Email Logout Function and Redirect to `login_screen.dart`
Future<void> openEmailLogout(WidgetRef ref) async {
  try {
    // await context.read<EmailLogin>().signOutWithEmail(context);
    await ref.read(emailLoginNotifierProvider.notifier).signOutWithEmail(ref);
    // Redirect to `login_screen.dart`
    ref.context.go('/login');
  } catch (e) {
    NotificationPopup(
      context: ref.context,
      text: e.toString(),
    ).showAsError();
  }
}

/// Open Apple Logout Function and Redirect to `login_screen.dart`
Future<void> openAppleLogout(WidgetRef ref) async {
  try {
    // await context.read<AppleLogin>().signOutWithApple(context);
    await ref.read(appleLoginNotifierProvider.notifier).signOutWithApple(ref);
    // Redirect to `login_screen.dart`
    ref.context.go('/login');
  } catch (e) {
    NotificationPopup(
      context: ref.context,
      text: e.toString(),
    ).showAsError();
  }
}

/// Open Google Logout Function and Redirect to `login_screen.dart`
Future<void> openGoogleLogout(WidgetRef ref) async {
  try {
    // await context.read<GoogleLogin>().signOutWithGoogle(context);
    await ref.read(googleLoginNotifierProvider.notifier).signOutWithGoogle(ref);
    // Redirect to `login_screen.dart`
    ref.context.go('/login');
  } catch (e) {
    NotificationPopup(
      context: ref.context,
      text: e.toString(),
    ).showAsError();
  }
}

/// Open Line Logout Function and Redirect to `login_screen.dart`
Future<void> openLineLogout(WidgetRef ref) async {
  try {
    // await context.read<LineLogin>().signOutWithLine(context);
    await ref.read(lineLoginNotifierProvider.notifier).signOutWithLine(ref);
    // Redirect to `login_screen.dart`
    ref.context.go('/login');
  } catch (e) {
    NotificationPopup(
      context: ref.context,
      text: e.toString(),
    ).showAsError();
  }
}
