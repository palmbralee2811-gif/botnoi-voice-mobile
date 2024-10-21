import 'package:botnoivoice/presentation/providers/email/email_username_token_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestGetUsernameByEmailScreen extends StatefulWidget {
  const TestGetUsernameByEmailScreen({super.key});

  @override
  State<TestGetUsernameByEmailScreen> createState() =>
      _TestGetUsernameByEmailScreenState();
}

class _TestGetUsernameByEmailScreenState
    extends State<TestGetUsernameByEmailScreen> {
  final TextEditingController _usernameController = TextEditingController();
  String _result = ''; // แสดงผลลัพธ์จาก API

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Get Username By Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Enter Username',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String email = _usernameController.text.trim();
                if (email.isNotEmpty) {
                  // เรียกใช้งานฟังก์ชัน getEmailByUsername
                  await Provider.of<EmailUsernameTokenProvider>(context,
                          listen: false)
                      .getUsernameByEmail(email);

                  // อัพเดตผลลัพธ์
                  setState(() {
                    _result = Provider.of<EmailUsernameTokenProvider>(context,
                            listen: false)
                        .result; // ดึงข้อมูล result ที่ได้จาก logger
                  });
                }
              },
              child: const Text('Get Email'),
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
