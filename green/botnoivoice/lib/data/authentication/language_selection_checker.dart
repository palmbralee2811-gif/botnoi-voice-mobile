import 'package:botnoivoice/presentation/screens/select_language/select_language_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:botnoivoice/data/authentication/auth_checker.dart';

class LanguageSelectionChecker extends StatelessWidget {
  const LanguageSelectionChecker({super.key});

  // โหลดภาษาที่บันทึกไว้
  Future<String> loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('selected_language') ?? ''; // ค่าเริ่มต้นเป็นค่าว่าง
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: loadSelectedLanguage(), // โหลดภาษาเริ่มต้นจาก SharedPreferences
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // ระหว่างโหลด แสดง Progress Indicator
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          // หากเลือกภาษาไว้แล้ว แสดงหน้าจอ AuthChecker
          return AuthChecker();
        } else {
          // หากยังไม่เลือกภาษา แสดงหน้าจอ LanguageSelectionScreen
          return const LanguageSelectionScreen();
        }
      },
    );
  }
}
