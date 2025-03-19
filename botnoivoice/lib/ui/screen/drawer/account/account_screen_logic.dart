import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/token/apple_token.dart';
import 'package:botnoivoice/service/email/email_forget_password.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/token/email_token.dart';
import 'package:botnoivoice/service/email/email_username_api.dart';
import 'package:botnoivoice/ui/screen/drawer/account/get_user_email.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/token/google_token.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/service/token/line_token.dart';
import 'package:botnoivoice/service/email/check_user_is_show_email.dart';
import 'package:botnoivoice/ui/style/style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class AccountScreenLogic {
  final Logger _logger = Logger(); // Debugging

  /// Display Loading Dialog
  Future<void> _showLoadingDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Display Notification with Snackbar
  void _showSnackbar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message.tr()),
        backgroundColor: color,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  /// Signs out the user from the currently active authentication provider.
  Future<void> _signOutProvider(BuildContext context) async {
    final appleProvider = Provider.of<AppleLogin>(context, listen: false);
    final googleProvider = Provider.of<GoogleLogin>(context, listen: false);
    final lineProvider = Provider.of<LineLogin>(context, listen: false);
    final emailProvider = Provider.of<EmailLogin>(context, listen: false);

    if (appleProvider.isLoggedIn) {
      _logger.d("Signing out from Apple...");
      await appleProvider.signOutWithApple(context);
    }
    if (googleProvider.isLoggedIn) {
      _logger.d("Signing out from Google...");
      await googleProvider.signOutWithGoogle(context);
    }
    if (lineProvider.isLoggedIn) {
      _logger.d("Signing out from LINE...");
      await lineProvider.signOutWithLine(context);
    }
    if (emailProvider.isLoggedIn) {
      _logger.d("Signing out from Email...");
      await emailProvider.signOutWithEmail(context);
    }
  }

  /// Calling Sign Out Method, Dialog and Snackbar
  Future<void> signOut(BuildContext context) async {
    _logger.i("Sign out process started...");
    _showLoadingDialog(context);

    try {
      await _signOutProvider(context);
      _logger.i("User signed out successfully.");
      context.pop(); // Close Loading Dialog
      _showSnackbar(context, 'Sign out successfully', kDarkGray);
      context.go('/login'); // Redirect to `login_screen.dart`
    } catch (e) {
      _logger.e("Error during sign out: $e");
      context.pop(); // Close Loading Dialog
      _showSnackbar(context, 'Sign out failed', Colors.red);
    }
  }

  /// Loading User Information
  Future<void> loadUserInfo({
    required BuildContext context,
    required Function(
      String displayName,
      String userId,
      String email,
      bool isEmailLoggedIn,
      bool isAppleLoggedIn,
      bool isGoogleLoggedIn,
      bool isLineLoggedIn,
    ) onUpdateState,
  }) async {
    var appleProvider = Provider.of<AppleLogin>(context, listen: false);
    var googleProvider = Provider.of<GoogleLogin>(context, listen: false);
    var lineProvider = Provider.of<LineLogin>(context, listen: false);
    var emailProvider = Provider.of<EmailLogin>(context, listen: false);
    var userInfoProvider =
        Provider.of<CheckUserIsShowEmail>(context, listen: false);

    var appleTokenProvider = Provider.of<AppleToken>(context, listen: false);
    var googleTokenProvider = Provider.of<GoogleToken>(context, listen: false);
    var lineTokenProvider = Provider.of<LineToken>(context, listen: false);
    var emailTokenProvider = Provider.of<EmailToken>(context, listen: false);

    String displayName = "Loading...";
    String userId = "Loading...";
    String email = "Loading...";
    bool isEmailLoggedIn = false;
    bool isAppleLoggedIn = false;
    bool isGoogleLoggedIn = false;
    bool isLineLoggedIn = false;

    if (lineProvider.isLoggedIn) {
      displayName = lineProvider.getDisplayName ?? "Line User";
      userId = lineTokenProvider.getUserID ?? "No UID";
      email = lineProvider.getLineEmail ?? "No email found";
      isLineLoggedIn = true;
    } else if (appleProvider.isLoggedIn) {
      displayName = appleProvider.user?.displayName ?? 'Apple User';
      userId = appleTokenProvider.getUserID ?? 'No UID';
      email =
          getUserEmail(FirebaseAuth.instance.currentUser) ?? 'No email found';
      isAppleLoggedIn = true;
    } else if (googleProvider.isLoggedIn) {
      displayName = googleProvider.user?.displayName ?? 'Google User';
      userId = googleTokenProvider.getUserID ?? 'No UID';
      email =
          getUserEmail(FirebaseAuth.instance.currentUser) ?? 'No email found';
      isGoogleLoggedIn = true;
    } else if (emailProvider.isLoggedIn) {
      userId = emailTokenProvider.getUserID ?? "No UID";
      displayName =
          Provider.of<EmailUsernameApi>(context, listen: false).getUsername ??
              "Email User";
      email = userInfoProvider.isShowEmail
          ? (emailProvider.user?.email ?? "No email found")
          : "Email Permission is Disabled.";
      isEmailLoggedIn = true;
    }

    onUpdateState(
      displayName,
      userId,
      email,
      isEmailLoggedIn,
      isAppleLoggedIn,
      isGoogleLoggedIn,
      isLineLoggedIn,
    );
  }

  /// Hiden User Email
  String getMaskedEmail(bool isEmailHidden, String email) {
    if (isEmailHidden) {
      var atIndex = email.indexOf('@');
      return atIndex > 0
          ? '*' * atIndex + email.substring(atIndex)
          : "********";
    }
    return email;
  }

  /// Display UID for first 15 characters
  String getDisplayUID(String uid) {
    return uid.length > 15 ? '${uid.substring(0, 15)}...' : uid;
  }

  /// Copy UID to Clipboard
  void copyUID(BuildContext context, String userId) {
    Clipboard.setData(ClipboardData(text: userId));
    _showSnackbar(context, 'account.uid_copy_success', kDarkGray);
  }

  /// Check Email Permission (True/False)
  Future<bool> checkEmailPermission(BuildContext context) async {
    final emailForgetPassword =
        Provider.of<EmailForgetPassword>(context, listen: false);
    return await emailForgetPassword.checkShowEmail(context);
  }
}
