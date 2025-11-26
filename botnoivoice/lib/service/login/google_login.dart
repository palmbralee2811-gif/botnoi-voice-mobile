// import 'package:botnoivoice/service/notification/push_notification_service.dart';
// import 'package:botnoivoice/service/token/google_token.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:logger/logger.dart';
// import 'package:provider/provider.dart';

// /// Google login and interface for authentication
// class GoogleLogin extends ChangeNotifier {
//   User? user;
//   final Logger _logger = Logger(); // For debugging
//   bool _isLoggedIn = false; // Check if the user is logged in

//   /// Getter for logged in status
//   bool get isLoggedIn => _isLoggedIn;

//   /// Getter สำหรับการตรวจสอบการยืนยันตัวตน
//   bool get isAuthenticated {
//     return FirebaseAuth.instance.currentUser?.uid != null &&
//         user?.providerData.isNotEmpty == true &&
//         user?.providerData[0].providerId == 'google.com';
//   }

//   GoogleLogin() {
//     FirebaseAuth.instance.authStateChanges().listen((User? user) async {
//       if (user?.providerData[0].providerId == 'google.com') {
//         this.user = user;
//         _logger.d("Google Firebase User UID: ${user?.uid}");
//         _logger.d("Login with Google: $user");
//         _isLoggedIn = true;
//       }
//       notifyListeners(); // Update UI
//     });
//   }

//   /// Sign in with Google and update the user
//   Future<void> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) {
//         _logger.w("User canceled Google sign-in.");
//         return;
//       }

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//       await FirebaseAuth.instance.signInWithCredential(credential);

//       if (FirebaseAuth.instance.currentUser?.providerData[0].providerId ==
//           'google.com') {
//         _isLoggedIn = true; // ตรวจสอบว่าเป็น Google user
//       }

//       _logger.i("User signed in with Google successfully.");
//       notifyListeners(); // Update UI
//     } catch (e) {
//       _logger.e('Error signing in with Google: $e');
//     }
//   }

//   /// Sign out and Check if the user is signed out
//   Future<void> signOutWithGoogle(BuildContext context) async {
//     try {
//       context.read<GoogleToken>().clearTokens();

//       // ❌ Unsubscribe from Topic when user sign out
//       await PushNotificationService.unsubscribeFromTopic("default");
//       // ❌ Delete FCM Token Form Firebase Messaging and Database
//       await PushNotificationService.deleteFcmToken();

//       await GoogleSignIn().signOut();
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






// lib/service/login/google_login.dart
import 'package:botnoivoice/service/notification/push_notification_service.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart'; // สมมติว่ามี
import 'package:botnoivoice/service/login/user_login_base.dart'; // **NEW IMPORT**
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

  // Implement abstract method from base class
  @override
  void _updateState({User? user, bool? isLoggedIn, String? errorMessage}) {
    state = state.copyWith(user: user, isLoggedIn: isLoggedIn, errorMessage: errorMessage);
  }

  User? get user => state.user;

  /// Sign in with Google and update the user
  Future<void> signInWithGoogle() async {
    // ... (logic เหมือนเดิม)
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user?.providerData[0].providerId == providerId) {
        _updateState(user: userCredential.user, isLoggedIn: true, errorMessage: null);
      }
      _logger.i("User signed in with Google successfully.");
    } catch (e) {
      _logger.e('Error signing in with Google: $e');
      _updateState(errorMessage: e.toString());
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
      _updateState(user: null, isLoggedIn: false, errorMessage: null);
      _logger.i("User signed out successfully.");
    } catch (e) {
      _logger.e("Error signing out: $e");
    }
  }
}

final googleLoginNotifierProvider = StateNotifierProvider<GoogleLoginNotifier, GoogleLoginState>((ref) {
  return GoogleLoginNotifier();
});