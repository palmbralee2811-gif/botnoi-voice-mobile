import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../data/api_constants.dart';

var logger = Logger();

class VideoService {
  // Helper to generate IDs
  static String generateWorkspaceId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    String randomStr = String.fromCharCodes(Iterable.generate(
      5,
      (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
    ));
    return "genskript_$randomStr";
  }

  // ✅ POLLING HELPER: Matches Log #7 URL Structure
  static Future<String?> _pollTaskStatus(String taskId, Map<String, String> headers) async {
    // ⚠️ CRITICAL FIX: Status is checked at 'document-flow', not 'audio-img-flow'
    final String statusUrl = "https://api-voice-staging.botnoi.ai/api/genai/document-flow/tasks/$taskId";
    
    logger.i("⏳ Polling Status: $statusUrl");

    // Wait up to ~5 minutes
    int maxRetries = 30; 
    
    for (int i = 0; i < maxRetries; i++) {
      await Future.delayed(const Duration(seconds: 10));

      try {
        final response = await http.get(Uri.parse(statusUrl), headers: headers);
        
        if (response.statusCode == 200) {
          final data = jsonDecode(utf8.decode(response.bodyBytes));
          final statusData = data['data'] ?? data; 
          final String status = (statusData['status'] ?? "pending").toString().toLowerCase();
          
          if (i % 3 == 0) logger.d("Poll Attempt ${i+1}: $status");

          if (status == "success" || status == "completed" || status == "done") {
             // Extract URL from 'result' object or root keys
             // Looking for the MP4 link seen in Log #8
             String? realUrl = statusData['result_url'] ?? statusData['video_url'] ?? statusData['url'];
             
             // Sometimes it's nested in 'result'
             if (realUrl == null && statusData['result'] != null) {
               realUrl = statusData['result']['video_url'] ?? statusData['result']['url'];
             }

             if (realUrl != null) {
               logger.i("✅ Video Ready: $realUrl");
               return realUrl;
             }
          } else if (status == "failed" || status == "error") {
             logger.e("❌ Task Failed: ${statusData['error'] ?? 'Unknown'}");
             return null;
          }
        } 
      } catch (e) {
        logger.w("Polling error: $e");
      }
    }
    
    logger.e("❌ Polling timed out.");
    return null;
  }

