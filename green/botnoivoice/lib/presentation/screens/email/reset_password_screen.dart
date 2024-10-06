// import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ResetPasswordScreen extends StatelessWidget {
//   final TextEditingController _emailController = TextEditingController();

//   ResetPasswordScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final emailLoginProvider = Provider.of<EmailLoginProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Reset Password')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: _emailController,
//               decoration: const InputDecoration(labelText: 'Enter your email'),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 final email = _emailController.text.trim();
//                 if (email.isNotEmpty) {
//                   emailLoginProvider.resetPassword(email);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Password reset email sent to $email'),
//                     ),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Please enter your email'),
//                     ),
//                   );
//                 }
//               },
//               child: const Text('Reset Password'),
//             ),
//             if (emailLoginProvider.errorMessage != null) ...[
//               const SizedBox(height: 16.0),
//               Text(
//                 emailLoginProvider.errorMessage!,
//                 style: const TextStyle(color: Colors.red),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
