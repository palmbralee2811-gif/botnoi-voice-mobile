import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/api_constants.dart';
import '../data/app_data.dart';

class TranslationService {
  static Future<String?> handleTranslate({
    required String currentScript,
    required String targetLanguageName,
    String imageUrl = "1.png",
    String position = "first",
  }) async {
    try {
      // 1. ดึง ISO Code จาก AppData
      final langData = AppData.languages.firstWhere(
        (lang) => lang['name'] == targetLanguageName,
        orElse: () => {'code': 'en'},
      );

      String targetCode = langData['code']!;

      // 2. เตรียม Payload
      final Map<String, dynamic> requestBody = {
        "scripts_data": [
          {
            "image_url": imageUrl,
            "position": position,
            "script": currentScript,
          },
        ],
        "target_language": targetCode,
      };

      final response = await http.post(
        Uri.parse(ApiConstants.translateEndpoint),
        headers: ApiConstants.generateHeaders,
        body: jsonEncode(requestBody),
      );

      print("--- TRANSLATION DEBUG ---");
      print("Target Language: $targetLanguageName (Code: $targetCode)");
      print("Status: ${response.statusCode}");
      
      // ✅ แก้ไข: ใช้ utf8.decode(response.bodyBytes) เพื่อรองรับภาษาไทย
      String responseBody = utf8.decode(response.bodyBytes); 

      if (response.statusCode == 307) {
        print("Redirect to: ${response.headers['location']}");
      }

      if (response.statusCode == 422) {
        print("422 Error Detail: $responseBody");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ แก้ไข: Parse JSON จาก String ที่ decode แล้ว
        final data = jsonDecode(responseBody);

        print("Translation Response Body: $responseBody");

        if (data['scripts_data'] != null && data['scripts_data'].isNotEmpty) {
          return data['scripts_data'][0]['script']?.toString();
        } else if (data['scripts'] != null && data['scripts'].isNotEmpty) {
          return data['scripts'][0]['script']?.toString();
        }
      }

      return null;
    } catch (e) {
      print("Translation Exception: $e");
      return null;
    }
  }
}