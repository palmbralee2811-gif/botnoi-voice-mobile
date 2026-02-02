import 'dart:convert';
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:botnoivoice/shared/dialog/notification/notification_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

/// For debugging
final _logger = Logger();

/// Generate audio (เวอร์ชันใหม่ – อย่าชนชื่อกับของเดิม)
Future<String> generateAudioPreview({
  required WidgetRef ref,
  required BuildContext context,
  required String text,
  required bool isV2,
  String? speakerId,
  String? language,
}) async {
  final String finalSpeakerId = speakerId ?? "1";
  final String finalLanguage = language ?? "th";

  final selectedToken =
      ref.read(currentUserTokenStateProvider).credentialsToken;

  if (selectedToken == null || selectedToken.isEmpty) {
    // Show Snackbar
    NotificationSnackBar(
      context: context,
      text: "User CredentialsToken is null or empty",
      color: Colors.red,
    ).showSnackBar();
    return "";
  }

  _logger.i("Preview speakerId: $speakerId");
  _logger.i("Preview language: $language");
  // _logger.i("User CredentialsToken: $selectedToken");
  _logger.i("User CredentialsToken: [HIDDEN]");

  String audioUrl = "";

  String url = isV2
      ? "$apiUrl/openapi/v1/generate_audio_v2"
      : "$apiUrl/openapi/v1/generate_audio";

  Map<String, dynamic> payload = {
    "text": text,
    "speaker": finalSpeakerId,
    "volume": 1,
    "speed": 1,
    "type_media": "mp3",
    "save_file": "true",
    "language": finalLanguage,
    "page": "mobilebotnoivoice",
  };

  Map<String, String> headers = {
    'Botnoi-Token': selectedToken,
    'Content-Type': 'application/json',
    'Referer': refererUrl,
  };

  try {
    _logger.i("POST (preview) $url");
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      audioUrl = jsonData['audio_url'];
      _logger.i("generateAudioPreview -> $audioUrl");
    } else {
      _logger.e("Failed to generate preview audio: ${response.statusCode}");

      // เพิ่มบรรทัดนี้เพื่อดูว่า Server ด่าว่าอะไร
      _logger.e("Server Response: ${response.body}");

      // แกะ Error message จาก Server
      String serverError = "Generate Failed (${response.statusCode})";
      try {
        final errJson = jsonDecode(utf8.decode(response.bodyBytes));
        if (errJson['message'] != null) serverError = errJson['message'];
      } catch (_) {}
      // Throw Exception เพื่อให้ UI (ResultScreen) จับได้และแสดง Dialog
      throw Exception(serverError);
    }
  } catch (e) {
    _logger.e("Error on generateAudioPreview: $e");
    // Rethrow เพื่อให้ UI รู้ว่าพังจริงๆ
    rethrow;
  }

  return audioUrl;
}
