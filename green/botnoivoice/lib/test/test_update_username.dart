import 'package:botnoivoice/presentation/providers/email/email_username_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestUpdateUsername extends StatelessWidget {
  final TextEditingController _uidController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  TestUpdateUsername({super.key});

  @override
  Widget build(BuildContext context) {
    final emailUsernameProvider =
        Provider.of<EmailUsernameApiProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test API Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _uidController,
              decoration: const InputDecoration(labelText: 'UID Firebase'),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username New'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final uid = _uidController.text;
                final username = _usernameController.text;
                final email = _emailController.text;

                // เรียกใช้ฟังก์ชัน postRegisterMobileUser
                emailUsernameProvider.postSendUsernameToDatabase(
                    uid, username, email);
              },
              child: const Text('ลงทะเบียนผู้ใช้'),
            ),
            const SizedBox(height: 20),
            const Text(
              'ผลลัพธ์จาก API:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(emailUsernameProvider.result),
          ],
        ),
      ),
    );
  }
}
