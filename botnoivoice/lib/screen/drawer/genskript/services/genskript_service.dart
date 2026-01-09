import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/api_constants.dart'; // Import your constants file

class GenSkriptService {
  static Future<void> handleCreateVoice({
    required String scriptText,
    required String speed,
    required String volume,
    String languageValue = "th",
  }) async {
    try {
      // Clean strings for API compatibility: "1.2x" -> "1.2", "100%" -> "100"
      final String cleanSpeed = speed.replaceAll('x', '');
      final String cleanVolume = volume.replaceAll('%', '');

      final Map<String, dynamic> payload = {
        "title": "genskript_ZHC",
        "audio": "",
        "isDownload": false,
        "isDownloaded": false,
        "isgenerate": false,
        "language": {"value": languageValue},
        "value": languageValue,
        "scripts": [
          {
            "script_id": "genskript_ZHCYQ_script_1",
            "audio": "", 
            "isDownload": false,
            "isDownloaded": false,
            "isgenerate": true,
            "ispaid": false,
            "script": scriptText,
            "speaker": "5", 
            "speed": cleanSpeed,
            "text": scriptText,
            "text_read": scriptText.replaceAll(' ', ''),
            "text_read_with_delay": scriptText.replaceAll(' ', ''),
            "volume": cleanVolume,
            "word_count": scriptText.length,
          }
        ],
        "speaker": "5",
        "speed": cleanSpeed,
        "volume": cleanVolume,
        "word_count": scriptText.length,
      };

      // Use the constant from ApiConstants
      final response = await http.post(
        Uri.parse(ApiConstants.genskriptUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print("Voice Generated Successfully via ${ApiConstants.genskriptUrl}");
      } else {
        print("API Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Connection Error: $e");
    }
  }
}