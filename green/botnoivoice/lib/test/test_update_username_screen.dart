import 'package:botnoivoice/presentation/providers/email/email_username_token_provider.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestUpdateUsernameScreen extends StatefulWidget {
  const TestUpdateUsernameScreen({super.key});

  @override
  State<TestUpdateUsernameScreen> createState() =>
      _TestUpdateUsernameScreenState();
}

class _TestUpdateUsernameScreenState extends State<TestUpdateUsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  String _result = ''; // แสดงผลลัพธ์จาก API

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Update Username'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Enter New Username',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String newUsername = _usernameController.text.trim();
                String userId = 'example-firebase-uid'; // Replace with your Firebase UID

                if (newUsername.isNotEmpty) {
                  // เรียกใช้งานฟังก์ชัน postUpdateUsernameByFirebaseUid
                  await Provider.of<EmailUsernameTokenProvider>(context,
                          listen: false)
                      .postUpdateUsernameByFirebaseUid(userId, 'username_id', newUsername);

                  // อัพเดตผลลัพธ์
                  setState(() {
                    _result = Provider.of<EmailUsernameTokenProvider>(context,
                            listen: false)
                        .result; // ดึงข้อมูล result ที่ได้จาก logger
                  });
                }
              },
              child: const Text('Update Username'),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Result: $_result',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
