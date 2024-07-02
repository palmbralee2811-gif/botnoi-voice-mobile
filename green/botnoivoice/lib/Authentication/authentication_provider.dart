import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class Authentication extends ChangeNotifier {
  User? user;
  String? response;
  String? jwtToken;
  // Defind value to Fetch data in private class
  String? _idTokenWithFirebase;
  String? _credentialsToken;
  String? _dataProfileWithToken;
  String? _allMarketplace;

  bool get isAuthenticated {
    return user != null;
  }

  Authentication() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      this.user = user;
      notifyListeners();
    });
  }

  // Push data in private class to public for other files
  String? get idTokenWithFirebase => _idTokenWithFirebase;
  String? get credentialsToken => _credentialsToken;
  String? get dataProfileWithToken => _dataProfileWithToken;
  String? get allMarketplace => _allMarketplace;

  // Add a public method to update _dataProfileWithToken
  void setDataProfileWithToken(String? data) {
    _dataProfileWithToken = data;
    notifyListeners();
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
          _idTokenWithFirebase = await getIdTokenWithFirebase(idToken);
          // waiting to get data from function

          print('_idTokenWithFirebase: $_idTokenWithFirebase');

          _dataProfileWithToken = await getProfileWithToken(jwtToken);
          _credentialsToken = await getCredentialsToken(jwtToken);
          _allMarketplace = await getAllMarketplace(jwtToken);
          notifyListeners();
        }
      }

      return user;
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      return null;
    }
  }

  Future<String?> getIdTokenWithFirebase(String idToken) async {
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
          jwtToken = message.substring(tokenStartIndex);
          print('jwtToken from getIdTokenWithFirebase: $jwtToken');
          return jwtToken;
        } else {
          print('Token not found in getIdTokenWithFirebase: $message');
        }
        //print('Response data from _callApiWithToken: $data');
      } else {
        print(
            'Failed to load data from getIdTokenWithFirebase. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getIdTokenWithFirebase: $e');
    }
    return null;
  }

  Future<String?> getProfileWithToken(String? jwtToken) async {
    if (jwtToken == null) {
      print('jwtToken is null');
      return null;
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
        // print('Response data from _getProfileWithToken: $data');

        var credits = data['data']['credits']; // ดึงข้อมูล credits จาก data
        print('credits: $credits');

        return credits.toString();
      } else {
        print(
            'Failed to load profile from _getProfileWithToken. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in _getProfileWithToken: $e');
    }
    return null;
  }

  Future<String?> getCredentialsToken(String? jwtToken) async {
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
        var credentialsToken = data['data'][0]['token']; // ดึง token จาก data
        //print('data -> _getCredentialsToken: $data');
        print('Credentials Token: $credentialsToken');
        return credentialsToken; // Return the token here
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

  // get all sound
  Future<String?> getAllMarketplace(String? jwtToken) async {
    if (jwtToken == null) {
      print('jwtToken is null');
      return null;
    }

    String url =
        'https://api-voice-staging.botnoi.ai/api/service/get_all_marketplace';

    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // แปลงข้อมูลที่ได้ให้เป็น UTF-8 ก่อนที่จะ decode
        var utf8Data = utf8.decode(response.bodyBytes);
        var data = json.decode(utf8Data);
        print('getAllMarketplace: $data');
        return utf8Data;
      } else {
        print(
            'Failed to load Credentials-Token. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching Credentials-Token: $e');
    }
    return null;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
