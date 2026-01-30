import 'package:botnoivoice/service/login/user_login_base.dart';
import 'package:botnoivoice/service/notification/push_notification_service.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

/// Define the state for GoogleLogin.
class GoogleLoginState extends UserLoginBaseState {
  GoogleLoginState({super.user, super.isLoggedIn, super.errorMessage});

  GoogleLoginState copyWith({User? user, bool? isLoggedIn, String? errorMessage}) {
    return GoogleLoginState(
      user: user ?? this.user,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Google login and interface for authentication using Riverpod StateNotifier.
class GoogleLoginNotifier extends UserLoginBaseNotifier<GoogleLoginState> {
  final Logger _logger = Logger();
  static const String providerId = 'google.com';

  GoogleLoginNotifier() : super(GoogleLoginState(), providerId);

  // Override the public updateState method from the base class
  @override
  void updateState({User? user, bool? isLoggedIn, String? errorMessage}) {
    state = state.copyWith(
        user: user, isLoggedIn: isLoggedIn, errorMessage: errorMessage);
  }

  User? get user => state.user;

  /// Sign in with Google and update the user
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Explicitly update state if needed, though listener handles it too
      if (userCredential.user != null) {
          updateState(user: userCredential.user, isLoggedIn: true, errorMessage: null);
      }
      
      _logger.i("User signed in with Google successfully.");
    } catch (e) {
      _logger.e('Error signing in with Google: $e');
      updateState(errorMessage: e.toString());
    }
  }

  /// Sign out and Check if the user is signed out
  Future<void> signOutWithGoogle(WidgetRef ref) async {
    try {
      ref.read(googleTokenNotifierProvider.notifier).clearTokens();
      await PushNotificationService.unsubscribeFromTopic("default");
      await PushNotificationService.deleteFcmToken();
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      
      updateState(user: null, isLoggedIn: false, errorMessage: null);
      _logger.i("User signed out successfully.");
    } catch (e) {
      _logger.e("Error signing out: $e");
    }
  }
}

final googleLoginNotifierProvider =
    StateNotifierProvider<GoogleLoginNotifier, GoogleLoginState>((ref) {
  return GoogleLoginNotifier();
});