import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Provider and interface for authentication
class Authentication extends ChangeNotifier {
  User? user;
  String? idToken;

  bool get isAuthenticated {
    return user != null && idToken != null;
  }

  Authentication() {
    FirebaseAuth.instance.authStateChanges().listen((
      User? user,
    ) async {
      this.user = user;
      idToken = await user?.getIdToken();
      notifyListeners();
    });
  }

  /// Sign in with Google
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
    user = null;
    //await Provider.of<DataProvider>(context).deleteJwtToken();
    //await Provider.of<DataProvider>(context).deleteCredentialsToken();
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    notifyListeners();
  }
}
