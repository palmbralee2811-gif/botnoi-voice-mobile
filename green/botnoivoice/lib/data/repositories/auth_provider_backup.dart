// import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;

// class AuthenticationRepositoryImpl extends ChangeNotifier {
//   User? user;
//   String? credits;
//   String? response;
//   String? jwtToken;
//   String? credentialsToken;

//   final _storage = const FlutterSecureStorage();

//   bool get isAuthenticated {
//     return user != null && jwtToken != null && credentialsToken != null;
//   }

//   AuthenticationRepositoryImpl() {
//     FirebaseAuth.instance.authStateChanges().listen((
//       User? user,
//     ) {
//       this.user = user;
//       notifyListeners();
//     });
//     _loadJwtToken();
//     _loadCredentialsToken();
//   }

//   Future<void> loadAuthStatus() async {
//     await Future.wait([
//       _loadJwtToken(),
//       _loadCredentialsToken(),
//     ]);
//   }

//   Future<void> _loadJwtToken() async {
//     jwtToken = await _storage.read(key: 'jwtToken');
//     notifyListeners();
//   }

//   Future<void> _saveJwtToken(String token) async {
//     await _storage.write(key: 'jwtToken', value: token);
//   }

//   Future<void> _loadCredentialsToken() async {
//     credentialsToken = await _storage.read(key: 'credentialsToken');
//     notifyListeners();
//   }

//   Future<void> _saveCredentialsToken(String token) async {
//     await _storage.write(key: 'credentialsToken', value: credentialsToken);
//   }

//   Future<User?> signInWithGoogle(BuildContext context) async {
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) return null;
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithCredential(credential);
//       final user = userCredential.user;

//       if (user != null) {
//         final idToken = await user.getIdToken();
//         if (idToken != null) {
//           await getIdTokenWithFirebase(idToken);
//           if (jwtToken != null) {
//             await _saveJwtToken(jwtToken!);
//             credentialsToken = await getCredentialsToken(jwtToken);
//             if (credentialsToken != null) {
//               await _saveCredentialsToken(credentialsToken!);
//               await getProfileWithToken(jwtToken);
//               notifyListeners();
//             }
//           }
//         }
//       }
//       return user;
//     } catch (e) {
//       debugPrint('Error: $e');
//       return null;
//     }
//   }

//   String? getUserEmail(User? user) {
//     if (user == null) {
//       return null;
//     }

//     for (var userInfo in user.providerData) {
//       if (userInfo.email != null) {
//         return userInfo.email;
//       }
//     }
//     return null;
//   }

//   Future<String?> getIdTokenWithFirebase(String? idToken) async {
//     if (idToken == null) return null;
//     String url = 'https://api-voice.botnoi.ai/api/dashboard/firebase_auth';
//     Map<String, String> headers = {
//       'Botnoi-Token': 'Bearer $idToken',
//       'Content-Type': 'application/json'
//     };
//     try {
//       final response = await http.get(Uri.parse(url), headers: headers);
//       if (response.statusCode == 200) {
//         var data = json.decode(response.body);
//         var message = data['message'];
//         var tokenIndex = message.indexOf('token=');
//         if (tokenIndex != -1) {
//           var tokenStartIndex = tokenIndex + 'token='.length;
//           jwtToken = message.substring(tokenStartIndex);
//           notifyListeners();
//           return jwtToken;
//         }
//       }
//     } catch (e) {
//       debugPrint('Error: $e');
//     }
//     return null;
//   }

//   Future<String?> getProfileWithToken(String? jwtToken) async {
//     String url = 'https://api-voice.botnoi.ai/api/dashboard/get_profile';
//     Map<String, String> headers = {
//       'Authorization': 'Bearer $jwtToken',
//       'Content-Type': 'application/json'
//     };
//     try {
//       final response = await http.get(Uri.parse(url), headers: headers);
//       if (response.statusCode == 200) {
//         var data = json.decode(response.body);
//         credits = data['data']['credits'].toString();
//         notifyListeners();
//         return credits;
//       }
//     } catch (e) {
//       debugPrint('Error: $e');
//     }
//     return null;
//   }

//   Future<String?> getCredentialsToken(String? jwtToken) async {
//     String url = 'https://api-voice.botnoi.ai/api/service/get_token';
//     Map<String, dynamic> payload = {};
//     Map<String, String> headers = {
//       'Authorization': 'Bearer $jwtToken',
//       'Content-Type': 'application/json'
//     };
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: jsonEncode(payload),
//       );
//       if (response.statusCode == 200) {
//         var data = json.decode(response.body);
//         credentialsToken = data['data'][0]['token'].toString();
//         notifyListeners();
//         return credentialsToken;
//       }
//     } catch (e) {
//       debugPrint('Error: $e');
//     }
//     return null;
//   }

//   Future<void> signOut() async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       await GoogleSignIn().signOut();
//     } catch (e) {
//       debugPrint('Error signing out: $e');
//     }

//     user = null;
//     jwtToken = null;
//     credentialsToken = null;
//     credits = null;

//     await _storage.delete(key: 'jwtToken');
//     await _storage.delete(key: 'credentialsToken');

//     notifyListeners();
//   }
// }
