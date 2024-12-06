import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Apple Provider and interface for authentication
class AppleLoginProvider extends ChangeNotifier {
  User? user;
  final Logger _logger = Logger(); // For debugging
  bool _isLoggedIn = false; // Check if the user is logged in

  /// Getter for logged in status
  bool get isLoggedIn => _isLoggedIn;

  /// Getter สำหรับการตรวจสอบการยืนยันตัวตน
  bool get isAuthenticated {
    return FirebaseAuth.instance.currentUser?.uid != null &&
        user?.providerData.isNotEmpty == true &&
        user?.providerData[0].providerId == 'apple.com';
  }

  AppleLoginProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user?.providerData[0].providerId == 'apple.com') {
        this.user = user;
        _logger.d("Login with Apple: $user");
        _isLoggedIn = true;
      }
      notifyListeners(); // Update UI
    });
  }

  /// Sign in with Apple and update the user
  Future<void> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (FirebaseAuth.instance.currentUser?.providerData[0].providerId ==
          'apple.com') {
        _isLoggedIn = true; // ตรวจสอบว่าเป็น Apple user
      }

      _logger.i("User signed in with Apple successfully.");
      notifyListeners(); // Update UI
    } catch (e) {
      _logger.e('Error signing in with Apple: $e');
    }
  }

  /// Sign out and Check if the user is signed out
  Future<void> signOutWithApple(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      _isLoggedIn = false; // User's sign out
      _logger.i("User signed out successfully.");
    } catch (e) {
      _logger.e("Error signing out: $e");
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}