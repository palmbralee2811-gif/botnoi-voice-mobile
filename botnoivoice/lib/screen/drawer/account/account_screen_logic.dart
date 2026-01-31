import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/email/email_forget_password.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/email/email_username_api.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:botnoivoice/shared/dialog/notification/notification_snack_bar.dart';
import 'package:botnoivoice/screen/drawer/account/get_user_email.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/service/email/check_user_is_show_email.dart';
import 'package:botnoivoice/shared/style/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

/// Define the provider for the AccountScreenLogic class.
final accountScreenLogicProvider = Provider((ref) => AccountScreenLogic());

/// Business logic and helper methods for the AccountScreen.
class AccountScreenLogic {
  final Logger _logger = Logger(); // For debugging

  AccountScreenLogic();

  /// Signs out the user from the currently active authentication provider.
  Future<void> _signOutProvider(
    BuildContext context,
    WidgetRef widgetRef,
  ) async {
    // Read notifiers directly using the internal Riverpod Ref (_ref)
    final appleProvider = widgetRef.read(appleLoginNotifierProvider);
    final googleProvider = widgetRef.read(googleLoginNotifierProvider);
    final lineProvider = widgetRef.read(lineLoginNotifierProvider);
    final emailProvider = widgetRef.read(emailLoginNotifierProvider);

    final appleNotifier = widgetRef.read(appleLoginNotifierProvider.notifier);
    final googleNotifier = widgetRef.read(googleLoginNotifierProvider.notifier);
    final lineNotifier = widgetRef.read(lineLoginNotifierProvider.notifier);
    final emailNotifier = widgetRef.read(emailLoginNotifierProvider.notifier);

    if (appleProvider.isLoggedIn) {
      _logger.d("Signing out from Apple...");
      await appleNotifier.signOutWithApple(widgetRef);
    }
    if (googleProvider.isLoggedIn) {
      _logger.d("Signing out from Google...");
      await googleNotifier.signOutWithGoogle(widgetRef);
    }
    if (lineProvider.isLoggedIn) {
      _logger.d("Signing out from LINE...");
      await lineNotifier.signOutWithLine(widgetRef);
    }
    if (emailProvider.isLoggedIn) {
      _logger.d("Signing out from Email...");
      await emailNotifier.signOutWithEmail(widgetRef);
    }
  }

  /// Calling Sign Out Method, Dialog and Snackbar
  Future<void> signOut(
    BuildContext context,
    WidgetRef ref,
  ) async {
    _logger.i("Sign out process started...");

    // Show Loading Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await _signOutProvider(
        context,
        ref,
      );
      _logger.i("User signed out successfully.");

      // Close Loading Dialog
      if (context.mounted) {
        context.pop();
      }

      if (context.mounted) {
        NotificationSnackBar(
          context: context,
          text: 'Sign out successfully',
          color: kDarkGray,
        ).showSnackBar();
      }

      // Redirect to `login_screen.dart`
      if (context.mounted) {
        context.go('/login');
      }
    } catch (e) {
      _logger.e("Error during sign out: $e");

      // Close Loading Dialog
      if (context.mounted) {
        context.pop();
      }

      if (context.mounted) {
        NotificationSnackBar(
          context: context,
          text: 'Sign out failed',
          color: Colors.red,
        ).showSnackBar();
      }
    }
  }

  /// Loading User Information
  Future<void> loadUserInfo(
    WidgetRef widgetRef, {
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
    // Read the current state from the Riverpod providers
    final appleState = widgetRef.read(appleLoginNotifierProvider);
    final googleState = widgetRef.read(googleLoginNotifierProvider);
    final lineState = widgetRef.read(lineLoginNotifierProvider);
    final emailState = widgetRef.read(emailLoginNotifierProvider);

    final userTokenState = widgetRef.read(currentUserTokenStateProvider);

    // Assuming EmailUsernameApi and CheckUserIsShowEmail are also Riverpod Providers
    final emailUsernameApi = widgetRef.read(emailUsernameApiNotifierProvider);
    final userInfoProvider =
        widgetRef.read(checkUserIsShowEmailNotifierProvider);

    String displayName = "Loading...";
    String userId = "Loading...";
    String email = "Loading...";
    bool isEmailLoggedIn = false;
    bool isAppleLoggedIn = false;
    bool isGoogleLoggedIn = false;
    bool isLineLoggedIn = false;

    // Check if Firebase user exists for providers
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (lineState.isLoggedIn) {
      displayName = lineState.displayName ?? "Line User";
      userId = userTokenState.userID ?? "No UID";
      email = lineState.lineEmail ?? "No email found";
      isLineLoggedIn = true;
    } else if (appleState.isLoggedIn) {
      displayName = userTokenState.userName ?? 'Apple User';
      userId = userTokenState.userID ?? 'No UID';
      email = getUserEmail(firebaseUser) ?? 'No email found';
      isAppleLoggedIn = true;
    } else if (googleState.isLoggedIn) {
      displayName = googleState.user?.displayName ?? 'Google User';
      userId = userTokenState.userID ?? 'No UID';
      email = getUserEmail(firebaseUser) ?? 'No email found';
      isGoogleLoggedIn = true;
    } else if (emailState.isLoggedIn) {
      userId = userTokenState.userID ?? "No UID";
      displayName = emailUsernameApi.getUsername ?? "Email User";
      email = userInfoProvider.isShowEmail
          ? (emailState.user?.email ?? "No email found")
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
    // Check if the context is still mounted before showing SnackBar
    if (context.mounted) {
      NotificationSnackBar(
        context: context,
        text: 'account.uid_copy_success',
        color: kDarkGray,
      ).showSnackBar();
    }
  }

  /// Check Email Permission (True/False)
  Future<bool> checkEmailPermission(
    BuildContext context,
    WidgetRef widgetRef,
  ) async {
    final emailForgetPassword = widgetRef.read(
      emailForgetPasswordNotifierProvider.notifier,
    );
    return await emailForgetPassword.checkShowEmail(context);
  }
}