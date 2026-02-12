import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../data/api_constants.dart';

var logger = Logger(
);

class VoiceService {
  static String _generateRandomId(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
    ));
  }

  static Future<String?> handleCreateVoice({
    required String scriptText,
    required String speed,
    required String volume,
    required String languageValue, // e.g. 'th', 'en'
    String? speakerId,             // ✅ Optional: Allow passing specific speaker
  }) async {
    try {
      if (ApiConstants.Token.isEmpty) {
        logger.e("Error: API Token is empty in ApiConstants.dart");
        return null;
      }

      // 1. Prepare Data
      final String cleanSpeed = speed.replaceAll('x', '');
      final String cleanVolume = volume.replaceAll('%', '');
      final double speedNum = double.tryParse(cleanSpeed) ?? 1.0;
      final double volumeNum = double.tryParse(cleanVolume) ?? 100.0;

      // 2. Select Safe Speaker ID based on Language
      // If caller didn't provide an ID, pick a default that supports the language.
      String selectedSpeaker = speakerId ?? "1"; 
      if (speakerId == null) {
        if (languageValue.toLowerCase() == 'th') {
          selectedSpeaker = "1";  // Speaker 1 supports Thai
        } else if (languageValue.toLowerCase() == 'en') {
          selectedSpeaker = "55"; // Example: Speaker 55 supports English
        } else {
          selectedSpeaker = "1";  // Fallback
        }
      }

      // --- Generate IDs ---
      final String randomStr = _generateRandomId(5);
      final String workspaceId = "genskript_$randomStr";
      final String audioId = "${workspaceId}_script_1";

      logger.d("Step 1: Generating Audio ($audioId)");
      logger.d("👉 Config: Speaker=$selectedSpeaker | Lang=$languageValue");

      // ==========================================
      // STEP 1: POST to Generate Audio
      // ==========================================
      final Map<String, dynamic> generatePayload = {
        "audio_id": audioId,
        "text": scriptText,
        "speaker": selectedSpeaker, // ✅ Use the validated speaker ID
        "volume": volumeNum,
        "speed": speedNum,
        "language": languageValue
      };

      final genResponse = await http.post(
        Uri.parse(ApiConstants.genskriptUrl),
        headers: ApiConstants.generateHeaders,
        body: jsonEncode(generatePayload),
      );

      String? audioUrl;

      if (genResponse.statusCode == 200 || genResponse.statusCode == 201) {
        final genBody = utf8.decode(genResponse.bodyBytes);
        final genData = jsonDecode(genBody);
        
        logger.d("Step 1 Response: $genData"); 

        audioUrl = genData['data'] ?? 
                   genData['audio_url'] ?? 
                   genData['url'] ?? 
                   genData['file_url'];
      } else {
        logger.e("⛔ Step 1 Failed: ${genResponse.statusCode} - ${genResponse.body}");
        return null; 
      }

      if (audioUrl == null || audioUrl.isEmpty) {
        logger.e("Step 1 Error: URL is null.");
        return null;
      }

      // ==========================================
      // STEP 2: POST to Save Workspace (Create New)
      // ==========================================
      final String saveWorkspaceUrl = ApiConstants.workspaceEndpoint;

      logger.d("Step 2: Saving Workspace...");
      
      final Map<String, dynamic> workspacePayload = {
        "title": workspaceId, 
        "audio": audioUrl,
        "isDownload": false,
        "isDownloaded": false,
        "isgenerate": true,
        "language": {"value": languageValue},
        "value": languageValue,
        "scripts": [
          {
            "script_id": audioId,
            "audio": audioUrl,
            "isDownload": false,
            "isDownloaded": false,
            "isgenerate": true,
            "ispaid": false,
            "script": scriptText,
            "speaker": selectedSpeaker, // ✅ Consistent Speaker ID
            "speed": cleanSpeed,
            "text": scriptText,
            "text_read": scriptText.replaceAll(' ', ''),
            "text_read_with_delay": scriptText.replaceAll(' ', ''),
            "volume": cleanVolume,
            "word_count": scriptText.length,
          }
        ],
        "speaker": selectedSpeaker, // ✅ Consistent Speaker ID
        "speed": cleanSpeed,
        "volume": cleanVolume,
        "word_count": scriptText.length,
      };

      final saveResponse = await http.post(
        Uri.parse(saveWorkspaceUrl),
        headers: ApiConstants.generateHeaders,
        body: jsonEncode(workspacePayload),
      );

      if (saveResponse.statusCode == 200 || saveResponse.statusCode == 201) {
        logger.d("Step 2 Success: Workspace saved.");
      } else {
        logger.w("Step 2 Warning: Failed to save workspace (${saveResponse.statusCode}), but audio was generated.");
      }

      return audioUrl;

    } catch (e) {
      logger.e("Connection Error in VoiceService", error: e);
      return null;
    }
  }
}