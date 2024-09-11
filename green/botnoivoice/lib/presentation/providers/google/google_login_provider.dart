import 'package:botnoivoice/presentation/providers/google/google_token_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

/// Provider and interface for authentication
class GoogleLoginProvider extends ChangeNotifier {
  User? user;

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
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
    }
  }

  /// Sign out
  Future<void> signOut(BuildContext context) async {
    Provider.of<GoogleTokenProvider>(context, listen: false).clearTokens();
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }
}
