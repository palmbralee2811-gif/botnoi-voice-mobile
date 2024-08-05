import 'dart:convert';
import 'package:botnoi_voice_mobile/Authentication/authentication_provider.dart';
import 'package:botnoi_voice_mobile/MainServer/ObjectModels/text_box_model.dart';
import 'package:botnoi_voice_mobile/MainServer/ObjectModels/workspace_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

/// Provider and interface to the main server
class MainServerProvider extends ChangeNotifier {
  String? jwtToken;
  String? remainingCredits;
  String? credentialsToken;
  List<WorkspaceModel> allWorkspaces = [];

  /// Get the jwtToken from Firebase
  Future<void> getJwtToken(BuildContext context) async {
    // Get the idToken from the Authentication provider
    String? idToken =
        Provider.of<Authentication>(context, listen: false).idToken;
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
  Future<void> getRemainingCredits() async {
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
  Future<void> getCredentials() async {
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

  /// Load all workspaces of this user
  Future<void> getAllWorkspace() async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };
    try {
      String url = 'api-voice.botnoi.ai/api/workspace/get_all_workspace';
      final response = await http.get(Uri.https(url), headers: headers);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        final data = responseData['data'] as Map<String, dynamic>;
        // Set the workspaces
        allWorkspaces = (data['list_project'] as List)
            .map((e) => WorkspaceModel.fromJson(e))
            .toList();

        // Get the details of each workspace
        for (WorkspaceModel workspace in allWorkspaces) {
          await getWorkspaceDetails(workspace.workspaceId);
        }
      } else {
        debugPrint('Failed to fetch projects: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in getInfo: $e');
    }
  }

  /// Get the workspace details by workspaceId
  Future<void> getWorkspaceDetails(String workspaceId) async {
    String path = '/api/workspace/get_workspace';
    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };
    Map<String, String> params = {
      'workspace_id': workspaceId,
    };
    try {
      String url = 'api-voice.botnoi.ai';
      final response =
          await http.get(Uri.https(url, path, params), headers: headers);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        final data = responseData['data'];
        final textBoxList = (data['text_list'] as List<dynamic>)
            .cast<Map<String, dynamic>>()
            .map((e) => TextBoxModel.fromJson(e))
            .toList();

        for (var workspace in allWorkspaces) {
          if (workspace.workspaceId == workspaceId) {
            workspace.textBoxes = textBoxList;
          }
        }
        notifyListeners();
      } else {
        debugPrint('Failed to load workspace details: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in getWorkspaceById: $e');
    }
  }

  /// Change the text of a text box in a workspace
  Future<void> updateTextBox({
    required int workspaceIndex,
    required int textBoxIndex,
    required String newText,
  }) async {
    allWorkspaces[workspaceIndex].textBoxes[textBoxIndex].text = newText;
    await _updateWorkSpace(
      allWorkspaces[workspaceIndex].workspaceId,
      allWorkspaces[workspaceIndex].textBoxes,
    );
    notifyListeners();
  }

  /// Delete a text box from a workspace
  Future<void> deleteTextBox({
    required int workspaceIndex,
    required int textBoxIndex,
  }) async {
    allWorkspaces[workspaceIndex].textBoxes.removeAt(textBoxIndex);
    await _updateWorkSpace(
      allWorkspaces[workspaceIndex].workspaceId,
      allWorkspaces[workspaceIndex].textBoxes,
    );
    notifyListeners();
  }

  /// Update the workspace with new textboxes
  Future<void> _updateWorkSpace(
    String workspaceId,
    List<TextBoxModel> textBoxes,
  ) async {
    String path = '/api/workspace/workspace_text_save';
    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json'
    };
    try {
      // Construct the request body
      Map<String, dynamic> requestBody = {
        'workspace_id': workspaceId,
        'text_list': textBoxes
            .map((textBox) => {
                  'text': textBox.text,
                  'speaker': textBox.speaker,
                  'audio_id': textBox.audioId,
                  'speed': textBox.speed,
                  'status_download': textBox.statusDownload,
                  'url': textBox.url,
                  'volume': textBox.volume,
                })
            .toList(),
      };

      // Make the request
      String url = 'api-voice.botnoi.ai';
      final response = await http.post(
        Uri.https(url, path),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      // Check if the request was successful
      if (response.statusCode != 200) {
        debugPrint(
            'updateWorkSpace -> Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('updateWorkSpace -> Error: $e');
    }
  }

  /// Generate audio from text and return the audio URL
  Future<String?> generateAudio(String text, int speaker) async {
    String url = "https://api-voice.botnoi.ai/openapi/v1/generate_audio";
    Map<String, dynamic> payload = {
      "text": text,
      "speaker": speaker,
      "volume": 1,
      "speed": 1,
      "type_media": "wav",
      "save_file": true,
    };
    Map<String, String> headers = {
      'Botnoi-Token': '$credentialsToken',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.post(
        Uri.parse(url),
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

  //final _storage = const FlutterSecureStorage();
  //Future<void> loadAuthStatus() async {
  //  await Future.wait([
  //    loadJwtToken(),
  //    loadCredentialsToken(),
  //  ]);
  //}
  //
  //Future<void> loadJwtToken() async {
  //  jwtToken = await _storage.read(key: 'jwtToken');
  //  notifyListeners();
  //}
  //
  //Future<void> saveJwtToken(String token) async {
  //  await _storage.write(key: 'jwtToken', value: token);
  //}
  //
  //Future<void> deleteJwtToken() async {
  //  await _storage.delete(key: "jwtToken");
  //}
  //
  //Future<void> loadCredentialsToken() async {
  //  credentialsToken = await _storage.read(key: 'credentialsToken');
  //  notifyListeners();
  //}
  //
  //Future<void> saveCredentialsToken(String token) async {
  //  await _storage.write(key: 'credentialsToken', value: credentialsToken);
  //}
  //
  //Future<void> deleteCredentialsToken() async {
  //  await _storage.delete(key: "credentialsToken");
  //}
}
