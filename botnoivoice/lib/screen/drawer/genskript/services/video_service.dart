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

  static Future<void> _saveWorkspaceToHistory({
    required String token,
    required String workspaceId,
    required String scriptText,
    required String audioUrl,
    required String language,
    String? videoUrl,
    bool isProcessingVideo = false,
  }) async {
    final String scriptId = "${workspaceId}_script_1";

    final Map<String, dynamic> payload = {
      "genskript_id": workspaceId,
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

    //  ฝังสถานะเพื่อเอาไปโชว์ในหน้า History
    if (isProcessingVideo) {
      payload['video_status'] = 'processing';
    } else if (videoUrl != null) {
      payload['video_status'] = 'completed';
    }

    try {
      //  เช็คว่าถ้ายังไม่มีวิดีโอ (เพิ่งเริ่มสร้าง) ให้ยิง POST เพื่อ Create แต่ถ้ามีวิดีโอแล้วให้ยิง PUT เพื่อ Update
      final bool isUpdate = videoUrl != null;
      final String url = isUpdate
          ? "https://api-voice.botnoi.ai/api/genai/genskript-workspaces/$workspaceId"
          : "https://api-voice.botnoi.ai/api/genai/genskript-workspaces";

      final request = isUpdate
          ? http.put(Uri.parse(url),
              headers: {
                'Content-Type': 'application/json; charset=utf-8',
                'Authorization': 'Bearer $token'
              },
              body: jsonEncode(payload))
          : http.post(Uri.parse(url),
              headers: {
                'Content-Type': 'application/json; charset=utf-8',
                'Authorization': 'Bearer $token'
              },
              body: jsonEncode(payload));

      final response = await request;

      if (response.statusCode >= 200 && response.statusCode < 300) {
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
        "https://api-voice.botnoi.ai/api/genai/document-flow/tasks/$taskId";
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
      String token = ApiConstants.Token;

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
        Uri.parse(ApiConstants.genskriptUrl),
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
      logger.d("Step 3: Deducting Points...");
      await http.put(
          Uri.parse("https://api-voice.botnoi.ai/api/payment/v2/deduct_point"),
          headers: standardHeaders,
          body: jsonEncode({
            "platform": "genskript",
            "Credits": audioPoints + videoPoints, // หักรวมไปเลยทีเดียว
            "Monthly_point": 0
          }));
      // ---------------------------------------------------------
      // STEP 4: SAVE WORKSPACE (Now using correct token)
      // ---------------------------------------------------------
      logger.d("Step 4: Saving Initial Workspace...");
      await _saveWorkspaceToHistory(
        token: token,
        workspaceId: workspaceId,
        scriptText: scriptText,
        audioUrl: audioUrl,
        language: language,
        videoUrl: null,
        isProcessingVideo: true,
      );

      // ---------------------------------------------------------
      // STEP 5: CREATE VIDEO TASK
      // ---------------------------------------------------------
      logger.d("Step 5: Creating Video Task...");

      final Map<String, String> taskHeaders = {
        'Content-Type': 'application/json',
        'botnoi-token': ApiConstants.botnoiVideoToken,
      };

      final taskPayload = {
        "genskript_id": workspaceId,
        "type_user": "starter",
        "data": [
          {"image_url": imageUrl, "audio_url": audioUrl}
        ]
      };

      logger.d("🚀 Step 5 Sending Headers: $taskHeaders");
      logger.d("🚀 Step 5 Sending Payload: $taskPayload");

      final taskResponse = await http.post(
        Uri.parse("https://api-voice.botnoi.ai/api/genai/audio-img-flow/tasks"),
        headers: taskHeaders,
        body: jsonEncode(taskPayload),
      );

      if (taskResponse.statusCode >= 200 && taskResponse.statusCode < 300) {
        final respData = jsonDecode(utf8.decode(taskResponse.bodyBytes));

        String? taskId;
        if (respData['data'] is Map) {
          taskId = respData['data']['task_id'];
        }
        taskId ??= respData['task_id'];

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
              token: token,
              workspaceId: workspaceId,
              scriptText: scriptText,
              audioUrl: audioUrl,
              language: language,
              videoUrl: finalVideoUrl,
              isProcessingVideo: false,
            );
            return finalVideoUrl;
          }
        }
      } else {
        // โชว์ Log หาก API ของ Step 5 ไม่ยอมรับ Request จะได้รู้สาเหตุ
        logger.e(
            "❌ Step 5 API Failed: Status ${taskResponse.statusCode} - ${taskResponse.body}");
      }
      return null;
    } catch (e) {
      logger.e("Video Creation Error", error: e);
      return null;
    }
  }
}
