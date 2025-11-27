// import 'dart:convert';
// import 'package:botnoivoice/config/api_url_config.dart';
// import 'package:botnoivoice/screen/main/home/function/get_default_speaker_id.dart';
// import 'package:botnoivoice/service/login/line_login.dart';
// import 'package:botnoivoice/service/token/apple_token.dart';
// import 'package:botnoivoice/service/token/email_token.dart';
// import 'package:botnoivoice/service/token/google_token.dart';
// import 'package:botnoivoice/service/token/line_token.dart';
// import 'package:botnoivoice/shared/dialog/notification/notification_dialog.dart';
// import 'package:botnoivoice/screen/main/home_speaker_data_management.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;

// /// For debugging
// final _logger = Logger();

// /// Generate audio from text
// Future<String> generateAudio(
//   BuildContext context,
//   String text,
//   String audioUrl,
//   bool isGenerateAudio,
//   {required bool isV2}
// ) async {
//   // Get Data from Home Speaker Data Management
//   String speakerId = context.read<HomeSpeakerDataManagement>().speakerId ?? getDefaultSpeakerId(context);
//   String language = context.read<HomeSpeakerDataManagement>().language ?? 'th';
//   String? appleCredentialsToken = context.read<AppleToken>().getCredentialsToken;
//   String? googleCredentialsToken = context.read<GoogleToken>().getCredentialsToken;
//   String? lineCredentialsToken = context.read<LineToken>().getCredentialsToken;
//   String? emailCredentialsToken = context.read<EmailToken>().getCredentialsToken;

//   _logger.i("speakerId: $speakerId");
//   _logger.i("language: $language");
//   _logger.i("Apple-credentialsToken: $appleCredentialsToken");
//   _logger.i("Google-credentialsToken: $googleCredentialsToken");
//   _logger.i("LINE-credentialsToken: $lineCredentialsToken");
//   _logger.i("Email-credentialsToken: $emailCredentialsToken");

//   // เลือก URL ตาม isV2
//   String url = isV2
//       ? "$apiUrl/openapi/v1/generate_audio_v2"
//       : "$apiUrl/openapi/v1/generate_audio";

//   Map<String, dynamic> payload = {
//     "text": text,
//     "speaker": speakerId,
//     "volume": 1,
//     "speed": 1,
//     "type_media": "mp3",
//     "save_file": "true",
//     "language": language,
//     /// Note: None Free Daily Quota.
//     "page": "mobilebotnoivoice",
//   };

//   // Determine which token to use in the headers
//   String? selectedToken;
//   if (context.read<LineLogin>().isLoggedIn) {
//     selectedToken = lineCredentialsToken;
//   } else if (appleCredentialsToken != null &&
//       appleCredentialsToken.isNotEmpty) {
//     selectedToken = appleCredentialsToken;
//   } else if (googleCredentialsToken != null &&
//       googleCredentialsToken.isNotEmpty) {
//     selectedToken = googleCredentialsToken;
//   } else if (emailCredentialsToken != null &&
//       emailCredentialsToken.isNotEmpty) {
//     selectedToken = emailCredentialsToken;
//   } else {
//     selectedToken = ''; // Default or fallback if no token is found
//   }

//   Map<String, String> headers = {
//     'Botnoi-Token': selectedToken ?? '',
//     'Content-Type': 'application/json'
//   };

//   try {
//     _logger.i("POST $url");
//     final response = await http.post(
//       Uri.parse(url),
//       headers: headers,
//       body: jsonEncode(payload),
//     );

//     if (response.statusCode == 200) {
//       final jsonData = jsonDecode(response.body);
//       // Set Audio URL from response
//       audioUrl = jsonData['audio_url'];
//       _logger.i("generateAudio -> $audioUrl");
//     } else {
//       isGenerateAudio = false;
//       // Set Audio URL to empty string when failed to generate audio
//       audioUrl = '';
//       _logger.e("Failed to generate audio: ${response.statusCode}");

//       if (context.mounted) {
//         String errorMessage;

//         if (response.statusCode == 403) {
//           // Custom message for 403
//           errorMessage = 'home_screen.forbidden_language_mismatch'.tr();
//         } else {
//           errorMessage = 'home_screen.unable_to_create_sound'.tr();
//         }

//         NotificationDialog(
//           context: context,
//           text: errorMessage,
//         ).showErrorModal(context);
//       }
//     }
//   } catch (e) {
//     _logger.e("Error on generateAudio: $e");
//   }
//   return audioUrl;
// }

import 'dart:convert';
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/screen/main/home/function/get_default_speaker_id.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:botnoivoice/shared/dialog/notification/notification_dialog.dart';
import 'package:botnoivoice/screen/main/home_speaker_data_management.dart';
import 'package:botnoivoice/shared/dialog/notification/notification_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

/// For debugging
final _logger = Logger();

/// Generate audio from text
Future<String> generateAudio({
  required WidgetRef ref,
  required String text,
  required String audioUrl,
  required bool isGenerateAudio,
  required bool isV2,
}) async {
  // Get Data from Home Speaker Data Management
  final homeSpeakerProvider = ref.read(homeSpeakerDataProvider.notifier);
  String speakerId = homeSpeakerProvider.speakerId ?? getDefaultSpeakerId(ref.context);
  String language = homeSpeakerProvider.language ?? Localizations.localeOf(ref.context).languageCode;

  final selectedToken =
      ref.watch(currentUserTokenStateProvider).credentialsToken;

  if (selectedToken == null || selectedToken.isEmpty) {
    // Show Snackbar
    NotificationSnackBar(
            context: ref.context,
            text: "User CredentialsToken is null or empty",
            color: Colors.red)
        .showSnackBar();
  }

  _logger.i("speakerId: $speakerId");
  _logger.i("language: $language");
  _logger.i("User CredentialsToken: $selectedToken");
  _logger.i("Text: $text");
  _logger.i("Audio URL: $audioUrl");
  _logger.i("isGenerateAudio: $isGenerateAudio");
  _logger.i("isV2: $isV2");

  // เลือก URL ตาม isV2
  String url = isV2
      ? "$apiUrl/openapi/v1/generate_audio_v2"
      : "$apiUrl/openapi/v1/generate_audio";

  Map<String, dynamic> payload = {
    "text": text,
    "speaker": speakerId,
    "volume": 1,
    "speed": 1,
    "type_media": "mp3",
    "save_file": "true",
    "language": language,
    "page": "mobilebotnoivoice", // Note: None Free Daily Quota.
  };

  Map<String, String> headers = {
    'Botnoi-Token': selectedToken ?? '',
    'Content-Type': 'application/json'
  };

  try {
    _logger.i("POST $url");
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      // Set Audio URL from response
      audioUrl = jsonData['audio_url'];
      _logger.i("generateAudio -> $audioUrl");
    } else {
      isGenerateAudio = false;
      // Set Audio URL to empty string when failed to generate audio
      audioUrl = '';
      _logger.e("Failed to generate audio: ${response.statusCode}");

      if (ref.context.mounted) {
        String errorMessage;

        if (response.statusCode == 403) {
          // Custom message for 403
          errorMessage = 'home_screen.forbidden_language_mismatch'.tr();
        } else {
          errorMessage = 'home_screen.unable_to_create_sound'.tr();
        }

        NotificationDialog(
          context: ref.context,
          text: errorMessage,
        ).showErrorModal(ref.context);
      }
    }
  } catch (e) {
    _logger.e("Error on generateAudio: $e");
  }
  return audioUrl;
}
