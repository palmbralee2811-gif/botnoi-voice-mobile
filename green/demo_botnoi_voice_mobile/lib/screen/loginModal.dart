// import 'package:demo_botnoi_voice_mobile/function/randomString.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_line_sdk/flutter_line_sdk.dart';

// class SignInPage extends StatelessWidget {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   SignInPage({super.key});

//   void _signInWithGoogle() async {
//     try {
//       await _googleSignIn.signIn();
//     } catch (error) {
//       print(error);
//     }
//   }

//   void _signInWithLine(BuildContext context) async {
//     try {
//       final result = await LineSDK.instance.login();
//       print('Login Success: ${result.accessToken.value}');
//     } catch (error) {
//       print('Login failed: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign In'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => _showSignInModal(context),
//           child: const Text('Sign In'),
//         ),
//       ),
//     );
//   }

//   void _showSignInModal(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'เข้าสู่ระบบ',
//                 style: TextStyle(fontSize: 24),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton.icon(
//                 onPressed: _signInWithGoogle,
//                 // icon: Image.asset('assets/google_logo.png', height: 24),
//                 icon: const Icon(Icons.add),
//                 label: const Text('เข้าสู่ระบบด้วย Google'),
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.black,
//                   backgroundColor: Colors.white,
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton.icon(
//                 onPressed: () => _signInWithLine(context),
//                 // icon: Image.asset('assets/line_logo.png', height: 24),
//                 icon: const Icon(Icons.edit),
//                 label: const Text('เข้าสู่ระบบด้วย Line'),
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.green,
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text.rich(
//                 TextSpan(
//                   text:
//                       'By continuing, you are indicating that you accept our ',
//                   children: [
//                     TextSpan(
//                       text: 'Terms of Service',
//                       style: const TextStyle(
//                         color: Colors.blue,
//                         // decoration: TextDecoration.underline,
//                       ),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           // Navigate to Terms of Service
//                           print(' *** Terms of Service ${randomString(4)}');
//                         },
//                     ),
//                     const TextSpan(text: ' and '),
//                     TextSpan(
//                       text: 'Privacy Policy',
//                       style: const TextStyle(
//                         color: Colors.blue,
//                         // decoration: TextDecoration.underline,
//                       ),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           // Navigate to Privacy Policy
//                           print(' *** Privacy Policy ${randomString(4)}');
//                         },
//                     ),
//                     const TextSpan(text: '.'),
//                   ],
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
