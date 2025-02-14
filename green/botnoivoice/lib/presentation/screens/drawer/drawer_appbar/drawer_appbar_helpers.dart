import 'package:botnoivoice/data/authentication/auth_checker.dart';
import 'package:botnoivoice/presentation/providers/apple/apple_login_provider.dart';
import 'package:botnoivoice/presentation/providers/apple/apple_token_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_token_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_username_api_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_token_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_token_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

final _logger = Logger();

Future<void> drawerAppbarLoadUserInfo(
    BuildContext context,
    ValueNotifier<String> displayNameNotifier,
    ValueNotifier<String> uidNotifier,
    ValueNotifier<String> profilePictureUrlNotifier) async {
  try {
    // Fetch user data from Firebase
    var lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
    var appleProvider = Provider.of<AppleLoginProvider>(context, listen: false);
    var googleProvider =
        Provider.of<GoogleLoginProvider>(context, listen: false);
    var emailProvider = Provider.of<EmailLoginProvider>(context, listen: false);

    // Fetch user data from Database (API)
    var appleTokenProvider =
        Provider.of<AppleTokenProvider>(context, listen: false);
    var googleTokenProvider =
        Provider.of<GoogleTokenProvider>(context, listen: false);
    var lineTokenProvider =
        Provider.of<LineTokenProvider>(context, listen: false);
    var emailTokenProvider =
        Provider.of<EmailTokenProvider>(context, listen: false);

    if (lineProvider.isLoggedIn) {
      displayNameNotifier.value = lineProvider.getDisplayName ?? 'No Name';
      uidNotifier.value = lineTokenProvider.getUserID ?? 'No UID';
      profilePictureUrlNotifier.value = lineProvider.getProfilePictureUrl ?? '';
    } else if (appleProvider.isLoggedIn) {
      displayNameNotifier.value =
          appleProvider.user?.displayName ?? 'Apple User';
      uidNotifier.value = appleTokenProvider.getUserID ?? 'No UID';
      profilePictureUrlNotifier.value = appleProvider.user?.photoURL ?? '';
    } else if (googleProvider.isLoggedIn) {
      displayNameNotifier.value = googleProvider.user?.displayName ?? 'No Name';
      uidNotifier.value = googleTokenProvider.getUserID ?? 'No UID';
      profilePictureUrlNotifier.value = googleProvider.user?.photoURL ?? '';
    } else if (emailProvider.isLoggedIn) {
      displayNameNotifier.value =
          Provider.of<EmailUsernameApiProvider>(context, listen: false)
                  .getUsername ??
              'Email User';
      uidNotifier.value = emailTokenProvider.getUserID ?? 'No UID';
      profilePictureUrlNotifier.value = emailProvider.user?.photoURL ?? '';
    } else {
      _logger.e("No provider is logged in");
    }
    _logger.d("User info loaded successfully");
  } catch (e) {
    _logger.e("Error loading user info: $e");
  }
}

/// ฟังก์ชันสำหรับการออกจากระบบ
Future<void> drawerAppbarSignOut(BuildContext context) async {
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
