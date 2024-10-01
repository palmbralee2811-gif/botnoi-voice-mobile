import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/screens/email/register_screen.dart';
import 'package:botnoivoice/presentation/screens/email/reset_password_screen.dart'; // Import reset password screen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // State variable for showing/hiding the password
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final emailLoginProvider = Provider.of<EmailLoginProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('เข้าสู่ระบบ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'อีเมล *'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'โปรดใส่อีเมลของคุณ' : null,
              ),
              const SizedBox(height: 16.0),
              // TextFormField with show/hide password functionality
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'รหัสผ่าน *',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                validator: (value) => value!.isEmpty ? 'โปรดใส่รหัสผ่านของคุณ' : null,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    emailLoginProvider.loginWithEmailPassword(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    ).then((_) {
                      if (emailLoginProvider.currentUser != null) {
                        // TODO: Change to "auth_checker.dart"
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthChecker()),);
                      }
                    });
                  }
                },
                child: const Text('เข้าสู่ระบบ'),
              ),
              const SizedBox(height: 16.0),
              // Display error message if present
              if (emailLoginProvider.errorMessage != null) ...[
                Text(
                  emailLoginProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 16.0),
              // Reset Password Button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
                  );
                },
                child: const Text('ลืมรหัสผ่าน? รีเซ็ตรหัสผ่าน'),
              ),
              const SizedBox(height: 16.0),
              // Registration button
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                },
                child: const Text('ยังไม่มีบัญชีผู้ใช้? ลงทะเบียน'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
