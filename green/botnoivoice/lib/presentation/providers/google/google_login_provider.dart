import 'package:botnoivoice/presentation/providers/google/google_token_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

/// Provider and interface for authentication
class GoogleLoginProvider extends ChangeNotifier {
  User? user;
  final Logger logger = Logger();

  bool get isAuthenticated {
    return user != null;
  }

  GoogleLoginProvider() {
    FirebaseAuth.instance.authStateChanges().listen((
      User? user,
    ) async {
      this.user = user;
      notifyListeners();
    });
  }

  /// Sign in with Google and update the user
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        logger.w("User canceled Google sign-in.");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      logger.i("User signed in with Google successfully.");
    } catch (e) {
      logger.e('Error signing in with Google: $e');
    }
  }

  /// Sign out
  Future<void> signOut(BuildContext context) async {    
    try {
      Provider.of<GoogleTokenProvider>(context, listen: false).clearTokens();
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      logger.i("User signed out successfully.");
    } catch (e) {
      logger.e("Error signing out: $e");
    }
  }
}
