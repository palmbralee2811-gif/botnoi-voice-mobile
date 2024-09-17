import 'dart:convert';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:botnoivoice/presentation/providers/logger/logger_provider.dart';

/// Provider and interface to the main server
class GoogleTokenProvider extends ChangeNotifier {
  String? jwtToken;
  String? remainingCredits;
  String? credentialsToken;

  /// Clear all the tokens
  void clearTokens() {
    jwtToken = null;
    remainingCredits = null;
    credentialsToken = null;
    notifyListeners();
  }

  /// Get the jwtToken from Firebase
  Future<void> loadJwtToken(BuildContext context) async {
    final logger = Provider.of<LoggerProvider>(context, listen: false).logger;

    // Get the idToken from the Authentication provider
    String? idToken =
        await Provider.of<GoogleLoginProvider>(context, listen: false)
            .user
            ?.getIdToken();
    if (idToken == null) return;

    // Get the jwtToken from the Firebase API
    String url = 'https://api-voice.botnoi.ai/api/dashboard/firebase_auth';
    
    Map<String, String> headers = {
      'Botnoi-Token': 'Bearer $idToken',
      'Content-Type': 'application/json'
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var message = data['message'];
        var tokenIndex = message.indexOf('token=');

        // Check if the token was found
        if (tokenIndex != -1) {
          var tokenStartIndex = tokenIndex + 'token='.length;
          jwtToken = message.substring(tokenStartIndex);
          notifyListeners();
          logger.i('JWT Token successfully loaded.');
        } else {
          logger.w('Token not found in response message: $message');
        }
      } else {
        logger.e('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error fetching JWT Token: $e');
    }
  }

  /// Get the remaining credits using jwtToken
  Future<void> loadRemainingCredits(BuildContext context) async {
    final logger = Provider.of<LoggerProvider>(context, listen: false).logger;

    // Check if jwtToken exists
    if (jwtToken == null) return;

    // Make the request
    String url = 'https://api-voice.botnoi.ai/api/dashboard/get_profile';
    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json'
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        remainingCredits = data['data']['credits'].toString();
        notifyListeners();
        logger.i('Remaining credits successfully loaded.');
      } else {
        logger.e("Failed to retrieve remaining credits: ${response.statusCode}");
      }
    } catch (e) {
      logger.e('Error fetching remaining credits: $e');
    }
  }

  // Get the credentials token using jwtToken
  Future<void> loadCredentials(BuildContext context) async {
    final logger = Provider.of<LoggerProvider>(context, listen: false).logger;

    // Check if jwtToken exists
    if (jwtToken == null) return;

    // Make the request
    String url = 'https://api-voice.botnoi.ai/api/service/get_token';
    Map<String, dynamic> payload = {};
    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json'
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        credentialsToken = data['data'][0]['token'].toString();
        notifyListeners();
        logger.i('Credentials token successfully loaded.');
      } else {
        logger.e('Failed to load Credentials-Token: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error fetching Credentials-Token: $e');
    }
  }

  /// Generate audio from text and return the audio URL
  Future<String?> generateAudio(
    BuildContext context,
    String text,
    String speakerId,
    int volume,
    int speed,
  ) async {
    final logger = Provider.of<LoggerProvider>(context, listen: false).logger;

    Map<String, dynamic> payload = {
      "text": text,
      "speaker": speakerId,
      "volume": volume,
      "speed": speed,
      "type_media": "wav",
      "save_file": true,
    };
    Map<String, String> headers = {
      'Botnoi-Token': '$credentialsToken',
      'Content-Type': 'application/json',
    };
    try {
      String url = "api-voice.botnoi.ai";
      String path = "/openapi/v1/generate_audio";
      final response = await http.post(
        Uri.https(url, path),
        headers: headers,
        body: jsonEncode(payload),
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        logger.i('Audio generated successfully: ${jsonData['audio_url']}');
        return jsonData['audio_url'];
      } else {
        logger.e('Failed to generate audio: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      logger.e('Error generating audio: $e');
      return null;
    }
  }
}
