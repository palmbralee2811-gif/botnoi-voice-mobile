import 'package:shared_preferences/shared_preferences.dart';

class AppLanguageFunction {
  static const String _languageKey = 'selected_language';

  // บันทึกภาษาที่ผู้ใช้เลือก
  static Future<void> saveSelectedLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  // โหลดภาษาที่บันทึกไว้
  static Future<String> loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? '';
  }
}
