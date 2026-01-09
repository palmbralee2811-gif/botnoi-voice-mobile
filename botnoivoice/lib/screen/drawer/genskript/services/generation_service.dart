// lib/services/generation_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/app_data.dart'; // ดึงโมเดลมาจากที่นี่ที่เดียว
import '../data/api_constants.dart';

class GenerationService {
  // สร้างตัวแปรเก็บผลลัพธ์ล่าสุดไว้ที่นี่ (ถ้าต้องการใช้ข้ามหน้า)
  static GenerationResult? lastGenerationResult;

  static Future<GenerationResult?> generate({
    required String prompt,
    String? imageUrl,
    required String language,
    required double wordCount,
    required double temperature,
  }) async {
    try {
      // 1. จัดเตรียม Payload
      final Map<String, dynamic> requestBody = {
        "custom_prompt": prompt,
        "language": language == 'ไทย' ? 'th' : 'en',
        "word_count": wordCount.round(),
        "temperature": temperature,
        "images": (imageUrl != null && imageUrl.isNotEmpty)
            ? [
                {
                  "url": imageUrl,
                  "position": "first" // ใช้ "first" ตามที่ API ต้องการ
                }
              ]
            : [],
      };

      // 2. ส่งคำขอไปยัง API
      final response = await http.post(
        Uri.parse(ApiConstants.generateEndpoint),
        headers: ApiConstants.generateHeaders,
        body: jsonEncode(requestBody),
      );

      print("--- GENERATION DEBUG ---");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // 3. จัดการผลลัพธ์
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        // แปลง JSON เป็น Object จากคลาสใน app_data.dart
        lastGenerationResult = GenerationResult.fromJson(responseData);
        return lastGenerationResult;
      } else {
        print("Generation Failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Generation Service Error: $e");
      return null;
    }
  }
}