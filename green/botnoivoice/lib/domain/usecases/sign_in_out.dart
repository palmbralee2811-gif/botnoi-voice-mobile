import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Provider and interface for authentication
class SignInOut extends ChangeNotifier {
  User? user;
  String? idToken;

  bool get isAuthenticated {
    return user != null && idToken != null;
  }

  SignInOut() {
    FirebaseAuth.instance.authStateChanges().listen((
      User? user,
    ) async {
      this.user = user;
      idToken = await user?.getIdToken();
      notifyListeners();
    });
  }

  /// Sign in with Google
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // Return null if sign-in fails.

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user; // Return the user after sign-in.
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      return null; // Return null if there is an error.
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
