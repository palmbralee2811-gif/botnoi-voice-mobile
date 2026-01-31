import 'package:botnoivoice/service/email/email_username_api.dart';
import 'package:botnoivoice/service/login/user_login_base.dart';
import 'package:botnoivoice/service/notification/push_notification_service.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// Define the state for EmailLogin.
class EmailLoginState extends UserLoginBaseState {
  EmailLoginState({super.user, super.isLoggedIn, super.errorMessage});

  EmailLoginState copyWith({User? user, bool? isLoggedIn, String? errorMessage}) {
    return EmailLoginState(
      user: user ?? this.user,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      errorMessage: errorMessage, // Note: Error message is not persisted from previous state usually
    );
  }
}

/// Login with Email/Username and Password using Riverpod StateNotifier.
class EmailLoginNotifier extends UserLoginBaseNotifier<EmailLoginState> {
  final Ref _ref;
  final Logger _logger = Logger();
  static const String providerId = 'password';

  EmailLoginNotifier(this._ref) : super(EmailLoginState(), providerId);

  // Override the public updateState method from the base class
  @override
  void updateState({User? user, bool? isLoggedIn, String? errorMessage}) {
    state = state.copyWith(
        user: user, isLoggedIn: isLoggedIn, errorMessage: errorMessage);
  }

  User? get user => state.user;

  /// Clear the current error message.
  void clearErrorMessage() {
    updateState(errorMessage: null);
  }

  /// Login with username and password
  Future<void> loginWithUsernamePassword(
    String username,
    String password,
  ) async {
    final emailUsernameApiNotifier =
        _ref.read(emailUsernameApiNotifierProvider.notifier);

    try {
      await emailUsernameApiNotifier.getEmailByUsername(username);
      final email = _ref.read(emailUsernameApiNotifierProvider).result;

      if (email == 'email not found') {
        final errorMessage = 'login_provider.invalid_username'.tr();
        updateState(errorMessage: errorMessage, isLoggedIn: false, user: null);
        return;
      }

      await loginWithEmailPassword(email, password);
    } catch (e) {
      final errorMessage = "${'login_provider.error_logging_in'.tr()} $e";
      updateState(errorMessage: errorMessage, isLoggedIn: false, user: null);
    }
  }

  /// Login with email and password
  Future<void> loginWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      updateState(errorMessage: null);

      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        var error = 'login_provider.please_verify_email_before_login'.tr();
        try {
          await userCredential.user?.sendEmailVerification();
          error = '${'login_provider.please_verify_email'.tr()} $email';
        } on FirebaseAuthException catch (e) {
          error = e.message.toString();
        }

        await FirebaseAuth.instance.signOut();
        updateState(errorMessage: error, isLoggedIn: false, user: null);
        return;
      }

      updateState(user: userCredential.user, isLoggedIn: true, errorMessage: null);
    } on FirebaseAuthException catch (e) {
      String? error;
      switch (e.code) {
        case 'invalid-email':
          error = 'login_provider.invalid_email'.tr();
          break;
        case 'wrong-password':
          error = 'login_provider.incorrect_password'.tr();
          break;
        case 'user-disabled':
          error = 'login_provider.account_suspended'.tr();
          break;
        default:
          error = 'login_provider.username_or_password_incorrect'.tr();
          break;
      }
      updateState(errorMessage: error, isLoggedIn: false, user: null);
    }
  }

  /// Sign out for Login with Email and Password
  Future<void> signOutWithEmail(WidgetRef ref) async {
    try {
      ref.read(emailTokenNotifierProvider.notifier).clearTokens();
      await PushNotificationService.unsubscribeFromTopic("default");
      await PushNotificationService.deleteFcmToken();
      await FirebaseAuth.instance.signOut();
      
      updateState(user: null, isLoggedIn: false, errorMessage: null);
      _logger.i("User signed out successfully");
    } catch (e) {
      _logger.e("Error signing out: $e");
    }
  }
}

final emailLoginNotifierProvider =
    StateNotifierProvider<EmailLoginNotifier, EmailLoginState>((ref) {
  return EmailLoginNotifier(ref);
});