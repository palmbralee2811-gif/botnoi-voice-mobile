// import 'dart:convert';
// import 'package:botnoivoice/config/api_url_config.dart';
// import 'package:botnoivoice/service/login/line_login.dart';
// import 'package:botnoivoice/service/token/apple_token.dart';
// import 'package:botnoivoice/service/token/email_token.dart';
// import 'package:botnoivoice/service/token/google_token.dart';
// import 'package:botnoivoice/service/token/line_token.dart';
// import 'package:botnoivoice/shared/dialog/notification/notification_popup.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;

// /// For debugging
// final _logger = Logger();

// /// Generate audio (เวอร์ชันใหม่ – อย่าชนชื่อกับของเดิม)
// Future<String> generateAudioPreview(
//   BuildContext context,
//   String text,
//   String audioUrl,
//   bool isGenerateAudio, {
//   required bool isV2,
// }) async {
//   // ถ้าต้องการ fix ค่า speaker = "1" และ language = "th"
//   // ตามที่พี่เขาแนะนำ (ไม่ไปยุ่งกับ logic ของไฟล์เดิม)
//   // สามารถเขียนแบบนี้ได้เลย

//   // NOTE: ถ้าไม่อยากใช้ค่าจาก HomeSpeakerDataManagement เลย ให้คอมเมนต์ออก
//   // String speakerId =
//   //     context.read<HomeSpeakerDataManagement>().speakerId ?? getDefaultSpeakerId(context);
//   // String language =
//   //     context.read<HomeSpeakerDataManagement>().language ?? 'th';

//   String speakerId = "1"; // fix speaker
//   String language = "th"; // fix language

//   String? appleCredentialsToken = context.read<AppleToken>().getCredentialsToken;
//   String? googleCredentialsToken = context.read<GoogleToken>().getCredentialsToken;
//   String? lineCredentialsToken = context.read<LineToken>().getCredentialsToken;
//   String? emailCredentialsToken = context.read<EmailToken>().getCredentialsToken;

//   _logger.i("Preview speakerId: $speakerId");
//   _logger.i("Preview language: $language");
//   _logger.i("Apple-credentialsToken: $appleCredentialsToken");
//   _logger.i("Google-credentialsToken: $googleCredentialsToken");
//   _logger.i("LINE-credentialsToken: $lineCredentialsToken");
//   _logger.i("Email-credentialsToken: $emailCredentialsToken");

//   String url = isV2
//       ? "$apiUrl/openapi/v1/generate_audio_v2"
//       : "$apiUrl/openapi/v1/generate_audio";

//   Map<String, dynamic> payload = {
//     "text": text,
//     "speaker": speakerId, // ใช้ค่า fix "1"
//     "volume": 1,
//     "speed": 1,
//     "type_media": "mp3",
//     "save_file": "true",
//     "language": language, // ใช้ค่า fix "th"
//     "page": "mobilebotnoivoice",
//   };

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
//     selectedToken = '';
//   }

//   Map<String, String> headers = {
//     'Botnoi-Token': selectedToken ?? '',
//     'Content-Type': 'application/json'
//   };

//   try {
//     _logger.i("POST (preview) $url");
//     final response = await http.post(
//       Uri.parse(url),
//       headers: headers,
//       body: jsonEncode(payload),
//     );

//     if (response.statusCode == 200) {
//       final jsonData = jsonDecode(response.body);
//       audioUrl = jsonData['audio_url'];
//       _logger.i("generateAudioPreview -> $audioUrl");
//     } else {
//       isGenerateAudio = false;
//       audioUrl = '';
//       _logger.e("Failed to generate preview audio: ${response.statusCode}");

//       if (context.mounted) {
//         NotificationPopup(
//           context: context,
//           text: 'home_screen.unable_to_create_sound'.tr(),
//         ).showAsError();
//       }
//     }
//   } catch (e) {
//     _logger.e("Error on generateAudioPreview: $e");
//   }

//   return audioUrl;
// }

import 'dart:convert';
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:botnoivoice/shared/dialog/notification/notification_popup.dart';
import 'package:botnoivoice/shared/dialog/notification/notification_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

/// For debugging
final _logger = Logger();

/// Generate audio (เวอร์ชันใหม่ – อย่าชนชื่อกับของเดิม)
Future<String> generateAudioPreview(
  WidgetRef ref,
  String text,
  String audioUrl,
  bool isGenerateAudio, {
  required bool isV2,
}) async {
  // ถ้าต้องการ fix ค่า speaker = "1" และ language = "th"
  // ตามที่พี่เขาแนะนำ (ไม่ไปยุ่งกับ logic ของไฟล์เดิม)
  // สามารถเขียนแบบนี้ได้เลย

  // NOTE: ถ้าไม่อยากใช้ค่าจาก HomeSpeakerDataManagement เลย ให้คอมเมนต์ออก
  // String speakerId =
  //     context.read<HomeSpeakerDataManagement>().speakerId ?? getDefaultSpeakerId(context);
  // String language =
  //     context.read<HomeSpeakerDataManagement>().language ?? 'th';

  String speakerId = "1"; // fix speaker
  String language = "th"; // fix language

  final selectedToken =
      ref.watch(currentUserTokenStateProvider).credentialsToken;

  if (selectedToken == null || selectedToken.isEmpty) {
    // Show Snackbar
    NotificationSnackBar(
      context: ref.context,
      text: "User CredentialsToken is null or empty",
      color: Colors.red
    ).showSnackBar();
  }

  _logger.i("Preview speakerId: $speakerId");
  _logger.i("Preview language: $language");
  _logger.i("User CredentialsToken: $selectedToken");

  String url = isV2
      ? "$apiUrl/openapi/v1/generate_audio_v2"
      : "$apiUrl/openapi/v1/generate_audio";

  Map<String, dynamic> payload = {
    "text": text,
    "speaker": speakerId, // ใช้ค่า fix "1"
    "volume": 1,
    "speed": 1,
    "type_media": "mp3",
    "save_file": "true",
    "language": language, // ใช้ค่า fix "th"
    "page": "mobilebotnoivoice",
  };

  Map<String, String> headers = {
    'Botnoi-Token': selectedToken ?? '',
    'Content-Type': 'application/json'
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
      isGenerateAudio = false;
      audioUrl = '';
      _logger.e("Failed to generate preview audio: ${response.statusCode}");

      if (ref.context.mounted) {
        NotificationPopup(
          context: ref.context,
          text: 'home_screen.unable_to_create_sound'.tr(),
        ).showAsError();
      }
    }
  } catch (e) {
    _logger.e("Error on generateAudioPreview: $e");
  }

  return audioUrl;
}
