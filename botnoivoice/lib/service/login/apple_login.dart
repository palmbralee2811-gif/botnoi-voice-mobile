import 'package:botnoivoice/service/login/user_login_base.dart';
import 'package:botnoivoice/service/notification/push_notification_service.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Define the state for AppleLogin.
class AppleLoginState extends UserLoginBaseState {
  AppleLoginState({super.user, super.isLoggedIn, super.errorMessage});

  AppleLoginState copyWith({User? user, bool? isLoggedIn, String? errorMessage}) {
    return AppleLoginState(
      user: user ?? this.user,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Apple Login and interface for authentication using Riverpod StateNotifier.
class AppleLoginNotifier extends UserLoginBaseNotifier<AppleLoginState> {
  final Logger _logger = Logger();
  static const String providerId = 'apple.com';

  AppleLoginNotifier() : super(AppleLoginState(), providerId);

  // Override the public updateState method from the base class
  @override
  void updateState({User? user, bool? isLoggedIn, String? errorMessage}) {
    state = state.copyWith(
        user: user, isLoggedIn: isLoggedIn, errorMessage: errorMessage);
  }

  // Getter for current Firebase user.
  User? get user => state.user;

  /// Sign in with Apple and update the user
  Future<void> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName
        ],
      );
      final oAuthProvider = OAuthProvider(providerId);
      final credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // The listener in the base class will handle state updates,
      // but we can enforce it here to be immediate.
      if (userCredential.user != null) {
         updateState(user: userCredential.user, isLoggedIn: true, errorMessage: null);
      }
      _logger.i("User signed in with Apple successfully.");
    } catch (e) {
      _logger.e('Error signing in with Apple: $e');
      updateState(errorMessage: e.toString());
    }
  }

  /// Sign out and Check if the user is signed out
  Future<void> signOutWithApple(WidgetRef ref) async {
    try {
      ref.read(appleTokenNotifierProvider.notifier).clearTokens();
      await PushNotificationService.unsubscribeFromTopic("default");
      await PushNotificationService.deleteFcmToken();
      await FirebaseAuth.instance.signOut();
      
      updateState(user: null, isLoggedIn: false, errorMessage: null);
      _logger.i("User signed out successfully.");
    } catch (e) {
      _logger.e("Error signing out: $e");
    }
  }
}

final appleLoginNotifierProvider =
    StateNotifierProvider<AppleLoginNotifier, AppleLoginState>((ref) {
  return AppleLoginNotifier();
});