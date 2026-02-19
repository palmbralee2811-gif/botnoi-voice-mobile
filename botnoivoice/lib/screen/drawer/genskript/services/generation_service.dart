// lib/services/generation_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart'; // Import Logger
import '../data/app_data.dart';
import '../data/api_constants.dart';

// Initialize Logger with no emojis
var logger = Logger();

class GenerationService {
  static GenerationResult? lastGenerationResult;

  static Future<GenerationResult?> generate({
    required String prompt,
    String? imageUrl,
    required String language,
    required double wordCount,
    required double temperature,
  }) async {
    try {
      logger.d("Starting generation with prompt: $prompt");

      // Logic เตรียมข้อมูลรูปภาพ (Split URL ที่ส่งมาด้วย comma)
      List<Map<String, dynamic>> imagesPayload = [];
      if (imageUrl != null && imageUrl.isNotEmpty) {
        List<String> urls = imageUrl.split(','); // แยก URL ด้วยคอมมา
        for (int i = 0; i < urls.length; i++) {
          String pos = "middle";
          // กำหนด position ตามลำดับ
          if (i == 0)
            pos = "first";
          else if (i == urls.length - 1) pos = "last";

          // กรณีมีรูปเดียว ให้เป็น first
          if (urls.length == 1) pos = "first";

          imagesPayload.add({"url": urls[i].trim(), "position": pos});
        }
      }

      // 1. Prepare Payload
      final Map<String, dynamic> requestBody = {
        "custom_prompt": prompt,
        "language": language == 'ไทย' ? 'th' : 'en',
        "word_count": wordCount.round(),
        "temperature": temperature,
        "images": imagesPayload,
      };

      // 2. Send Request
      final response = await http.post(
        Uri.parse(ApiConstants.generateEndpoint),
        headers: ApiConstants.generateHeaders,
        body: jsonEncode(requestBody),
      );

      // Force UTF-8 decoding to handle Thai characters correctly
      final String decodedBody = utf8.decode(response.bodyBytes);

      logger.d("Status Code: ${response.statusCode}");
      logger.d("Response Body: $decodedBody");

      // 3. Handle Result
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(decodedBody);

        lastGenerationResult = GenerationResult.fromJson(responseData);
        return lastGenerationResult;
      } else {
        logger.e("Generation Failed: $decodedBody");
        return null;
      }
    } catch (e) {
      logger.e("Generation Service Error", error: e);
      return null;
    }
  }
}
