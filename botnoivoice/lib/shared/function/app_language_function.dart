import 'package:shared_preferences/shared_preferences.dart';

/// Save the selected language in shared preferences
Future<void> saveSelectedLanguage(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('selected_language', languageCode);
}

/// Load the selected language from shared preferences
Future<String> loadSelectedLanguage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('selected_language') ?? ''; // ตั้งภาษาเริ่มต้นที่แสดงเป็นค่าว่าง ตามภาษาที่ถูกเลือกหน้าแรก
}
