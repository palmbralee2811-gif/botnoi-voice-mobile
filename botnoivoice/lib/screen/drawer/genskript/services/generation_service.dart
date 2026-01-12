// lib/services/generation_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart'; // Import Logger
import '../data/app_data.dart';
import '../data/api_constants.dart';

// Initialize Logger with no emojis
var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 80,
    colors: true,
    printEmojis: false, // Strictly disable emojis
    printTime: false,
  ),
);

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

      // 1. Prepare Payload
      final Map<String, dynamic> requestBody = {
        "custom_prompt": prompt,
        "language": language == 'ไทย' ? 'th' : 'en',
        "word_count": wordCount.round(),
        "temperature": temperature,
        "images": (imageUrl != null && imageUrl.isNotEmpty)
            ? [
                {
                  "url": imageUrl,
                  "position": "first"
                }
              ]
            : [],
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