import 'dart:convert';
import 'dart:math';
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
  Future<void> loadJwtToken(BuildContext context) async {
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

  /// Load all workspaces of this user
  Future<void> loadAllWorkspace() async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };
    try {
      String url = "api-voice.botnoi.ai";
      String path = "/api/workspace/get_all_workspace";
      final response = await http.get(Uri.https(url, path), headers: headers);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        allWorkspaces =
            (responseData['data']['list_project'] as List<Map<String, dynamic>>)
                .map((e) => WorkspaceModel.fromJson(e))
                .toList();
        notifyListeners();
      } else {
        debugPrint('Failed to fetch projects: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in getInfo: $e');
    }
  }

  /// Get the workspace details by workspaceId
  Future<void> loadWorkspaceDetails(String workspaceId) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };
    Map<String, String> params = {
      'workspace_id': workspaceId,
    };
    try {
      String url = "api-voice.botnoi.ai";
      String path = "/api/workspace/get_workspace";
      final response = await http.get(
          Uri.https(
            url,
            path,
            params,
          ),
          headers: headers);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        final textBoxList = (responseData['data']['text_list'] as List<dynamic>)
            .cast<Map<String, dynamic>>()
            .map((e) => TextBoxModel.fromJson(e))
            .toList();
        allWorkspaces
            .firstWhere((workspace) => workspace.workspaceId == workspaceId)
            .textBoxes = textBoxList;
        notifyListeners();
      } else {
        debugPrint('Failed to load workspace details: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in getWorkspaceById: $e');
    }
  }

  /// Add a new text box to a workspace
  Future<void> createTextBox({
    required String workspaceId,
    required TextBoxModel textBox,
  }) async {
    allWorkspaces
        .firstWhere((workspace) => workspace.workspaceId == workspaceId)
        .textBoxes
        .add(textBox);
    allWorkspaces
            .firstWhere((workspace) => workspace.workspaceId == workspaceId)
            .speakerList =
        allWorkspaces
            .firstWhere((workspace) => workspace.workspaceId == workspaceId)
            .textBoxes
            .map((textBox) => textBox.speaker)
            .toList();

    await _updateWorkSpace(
      workspaceId,
      allWorkspaces
          .firstWhere((workspace) => workspace.workspaceId == workspaceId)
          .textBoxes,
    );
    notifyListeners();
  }

  /// Change the text of a text box in a workspace
  Future<void> updateTextBox({
    required String workspaceId,
    required int textBoxIndex,
    required TextBoxModel updatedTextBox,
  }) async {
    allWorkspaces
        .firstWhere((workspace) => workspace.workspaceId == workspaceId)
        .textBoxes[textBoxIndex] = updatedTextBox;
    allWorkspaces
            .firstWhere((workspace) => workspace.workspaceId == workspaceId)
            .speakerList =
        allWorkspaces
            .firstWhere((workspace) => workspace.workspaceId == workspaceId)
            .textBoxes
            .map((textBox) => textBox.speaker)
            .toList();
    await _updateWorkSpace(
      workspaceId,
      allWorkspaces
          .firstWhere((workspace) => workspace.workspaceId == workspaceId)
          .textBoxes,
    );
    notifyListeners();
  }

  /// Delete a text box from a workspace
  Future<void> deleteTextBox({
    required String workspaceId,
    required int textBoxIndex,
  }) async {
    allWorkspaces
        .firstWhere((workspace) => workspace.workspaceId == workspaceId)
        .textBoxes
        .removeAt(textBoxIndex);
    allWorkspaces
            .firstWhere((workspace) => workspace.workspaceId == workspaceId)
            .speakerList =
        allWorkspaces
            .firstWhere((workspace) => workspace.workspaceId == workspaceId)
            .textBoxes
            .map((textBox) => textBox.speaker)
            .toList();
    await _updateWorkSpace(
      workspaceId,
      allWorkspaces
          .firstWhere((workspace) => workspace.workspaceId == workspaceId)
          .textBoxes,
    );
    notifyListeners();
  }

  /// Create a new workspace
  Future<String?> createWorkspace({
    required String name,
  }) async {
    final String workspaceId = _randomString(5);
    WorkspaceModel workspace = WorkspaceModel(
      name: "New Workspace",
      workspaceId: workspaceId,
      picture: "",
      textBoxes: [],
      recentUse: "",
      typeWorkspace: "conversation",
      speakerList: [],
    );
    allWorkspaces.add(workspace);
    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json'
    };
    try {
      // Construct the request body
      Map<String, dynamic> requestBody = {
        "workspace_id": workspace.workspaceId,
        "workspace": workspace.name,
        "type_workspace": workspace.typeWorkspace,
      };

      // Make the request
      String url = "api-voice.botnoi.ai";
      String path = "/api/workspace/insert_workspace";
      final response = await http.post(
        Uri.https(url, path),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      // Check if the request was successful
      if (response.statusCode != 200) {
        debugPrint(
            "createWorkspace -> Failed to post data: ${response.statusCode}");
        return null;
      }
      return workspaceId;
    } catch (e) {
      debugPrint("createWorkspace -> Error: $e");
      return null;
    }
  }

  /// Update the workspace with new textboxes
  Future<void> _updateWorkSpace(
    String workspaceId,
    List<TextBoxModel> textBoxes,
  ) async {
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
      String url = "api-voice.botnoi.ai";
      String path = "/api/workspace/workspace_text_save";
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

  /// Generate a random string
  String _randomString(int length) {
    const characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => characters.codeUnitAt(
          random.nextInt(characters.length),
        ),
      ),
    );
  }
}
