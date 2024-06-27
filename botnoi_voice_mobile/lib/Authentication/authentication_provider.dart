import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class Authentication extends ChangeNotifier {
  User? user;
  String response = '';

  bool get isAuthenticated {
    return user != null;
  }

  Authentication() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      this.user = user;
      notifyListeners();
    });
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // await FirebaseAuth.instance.signInWithCredential(credential);

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final idToken = await user.getIdToken();
        await _callApiWithToken(idToken!);
        await _getProfileWithToken(idToken);

        print("Debugging at signInWithGoogle(); -> `ID-TOKEN: $idToken`");
      }

      return user;
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      return null;
    }
  }

  Future<void> _callApiWithToken(String idToken) async {
    String url =
        'https://api-voice-staging.botnoi.ai/api/dashboard/firebase_auth';
    Map<String, dynamic> payload = {};
    Map<String, String> headers = {
      'Botnoi-Token': 'Bearer $idToken',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        // header Botnoi-Token: Bearer + token firebase
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('jsonData: ${jsonData.hashCode}');
        print('Success: ${response.body}');
      } else {
        print(
            'Debugging at _callApiWithToken(); -> `Failed: ${response.statusCode}` ');
      }
    } catch (e) {
      print("Debugging at _callApiWithToken(); -> `Error at catch $e` ");
    }
  }

  Future<void> _getProfileWithToken(String idToken) async {
    const url = 'https://api-voice-staging.botnoi.ai/api/dashboard/get_profile';
    final response = await http.get(
      Uri.parse(url),
      // header Authorization: jwtToken ที่ได้หลังจากยิงเส้น firebase_auth ครับ
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      print('Profile data: ${response.body}');
    } else if (response.statusCode == 401) {
      // Handle unauthorized error (e.g., token expired)
      print('Unauthorized: ${response.body}');
      // You might want to refresh the token or re-authenticate the user here
    } else {
      print('Failed to load profile: ${response.statusCode}');
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
