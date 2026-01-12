import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../data/api_constants.dart';

// Initialize Logger (No Emojis)
var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 80,
    colors: true,
    printEmojis: false,
    printTime: false,
  ),
);

class VoiceService {
  // Helper to generate random ID (e.g., Q8ZDY)
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
    String languageValue = "th",
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

      // --- Generate IDs ---
      final String randomStr = _generateRandomId(5);
      final String workspaceId = "genskript_$randomStr";
      final String audioId = "${workspaceId}_script_1";

      logger.d("Step 1: Generating Audio ($audioId)...");

      // ==========================================
      // STEP 1: POST to Generate Audio
      // ==========================================
      final Map<String, dynamic> generatePayload = {
        "audio_id": audioId,
        "text": scriptText,
        "speaker": "5",
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
        
        logger.d("Step 1 Raw Response: $genData"); 

        audioUrl = genData['data'] ?? 
                   genData['audio_url'] ?? 
                   genData['url'] ?? 
                   genData['file_url'];

        logger.d("Step 1 Extracted URL: $audioUrl");
      } else {
        logger.e("Step 1 Failed: ${genResponse.statusCode} - ${genResponse.body}");
        return null;
      }

      if (audioUrl == null || audioUrl.isEmpty) {
        logger.e("Step 1 Error: URL is null. Server returned: ${genResponse.body}");
        return null;
      }

      // ==========================================
      // STEP 2: POST to Save Workspace (Create New)
      // ==========================================
      // ⚠️ FIX: Use the base endpoint (do not append /workspaceId to URL)
      final String saveWorkspaceUrl = ApiConstants.workspaceEndpoint;

      logger.d("Step 2: Saving to Workspace (Creating New)...");
      logger.d("Step 2 URL: $saveWorkspaceUrl");

      final Map<String, dynamic> workspacePayload = {
        "title": workspaceId, // ID is sent here instead
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

      // ⚠️ FIX: Changed from PUT to POST
      final saveResponse = await http.post(
        Uri.parse(saveWorkspaceUrl),
        headers: ApiConstants.generateHeaders,
        body: jsonEncode(workspacePayload),
      );

      if (saveResponse.statusCode == 200 || saveResponse.statusCode == 201) {
        logger.d("Step 2 Success: Workspace saved/created.");
      } else {
        logger.e("Step 2 Failed (${saveResponse.statusCode}): ${saveResponse.body}");
        // We still return audioUrl because Step 1 (Audio Gen) succeeded
      }

      return audioUrl;

    } catch (e) {
      logger.e("Connection Error in VoiceService", error: e);
      return null;
    }
  }
}