  static void handleFreeVideo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Free Video creation coming soon!")),
    );
  }

  static Future<String?> handleCreateVideo({
    required String scriptText,
    required String imageUrl,
    required String language,
    required int audioPoints,
    required int videoPoints,
  }) async {
    // 1. Validate Token
    if (ApiConstants.Token.isEmpty) {
      logger.e("❌ Error: Token is empty!");
      return null;
    }

    final String workspaceId = generateWorkspaceId();
    final String audioId = "${workspaceId}_0";
    final String scriptId = "${workspaceId}_script_1";

    try {
      // ---------------------------------------------------------
      // 1. GENERATE VOICE (POST)
      // ---------------------------------------------------------
      logger.d("VideoService Step 1: Generating Voice...");
      
      final genVoicePayload = {
        "audio_id": audioId, "language": language, "speaker": "5", "speaker_v2": false, 
        "speed": "1", "text": scriptText, "text_delay": "", "type_media": "mp3", "volume": "100"
      };

      final genResponse = await http.post(
        Uri.parse("https://api-voice-staging.botnoi.ai/voice/v1/generate_voice?provider=studio"),
        headers: ApiConstants.generateHeaders,
        body: jsonEncode(genVoicePayload),
      );

      if (genResponse.statusCode != 200) throw Exception("Voice Gen Failed");
      final genData = jsonDecode(utf8.decode(genResponse.bodyBytes));
      
      String audioUrl = "";
      final dynamic dataField = genData['data'];
      if (dataField is String) audioUrl = dataField;
      else if (dataField is List && dataField.isNotEmpty) audioUrl = dataField[0]['url'] ?? "";
      else if (dataField is Map) audioUrl = dataField['url'] ?? "";
      else audioUrl = genData['url'] ?? genData['audio_url'] ?? "";

      if (audioUrl.isEmpty) throw Exception("Audio URL is empty.");

      // ---------------------------------------------------------
      // 2, 3, 4. DEDUCT POINTS & SAVE WORKSPACE
      // ---------------------------------------------------------
      await http.post(Uri.parse("https://api-voice-staging.botnoi.ai/api/dashboard/download_voice"), headers: ApiConstants.generateHeaders, body: jsonEncode({"point": audioPoints, "data": [{"audio_id": audioId, "language": language, "message": scriptText, "page": "studio", "speaker": "5", "version": "v1", "point": audioPoints}]}));
      await http.put(Uri.parse("https://api-voice-staging.botnoi.ai/api/genai/genskript-workspaces/$workspaceId"), headers: ApiConstants.generateHeaders, body: jsonEncode({"title": workspaceId, "language": {"value": language}, "scripts": [{"script_id": scriptId, "audio": audioUrl, "script": scriptText}]}));
      await http.post(Uri.parse("https://api-voice-staging.botnoi.ai/api/dashboard/download_voice"), headers: ApiConstants.generateHeaders, body: jsonEncode({"point": videoPoints, "data": [{"audio_id": "${workspaceId}_hq_video", "message": "HQ Video", "point": videoPoints}]}));

      // ---------------------------------------------------------
      // 4.5 GET LATEST TOKEN (Log #5)
      // ---------------------------------------------------------
      // ⚠️ IMPORTANT: Using the specific User ID from your logs because Staging requires it.
      const String fetchUserId = "MV4jYuiy01UUk9A9FiacPUIuu0q1";
      String activeToken = ApiConstants.Token; 

      try {
        final tokenResponse = await http.get(
          Uri.parse("https://api-voice-staging.botnoi.ai/db/dashboard/get_token?user_id=$fetchUserId"),
          headers: ApiConstants.generateHeaders,
        );

        if (tokenResponse.statusCode == 200) {
           final dynamic decoded = jsonDecode(utf8.decode(tokenResponse.bodyBytes));
           if (decoded is Map) {
             if (decoded['token'] is String) activeToken = decoded['token'];
             else if (decoded['data'] is String) activeToken = decoded['data'];
             else if (decoded['data'] is Map && decoded['data']['token'] is String) activeToken = decoded['data']['token'];
           }
           logger.d("Step 4.5: Active Token Fetched Successfully.");
        }
      } catch (e) {
        logger.w("Step 4.5 Failed. Using default token.");
      }

      // ---------------------------------------------------------
      // 5. CREATE VIDEO TASK (Log #6)
      // ---------------------------------------------------------
      logger.d("VideoService Step 5: Creating Video Task...");
      
      final Map<String, String> taskHeaders = Map<String, String>.from(ApiConstants.generateHeaders);
      taskHeaders['botnoi-token'] = activeToken; // ✅ Use fetched token

      final taskPayload = {
        "genskript_id": workspaceId,
        "type_user": "starter",
        "delay_seconds": 2,
        "codec_video": "h264",
        "data": [
          {
            "script_id": scriptId,
            "text": scriptText,
            "audio_url": audioUrl, // ✅ Matches Log #6
            "image_url": imageUrl  // ✅ Matches Log #6
          }
        ]
      };

      final taskResponse = await http.post(
        Uri.parse("https://api-voice-staging.botnoi.ai/api/genai/audio-img-flow/tasks"),
        headers: taskHeaders,
        body: jsonEncode(taskPayload),
      );

      if (taskResponse.statusCode >= 200 && taskResponse.statusCode < 300) {
        
        final respData = jsonDecode(utf8.decode(taskResponse.bodyBytes));
        // Try 'task_id' (common) or 'data.task_id'
        String? taskId = respData['data']?['task_id'] ?? respData['task_id'];

        if (taskId != null) {
          logger.i("🚀 Task Started: $taskId. Polling...");
          // ✅ Poll the 'document-flow' endpoint (Matches Log #7)
          return await _pollTaskStatus(taskId, taskHeaders);
        } else {
          logger.e("⛔ No task_id found in response: ${taskResponse.body}");
          return null;
        }

      } else {
        logger.e("Video Task Creation Failed: ${taskResponse.body}");
        return null;
      }

    } catch (e) {
      logger.e("Video Creation Error", error: e);
      return null;
    }
  }
}