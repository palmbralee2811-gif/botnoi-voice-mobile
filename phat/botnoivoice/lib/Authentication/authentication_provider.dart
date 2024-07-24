import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class Authentication extends ChangeNotifier {
  User? user;
  String? credits;
  String? response;
  String? jwtToken;
  String? credentialsToken;

  final _storage = const FlutterSecureStorage();
  
  bool get isAuthenticated {
    print("isAuthenticated -> user: $user");
    return user != null && jwtToken != null && credentialsToken!=null;
  }

  Authentication() {
    FirebaseAuth.instance.authStateChanges().listen((
      User? user,
    ) {
      print("Printing user details");
      this.user = user;
      notifyListeners();
    });
    _loadJwtToken();
    _loadCredentialsToken();
  }

  Future<void> _loadJwtToken() async {
    jwtToken = await _storage.read(key: 'jwtToken');
    print('Loaded JWT Token: $jwtToken');
    notifyListeners();
  }

  Future<void> _saveJwtToken(String token) async {
    await _storage.write(key: 'jwtToken', value: token);
    print('Saved JWT Token: $token');
  }
  
  Future<void> _loadCredentialsToken() async {
    credentialsToken = await _storage.read(key: 'credentialsToken');
    print('Loaded Credential Token: $credentialsToken');
    notifyListeners();
  }

  Future<void> _saveCredentialsToken(String token) async {
    await _storage.write(key: 'credentialsToken', value: credentialsToken);
    print('Saved Credential Token: $token');
  }



  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
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
          await getIdTokenWithFirebase(idToken);
          print("### START -> signInWithGoogle  ### \n");
          print("getIdTokenWithFirebase: $idToken");

          if (jwtToken != null) {
            print("jwtToken: $jwtToken");
            await _saveJwtToken(jwtToken!);
            credentialsToken = await getCredentialsToken(jwtToken);
            await _saveCredentialsToken(credentialsToken!);
            print("getCredentialsToken: $credentialsToken");
            await getProfileWithToken(jwtToken);
            print("getProfileWithToken: $getProfileWithToken");
            print("### END -> signInWithGoogle ### \n");
            notifyListeners(); // แจ้งให้ UI ทราบว่าข้อมูลมีการเปลี่ยนแปลง
          }
        }
      }

      return user;
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      return null;
    }
  }

  String? getUserEmail(User? user) {
    if (user == null) {
      return null;
    }

    // Iterate through providerData to find the email
    for (var userInfo in user.providerData) {
      if (userInfo.email != null) {
        return userInfo.email;
      }
    }

    return null;
  }

  Future<String?> getIdTokenWithFirebase(String? idToken) async {
    print("\n ###### START getIdTokenWithFirebase");
    if (idToken == null) {
      print("getIdTokenWithFirebase -> idToken: $idToken");
    } else {
      print('getIdTokenWithFirebase -> idToken is empty ');
    }
    print(" ###### END getIdTokenWithFirebase \n");
    String url = 'https://api-voice.botnoi.ai/api/dashboard/firebase_auth';

    Map<String, String> headers = {
      'Botnoi-Token': 'Bearer $idToken',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var message = data['message'];

        // *** START jwtToken ***
        var tokenIndex = message.indexOf('token=');

        if (tokenIndex != -1) {
          var tokenStartIndex = tokenIndex + 'token='.length;
          jwtToken = message.substring(tokenStartIndex);

          print('jwtToken from getIdTokenWithFirebase: $jwtToken');

          return jwtToken;

          // *** END jwtToken ***
        } else {
          print('Token not found -> getIdTokenWithFirebase: $message');
        }
      } else {
        print(
            'Failed to load data -> getIdTokenWithFirebase: Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error -> getIdTokenWithFirebase: $e');
    }
    return null;
  }

  Future<String?> getProfileWithToken(String? jwtToken) async {
    if (jwtToken == null) {
      print('getProfileWithToken -> jwtToken is null');
      return null;
    }

    String url = 'https://api-voice.botnoi.ai/api/dashboard/get_profile';
    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print('Response data from getProfileWithToken: $data');

        // เก็บค่า credits ในตัวแปรของ class
        credits = data['data']['credits'].toString(); // ดึงข้อมูล credits จาก data
        print('getProfileWithToken -> credits: $credits');

        notifyListeners(); // แจ้งให้ UI ทราบว่าข้อมูลมีการเปลี่ยนแปลง
        return credits;
      } else {
        print(
            'Failed to load profile from getProfileWithToken. Status code: ${response.statusCode}');
            return null;
      }
    } catch (e) {
      print('Error in getProfileWithToken: $e');
    }

    print('getProfileWithToken -> Returning null');
    return null;
  }

  Future<String?> getCredentialsToken(String? jwtToken) async {
    if (jwtToken == null) {
      print('getCredentialsToken -> jwtToken is null');
      return null;
    }

    String url = 'https://api-voice.botnoi.ai/api/service/get_token';
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
        print('Response data from getCredentialsToken: $data');

        credentialsToken = data['data'][0]['token'].toString(); // ดึง token จาก data
        print('Credentials Token: $credentialsToken');

        notifyListeners(); // แจ้งให้ UI ทราบว่าข้อมูลมีการเปลี่ยนแปลง
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

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    user = null;
    jwtToken = null;
    credentialsToken = null;
    credits = null;
    await _storage.delete(key: 'jwtToken');
    await _storage.delete(key: 'credentialsToken');
    notifyListeners();
  }
  
}
