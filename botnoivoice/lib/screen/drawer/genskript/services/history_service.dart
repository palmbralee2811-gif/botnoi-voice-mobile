import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../data/api_constants.dart';

var logger = Logger();

class HistoryService {
  // Base URL (Using Staging based on your previous video success)
  static const String _baseUrl = "https://api-voice-staging.botnoi.ai/api";

  // 1. GET Workspaces (Fetch History)
  static Future<List<dynamic>> fetchHistory() async {
    if (ApiConstants.Token.isEmpty) return [];

    final Map<String, String> headers = Map<String, String>.from(ApiConstants.generateHeaders);
    headers['botnoi-token'] = ApiConstants.Token; 

    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/genai/genskript-workspaces"), 
        headers: headers,
      );

      logger.d("History GET Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        
        // Handle both list directly or { data: [...] } structure
        if (decoded is List) {
          return decoded;
        } else if (decoded is Map && decoded['data'] is List) {
          return decoded['data'];
        }
        return [];
      } else {
        logger.e("Failed to fetch history: ${response.body}");
        return [];
      }
    } catch (e) {
      logger.e("History Service Error", error: e);
      return [];
    }
  }

  // 2. DELETE Workspace
  static Future<bool> deleteWorkspace(String workspaceId) async {
    final Map<String, String> headers = Map<String, String>.from(ApiConstants.generateHeaders);
    headers['botnoi-token'] = ApiConstants.Token; 

    try {
      final response = await http.delete(
        Uri.parse("$_baseUrl/genai/genskript-workspaces/$workspaceId"), 
        headers: headers,
      );

      logger.d("Delete Status: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        logger.e("Delete Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      logger.e("Delete Error", error: e);
      return false;
    }
  }

  // 3. UPDATE Workspace (PUT) - Helper for saving changes if needed
  static Future<bool> updateWorkspace(String workspaceId, Map<String, dynamic> payload) async {
    final Map<String, String> headers = Map<String, String>.from(ApiConstants.generateHeaders);
    headers['botnoi-token'] = ApiConstants.Token;
    headers['Content-Type'] = 'application/json';

    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/genai/genskript-workspaces/$workspaceId"), 
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        logger.e("Update Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      logger.e("Update Error", error: e);
      return false;
    }
  }
}