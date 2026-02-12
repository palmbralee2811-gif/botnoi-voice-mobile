import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../data/api_constants.dart';

var logger = Logger();

class VideoService {
  static String generateWorkspaceId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    String randomStr = String.fromCharCodes(Iterable.generate(
      5,
      (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
    ));
    return "genskript_$randomStr";
  }

  // ✅ UPDATED: Now accepts 'token' parameter
  static Future<void> _saveWorkspaceToHistory({
    required String token, // <--- NEW PARAMETER
    required String workspaceId,
    required String scriptText,
    required String audioUrl,
    required String language,
    String? videoUrl,
  }) async {
    final String scriptId = "${workspaceId}_script_1";

    final Map<String, dynamic> payload = {
      "title": workspaceId,
      "text": scriptText,
      "audio": audioUrl,
      "isgenerate": true,
      "language": {"value": language, "label": "Thai"},
      "speaker": "5",
      "speed": "1",
      "volume": "100",
      "scripts": [
        {
          "script_id": scriptId,
          "script": scriptText,
          "audio": audioUrl,
          "isgenerate": true,
          "speaker": "5",
          "ispaid": true
        }
      ]
    };

    if (videoUrl != null) {
      payload['video_url'] = videoUrl;
      payload['final_video_url'] = videoUrl;
      (payload['scripts'] as List)[0]['video_url'] = videoUrl;
    }

    try {
      final response = await http.put(
        Uri.parse(
            "https://api-voice-staging.botnoi.ai/api/genai/genskript-workspaces/$workspaceId"),
        headers: {
          'Content-Type': 'application/json',
          'botnoi-token': token, // ✅ Uses the passed Staging Token
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        logger.i("✅ Workspace Saved (Video: ${videoUrl != null})");
      } else {
        logger.e("❌ Failed to save history: ${response.body}");
      }
    } catch (e) {
      logger.e("❌ Save History Error: $e");
    }
  }

  static Future<String?> _pollTaskStatus(
      String taskId, Map<String, String> headers) async {
    final String statusUrl =
        "https://api-voice-staging.botnoi.ai/api/genai/document-flow/tasks/$taskId";
    logger.i("⏳ Polling Status: $statusUrl");

    int maxRetries = 60;

    for (int i = 0; i < maxRetries; i++) {
      await Future.delayed(const Duration(seconds: 10));

      try {
        final response = await http.get(Uri.parse(statusUrl), headers: headers);

        if (response.statusCode == 200) {
          final data = jsonDecode(utf8.decode(response.bodyBytes));
          final statusData = data['data'] ?? data;
          final String status =
              (statusData['status'] ?? "pending").toString().toLowerCase();

          if (i % 3 == 0) logger.d("Attempt ${i + 1}: $status");

          if (status == "success" ||
              status == "completed" ||
              status == "done") {
            String? realUrl = statusData['final_video_url'] ??
                statusData['result_url'] ??
                statusData['video_url'];

            if (realUrl == null && statusData['result'] is Map) {
              final result = statusData['result'];
              realUrl = result['video_url'] ?? result['url'];
              if (realUrl == null &&
                  result['slides'] is List &&
                  result['slides'].isNotEmpty) {
                realUrl = result['slides'][0]['video_url'];
              }
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
    return null;
  }

  static void handleFreeVideo(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Coming soon!")));
  }

  static Future<String?> handleCreateVideo({
    required String scriptText,
    required String imageUrl,
    required String language,
    required int audioPoints,
    required int videoPoints,
    String videoCodec = "h264",
  }) async {
    if (ApiConstants.Token.isEmpty) {
      logger.e("❌ Error: Token is empty!");
      return null;
    }

    final String workspaceId = generateWorkspaceId();
    final String audioId = "${workspaceId}_0";
    final Map<String, String> standardHeaders =
        Map<String, String>.from(ApiConstants.generateHeaders);
    standardHeaders['Content-Type'] = 'application/json';

    try {
      // ---------------------------------------------------------
      // STEP 1: GET STAGING TOKEN (MOVED TO TOP)
      // ---------------------------------------------------------
      logger.d("Step 1: Fetching Staging Token...");
      const String logUserId = "MV4jYuiy01UUk9A9FiacPUIuu0q1";
      String genAiToken = ApiConstants.Token;

      try {
        final tokenResponse = await http.get(
            Uri.parse(
                "https://api-voice-staging.botnoi.ai/db/dashboard/get_token?user_id=$logUserId"),
            headers: standardHeaders);
        if (tokenResponse.statusCode == 200) {
          final dynamic decoded =
              jsonDecode(utf8.decode(tokenResponse.bodyBytes));
          if (decoded is Map) {
            if (decoded['token'] is String)
              genAiToken = decoded['token'];
            else if (decoded['data'] is String)
              genAiToken = decoded['data'];
            else if (decoded['data'] is Map &&
                decoded['data']['token'] is String)
              genAiToken = decoded['data']['token'];
          }
        }
      } catch (_) {
        logger.w("⚠️ Failed to fetch specific token, using default.");
      }

      // ---------------------------------------------------------
      // STEP 2: GENERATE VOICE
      // ---------------------------------------------------------
      logger.d("Step 2: Generating Voice...");
      final genVoicePayload = {
        "audio_id": audioId,
        "language": language,
        "speaker": "5",
        "speaker_v2": false,
        "speed": "1",
        "text": scriptText,
        "type_media": "mp3",
        "volume": "100"
      };

      final genResponse = await http.post(
        Uri.parse(
            "https://api-voice-staging.botnoi.ai/voice/v1/generate_voice?provider=studio"),
        headers: standardHeaders,
        body: jsonEncode(genVoicePayload),
      );

      if (genResponse.statusCode != 200) throw Exception("Voice Gen Failed");
      final genData = jsonDecode(utf8.decode(genResponse.bodyBytes));

      String audioUrl = "";
      final dynamic dataField = genData['data'];
      if (dataField is String)
        audioUrl = dataField;
      else if (dataField is List && dataField.isNotEmpty)
        audioUrl = dataField[0]['url'] ?? "";
      else if (dataField is Map)
        audioUrl = dataField['url'] ?? "";
      else
        audioUrl = genData['url'] ?? genData['audio_url'] ?? "";

      if (audioUrl.isEmpty) throw Exception("Audio URL is empty.");

      // ---------------------------------------------------------
      // STEP 3: DEDUCT POINTS
      // ---------------------------------------------------------
      await http.post(
          Uri.parse(
              "https://api-voice-staging.botnoi.ai/api/dashboard/download_voice"),
          headers: standardHeaders,
          body: jsonEncode({
            "point": audioPoints,
            "data": [
              {
                "audio_id": audioId,
                "language": language,
                "message": scriptText,
                "page": "studio",
                "speaker": "5",
                "version": "v1",
                "point": audioPoints
              }
            ]
          }));
      await http.post(
          Uri.parse(
              "https://api-voice-staging.botnoi.ai/api/dashboard/download_voice"),
          headers: standardHeaders,
          body: jsonEncode({
            "point": videoPoints,
            "data": [
              {
                "audio_id": "${workspaceId}_hq_video",
                "message": "HQ Video",
                "point": videoPoints
              }
            ]
          }));

      // ---------------------------------------------------------
      // STEP 4: SAVE WORKSPACE (Now using correct token)
      // ---------------------------------------------------------
      logger.d("Step 4: Saving Initial Workspace...");
      await _saveWorkspaceToHistory(
        token: genAiToken, // ✅ PASS CORRECT TOKEN
        workspaceId: workspaceId,
        scriptText: scriptText,
        audioUrl: audioUrl,
        language: language,
        videoUrl: null,
      );

      // ---------------------------------------------------------
      // STEP 5: CREATE VIDEO TASK
      // ---------------------------------------------------------
      logger.d("Step 5: Creating Video Task...");
      final Map<String, String> taskHeaders = {
        'Content-Type': 'application/json',
        'botnoi-token': genAiToken
      };

      final taskPayload = {
        "genskript_id": workspaceId,
        "type_user": "starter",
        "delay_seconds": 2,
        "codec_video": videoCodec,
        "data": [
          {"image_url": imageUrl, "audio_url": audioUrl}
        ]
      };

      final taskResponse = await http.post(
        Uri.parse(
            "https://api-voice-staging.botnoi.ai/api/genai/audio-img-flow/tasks"),
        headers: taskHeaders,
        body: jsonEncode(taskPayload),
      );

      if (taskResponse.statusCode >= 200 && taskResponse.statusCode < 300) {
        final respData = jsonDecode(utf8.decode(taskResponse.bodyBytes));
        String? taskId = respData['data']?['task_id'] ?? respData['task_id'];

        if (taskId != null) {
          logger.i("🚀 Task Started: $taskId. Polling...");

          // Poll for result
          String? finalVideoUrl = await _pollTaskStatus(taskId, taskHeaders);

          if (finalVideoUrl != null) {
            // ---------------------------------------------------------
            // STEP 6: UPDATE WORKSPACE WITH VIDEO URL
            // ---------------------------------------------------------
            logger.d("Step 6: Saving Video URL to History...");
            await _saveWorkspaceToHistory(
              token: genAiToken, // ✅ PASS CORRECT TOKEN
              workspaceId: workspaceId,
              scriptText: scriptText,
              audioUrl: audioUrl,
              language: language,
              videoUrl: finalVideoUrl,
            );
            return finalVideoUrl;
          }
        }
      }
      return null;
    } catch (e) {
      logger.e("Video Creation Error", error: e);
      return null;
    }
  }
}
