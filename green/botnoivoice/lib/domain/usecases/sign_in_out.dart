import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:botnoivoice/data/managers/token_manager.dart';

class SignInOut extends ChangeNotifier {
  User? user;

  bool get isAuthenticated {
    debugPrint('isAuthenticated: ${user != null}');
    return user != null;
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        debugPrint('Google sign-in was canceled');
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      debugPrint(
          'Google Auth: idToken=${googleAuth.idToken}, accessToken=${googleAuth.accessToken}');

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        debugPrint('User signed in: ${user.email}');
        // บังคับดึง idToken ใหม่
        final String? freshIdToken = await user.getIdToken();
        debugPrint('Fresh idToken: $freshIdToken');

        if (freshIdToken != null) {
          final tokenManager =
              Provider.of<TokenManager>(context, listen: false);
          await tokenManager.getIdTokenWithFirebase(freshIdToken);
          return user;
        } else {
          debugPrint('Failed to retrieve fresh idToken');
        }
      } else {
        debugPrint('Failed to sign in: User is null');
      }

      return user;
    } catch (e) {
      debugPrint('Error in signInWithGoogle: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      debugPrint('User signed out');
    } catch (e) {
      debugPrint('Error signing out: $e');
    }

    user = null;
    notifyListeners();
  }
}
