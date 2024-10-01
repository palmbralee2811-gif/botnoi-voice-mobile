import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';

class ConfirmPasswordResetScreen extends StatelessWidget {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  ConfirmPasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailLoginProvider = Provider.of<EmailLoginProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Password Reset')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Enter code from email'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _newPasswordController,
              decoration: const InputDecoration(labelText: 'Enter new password'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final code = _codeController.text.trim();
                final newPassword = _newPasswordController.text.trim();

                if (code.isNotEmpty && newPassword.isNotEmpty) {
                  emailLoginProvider.confirmPasswordReset(code, newPassword);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password has been reset successfully.'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter both code and new password.'),
                    ),
                  );
                }
              },
              child: const Text('Confirm Password Reset'),
            ),
            if (emailLoginProvider.errorMessage != null) ...[
              const SizedBox(height: 16.0),
              Text(
                emailLoginProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
