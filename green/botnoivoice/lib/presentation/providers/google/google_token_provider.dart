import 'dart:convert';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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
        } else {
          debugPrint('getIdTokenWithFirebase -> Token not found: $message');
        }
      } else {
        debugPrint(
            'getIdTokenWithFirebase -> Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('getIdTokenWithFirebase -> Error: $e');
    }
  }

  /// Get the remaining credits using jwtToken
  Future<void> loadRemainingCredits() async {
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
      } else {
        debugPrint(
            "getRemainingCredits -> Failed to retrieve data: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint('getRemainingCredits -> Error: $e');
    }
  }

  // Get the credentials token using jwtToken
  Future<void> loadCredentials() async {
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
      } else {
        debugPrint('Failed to load Credentials-Token: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching Credentials-Token: $e');
    }
  }

  /// Generate audio from text and return the audio URL
  Future<String?> generateAudio(
    String text,
    String speakerId,
    int volume,
    int speed,
  ) async {
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
        debugPrint('Json data = $jsonData');
        return jsonData['audio_url'];
      } else {
        debugPrint(
            'generateAudio -> Failed to post data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('generateAudio -> Error: $e');
      return null;
    }
  }
}
