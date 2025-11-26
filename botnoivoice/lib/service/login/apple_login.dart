// import 'package:botnoivoice/service/notification/push_notification_service.dart';
// import 'package:botnoivoice/service/token/apple_token.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:logger/logger.dart';
// import 'package:provider/provider.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// /// Apple Login and interface for authentication
// class AppleLogin extends ChangeNotifier {
//   User? user;
//   final Logger _logger = Logger(); // For debugging
//   bool _isLoggedIn = false; // Check if the user is logged in

//   /// Getter for logged in status
//   bool get isLoggedIn => _isLoggedIn;

//   /// Getter สำหรับการตรวจสอบการยืนยันตัวตน
//   bool get isAuthenticated {
//     return FirebaseAuth.instance.currentUser?.uid != null &&
//         user?.providerData.isNotEmpty == true &&
//         user?.providerData[0].providerId == 'apple.com';
//   }

//   AppleLogin() {
//     FirebaseAuth.instance.authStateChanges().listen((User? user) async {
//       if (user?.providerData[0].providerId == 'apple.com') {
//         this.user = user;
//         _logger.d("Apple Firebase User UID: ${user?.uid}");
//         _logger.d("Login with Apple: $user");
//         _isLoggedIn = true;
//       }
//       notifyListeners(); // Update UI
//     });
//   }

//   /// Sign in with Apple and update the user
//   Future<void> signInWithApple() async {
//     try {
//       final appleCredential = await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//       );

//       final oAuthProvider = OAuthProvider('apple.com');
//       final credential = oAuthProvider.credential(
//         idToken: appleCredential.identityToken,
//         accessToken: appleCredential.authorizationCode,
//       );

//       await FirebaseAuth.instance.signInWithCredential(credential);

//       if (FirebaseAuth.instance.currentUser?.providerData[0].providerId ==
//           'apple.com') {
//         _isLoggedIn = true; // ตรวจสอบว่าเป็น Apple user
//       }

//       _logger.i("User signed in with Apple successfully.");
//       notifyListeners(); // Update UI
//     } catch (e) {
//       _logger.e('Error signing in with Apple: $e');
//     }
//   }

//   /// Sign out and Check if the user is signed out
//   Future<void> signOutWithApple(BuildContext context) async {
//     try {
//       context.read<AppleToken>().clearTokens();

//       // ❌ Unsubscribe from Topic when user sign out
//       await PushNotificationService.unsubscribeFromTopic("default");
//       // ❌ Delete FCM Token Form Firebase Messaging and Database
//       await PushNotificationService.deleteFcmToken();

//       await FirebaseAuth.instance.signOut();
//       _isLoggedIn = false; // User's sign out
//       _logger.i("User signed out successfully.");
//     } catch (e) {
//       _logger.e("Error signing out: $e");
//     }

//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       notifyListeners();
//     });
//   }
// }




// lib/service/login/apple_login.dart
import 'package:botnoivoice/service/notification/push_notification_service.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart'; // สมมติว่านี่คือไฟล์รวม token
import 'package:botnoivoice/service/login/user_login_base.dart'; // **NEW IMPORT**
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
  
  // Implement abstract method from base class
  @override
  void _updateState({User? user, bool? isLoggedIn, String? errorMessage}) {
    state = state.copyWith(user: user, isLoggedIn: isLoggedIn, errorMessage: errorMessage);
  }

  // Getter for current Firebase user.
  User? get user => state.user;

  /// Sign in with Apple and update the user
  Future<void> signInWithApple() async {
    // ... (logic เหมือนเดิม)
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );
      final oAuthProvider = OAuthProvider(providerId);
      final credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user?.providerData[0].providerId == providerId) {
        _updateState(user: userCredential.user, isLoggedIn: true, errorMessage: null);
      }
      _logger.i("User signed in with Apple successfully.");
    } catch (e) {
      _logger.e('Error signing in with Apple: $e');
      _updateState(errorMessage: e.toString());
    }
  }

  /// Sign out and Check if the user is signed out
  Future<void> signOutWithApple(WidgetRef ref) async {
    try {
      ref.read(appleTokenNotifierProvider.notifier).clearTokens();
      await PushNotificationService.unsubscribeFromTopic("default");
      await PushNotificationService.deleteFcmToken();
      await FirebaseAuth.instance.signOut();
      _updateState(user: null, isLoggedIn: false, errorMessage: null);
      _logger.i("User signed out successfully.");
    } catch (e) {
      _logger.e("Error signing out: $e");
    }
  }
}

final appleLoginNotifierProvider = StateNotifierProvider<AppleLoginNotifier, AppleLoginState>((ref) {
  return AppleLoginNotifier();
});