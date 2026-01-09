import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/api_constants.dart';
import '../data/app_data.dart'; // 1. Import ไฟล์ AppData เข้ามา

class TranslationService {
  // ลบ _languageMap ชุดเก่าทิ้งไปเลยครับ เพราะเราจะใช้ข้อมูลจาก AppData แทน

  static Future<String?> handleTranslate({
    required String currentScript,
    required String targetLanguageName,
    String imageUrl = "1.png",
    String position = "first",
  }) async {
    try {
      // 2. ดึง ISO Code จาก AppData.languages โดยการค้นหาจากชื่อภาษา
      // เราใช้ .firstWhere เพื่อหา Map ที่มีชื่อตรงกับที่ User เลือกมาจาก UI
      final langData = AppData.languages.firstWhere(
        (lang) => lang['name'] == targetLanguageName,
        orElse: () => {
          'code': 'en',
        }, // ถ้าหาไม่เจอ ให้แปลเป็นภาษาอังกฤษเป็นค่าเริ่มต้น
      );

      String targetCode = langData['code']!;

      // 3. เตรียม Payload ตามโครงสร้างที่ API ต้องการ
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
      print("Full URL: ${ApiConstants.translateEndpoint}");

      if (response.statusCode == 307) {
        // ดูว่า Server บอกให้เราไปที่ URL ไหนกันแน่
        print("Redirect to: ${response.headers['location']}");
      }

      if (response.statusCode == 422) {
        // สำคัญมาก: Print ดูว่า Server บ่นเรื่องฟิลด์ไหน
        print("422 Error Detail: ${response.body}");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // --- เพิ่มบรรทัดนี้เพื่อดูโครงสร้าง JSON ที่ได้จากการแปล ---
        print("Translation Response Body: ${response.body}");

        // ตรวจสอบว่า Key ชื่อ 'scripts_data' หรือ 'scripts' กันแน่
        if (data['scripts_data'] != null && data['scripts_data'].isNotEmpty) {
          return data['scripts_data'][0]['script']?.toString();
        } else if (data['scripts'] != null && data['scripts'].isNotEmpty) {
          // เผื่อไว้ในกรณีที่ API แปลภาษาใช้ Key เหมือนตอนสร้างสคริปต์
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
