import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class Authentication extends ChangeNotifier {
  User? user;
  String? response;
  String? jwtToken;

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

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final idToken = await user.getIdToken();
        if (idToken != null) {
          await _callApiWithToken(idToken);
          await _getProfileWithToken(jwtToken);
          await _getCredentialsToken(jwtToken);
        }
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

    Map<String, String> headers = {
      'Botnoi-Token': 'Bearer $idToken',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        var message = data['message'];
        var tokenIndex = message.indexOf('token=');
        if (tokenIndex != -1) {
          var tokenStartIndex = tokenIndex + 'token='.length;
          var token = message.substring(tokenStartIndex);
          jwtToken = token;
          print('Token from message: $token');
          return token;
        } else {
          print('Token not found in message: $message');
        }
        //print('Response data from _callApiWithToken: $data');
      } else {
        print(
            'Failed to load data from _callApiWithToken. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in _callApiWithToken: $e');
    }
  }

  Future<void> _getProfileWithToken(String? jwtToken) async {
    if (jwtToken == null) {
      print('jwtToken is null');
      return;
    }

    String url =
        'https://api-voice-staging.botnoi.ai/api/dashboard/get_profile';
    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print('Response data from _getProfileWithToken: $data');
        //var credits = data['data']['credits']; // ดึงข้อมูล credits จาก data
        //print('credits: $credits');
        return data;
      } else {
        print(
            'Failed to load profile from _getProfileWithToken. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in _getProfileWithToken: $e');
    }
  }

  Future<String?> _getCredentialsToken(String? jwtToken) async {
    if (jwtToken == null) {
      print('jwtToken is null');
      return null;
    }

    String url = 'https://api-voice-staging.botnoi.ai/api/service/get_token';
    Map<String, dynamic> payload = {};

    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var token = data['data'][0]['token']; // ดึง token จาก data
        //print('data -> _getCredentialsToken: $data');
        print('Credentials-Token: $token');
        return token; // Return the token here
      } else {
        print(
            'Failed to load Credentials-Token. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching Credentials-Token: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
