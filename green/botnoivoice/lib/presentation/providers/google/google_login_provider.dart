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

  // Check if the user is logged in
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn; 

  bool get isAuthenticated {
    return user != null;
  }

  GoogleLoginProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      this.user = user;
      _isLoggedIn = user != null; // Set's true if a user is logged in, or false if not.
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

      await FirebaseAuth.instance.signInWithCredential(credential);
      _isLoggedIn = true; // User's sign in
      _logger.i("User signed in with Google successfully.");
      notifyListeners(); // Update UI
    } catch (e) {
      _logger.e('Error signing in with Google: $e');
    }
  }

  /// Sign out and Check if the user is signed out
  Future<void> signOut(BuildContext context) async {    
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
