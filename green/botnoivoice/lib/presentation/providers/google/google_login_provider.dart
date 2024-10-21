import 'package:botnoivoice/presentation/providers/google/google_token_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

/// Google Provider and interface for authentication
class GoogleLoginProvider extends ChangeNotifier {
  User? user;
  final Logger _logger = Logger(); // For debugging
  bool _isLoggedIn = false; // Check if the user is logged in

  /// Getter for logged in status
  bool get isLoggedIn => _isLoggedIn;

  /// Getter สำหรับการตรวจสอบการยืนยันตัวตน
  bool get isAuthenticated {
    return FirebaseAuth.instance.currentUser?.uid != null &&
        user?.providerData.isNotEmpty == true &&
        user?.providerData[0].providerId == 'google.com';
  }

  GoogleLoginProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user?.providerData[0].providerId == 'google.com') {
        this.user = user;
        _logger.d("Login with Google: $user");
        _isLoggedIn = true;
      }
      notifyListeners(); // Update UI
    });
  }

  /// Sign in with Google and update the user
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        _logger.w("User canceled Google sign-in.");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      _logger.d(
          "AccessToken: ${googleAuth.accessToken}, IDToken: ${googleAuth.idToken}");

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (FirebaseAuth.instance.currentUser?.providerData[0].providerId ==
          'google.com') {
        _isLoggedIn = true; // ตรวจสอบว่าเป็น Google user
      }

      _logger.i(
          "User signed in with Google successfully, Google User ID: ${user?.uid}");
      notifyListeners(); // Update UI
    } catch (e) {
      _logger.e('Error signing in with Google: $e');
    }
  }

  /// Sign out and Check if the user is signed out
  Future<void> signOutWithGoogle(BuildContext context) async {
    try {
      Provider.of<GoogleTokenProvider>(context, listen: false).clearTokens();
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      _isLoggedIn = false; // User's sign out
      _logger.i("User signed out successfully.");
    } catch (e) {
      _logger.e("Error signing out: $e");
    }
    notifyListeners(); // Update UI
  }
}
