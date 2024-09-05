import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class TokenManager extends ChangeNotifier {
  String? credits;
  String? jwtToken;
  String? credentialsToken;
  final _storage = const FlutterSecureStorage();

  Future<void> loadAuthStatus() async {
    debugPrint('Loading auth status...');
    await Future.wait([
      _loadJwtToken(),
      _loadCredentialsToken(),
    ]);
    debugPrint(
        'Auth status loaded: jwtToken=$jwtToken, credentialsToken=$credentialsToken');
  }

  Future<void> _loadJwtToken() async {
    jwtToken = await _storage.read(key: 'jwtToken');
    debugPrint('JWT Token loaded: $jwtToken');
    notifyListeners();
  }

  Future<void> _saveJwtToken(String token) async {
    await _storage.write(key: 'jwtToken', value: token);
    jwtToken = token;
    debugPrint('JWT Token saved: $jwtToken');
    notifyListeners();
  }

  Future<void> _loadCredentialsToken() async {
    credentialsToken = await _storage.read(key: 'credentialsToken');
    debugPrint('Credentials token loaded: $credentialsToken');
    notifyListeners();
  }

  Future<void> _saveCredentialsToken(String token) async {
    await _storage.write(key: 'credentialsToken', value: token);
    credentialsToken = token;
    debugPrint('Credentials token saved: $credentialsToken');
  }

  Future<String?> getIdTokenWithFirebase(String? idToken) async {
    if (idToken == null) {
      debugPrint('No idToken provided');
      return null;
    }
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
        if (tokenIndex != -1) {
          var tokenStartIndex = tokenIndex + 'token='.length;
          jwtToken = message.substring(tokenStartIndex);
          debugPrint('Received JWT Token: $jwtToken');
          await _saveJwtToken(jwtToken!);
          return jwtToken;
        }
      }
      debugPrint(
          'Error fetching token from Firebase, status code: ${response.statusCode}');
    } catch (e) {
      debugPrint('Error in getIdTokenWithFirebase: $e');
    }
    return null;
  }

  Future<String?> getProfileWithToken(String? jwtToken) async {
    if (jwtToken == null) {
      debugPrint('No JWT token provided for profile fetch');
      return null;
    }
    String url = 'https://api-voice.botnoi.ai/api/dashboard/get_profile';
    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json'
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        credits = data['data']['credits'].toString();
        debugPrint('Profile credits fetched: $credits');
        notifyListeners();
        return credits;
      }
      debugPrint(
          'Error fetching profile, status code: ${response.statusCode}, body: ${response.body}');
    } catch (e) {
      debugPrint('Error in getProfileWithToken: $e');
    }
    return null;
  }

  Future<String?> getCredentialsToken(String? jwtToken) async {
    if (jwtToken == null) {
      debugPrint('No JWT token provided for credentials token fetch');
      return null;
    }
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
        debugPrint('Credentials token fetched: $credentialsToken');
        await _saveCredentialsToken(credentialsToken!);
        return credentialsToken;
      }
      debugPrint(
          'Error fetching credentials token, status code: ${response.statusCode}');
    } catch (e) {
      debugPrint('Error in getCredentialsToken: $e');
    }
    return null;
  }
}
