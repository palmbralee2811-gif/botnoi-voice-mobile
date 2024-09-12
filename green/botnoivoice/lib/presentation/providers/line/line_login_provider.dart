// import 'package:flutter/material.dart';
// import 'package:flutter_line_sdk/flutter_line_sdk.dart';
// import 'package:flutter/services.dart';

// /// Provider and interface for authentication
// class LineLoginProvider with ChangeNotifier {
//   String? userId;
//   String? displayName;
//   String? profilePictureUrl;

//   /// Sign in with Line and update the user
//   Future<void> signIn(BuildContext context) async {
//     try {
//       final result = await LineSDK.instance.login();
//       print(result.toString());
//       userId = result.userProfile?.userId;
//       displayName = result.userProfile?.displayName;
//       profilePictureUrl = result.userProfile?.pictureUrl;
//       notifyListeners(); // แจ้งให้ UI ทราบว่ามีการเปลี่ยนแปลงข้อมูล
//     } on PlatformException catch (e) {
//       print('Error: $e');
//       notifyListeners();
//     }
//   }

//   /// Sign out
//   Future<void> signOut() async {
//     try {
//       await LineSDK.instance.logout();
//       userId = null;
//       displayName = null;
//       profilePictureUrl = null;
//       notifyListeners();
//     } on PlatformException catch (e) {
//       print('Logout failed: $e');
//     }
//   }

//     Future getAccessToken() async {
//     try {
//       final result = await LineSDK.instance.currentAccessToken;
//       return result?.value;
//     } on PlatformException catch (e) {
//       print(e.message);
//     }
//   }

//   Future<void> getVerifyAccessToken() async {
//     try {
//       final result = await LineSDK.instance.verifyAccessToken();
//       print('Token is valid: ${result.data}');
//     } on PlatformException catch (e) {
//       print('Invalid Token: $e');
//     }
//   }
// }
