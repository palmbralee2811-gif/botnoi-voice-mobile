import 'dart:convert';
import 'package:botnoi_voice_application/models/models.dart';
import 'package:http/http.dart' as http;

class Backend {
  String? jwtToken = 
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MjEwOTU0NDIsImlhdCI6MTcyMTAwOTA0MiwibmJmIjoxNzIxMDA5MDQyLCJ1aWQiOiIzOGI1NjUwMS05MGMyLTU3MzctODA4Ni0zMGM3OTRkOWY4ZjIiLCJ1c2VyX2lkIjoiSG9nbjlrdkpYY1hTOTVnRTdpbDZzaUtBbVkyMyJ9.9rUfP6JOaQm51GjL9J9deJNNpv0xQAahNQvyr10XUgY';
  List<ListProject> listProjects = [];
  List<Map<String, dynamic>> _textList = [];
  String url = 'api-voice.botnoi.ai';

  Future<void> getAllWorkspace() async {
    String path = '/api/workspace/get_all_workspace';
    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };
    try {
      print(Uri.https(url, path));
      final response = await http.get(Uri.https(url, path), headers: headers);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        final data = responseData['data'];
        if (data != null && data['list_project'] != null) {
          listProjects = (data['list_project'] as List)
              .map((e) => ListProject.fromJson(e))
              .toList();
          if (listProjects.isNotEmpty) {
            for (var project in listProjects) {
              await getWorkspaceById(project.workspaceId);
            }
          } else {
            print('No projects found.');
          }
        } else {
          print('No projects found.');
        }
      } else {
        print('Failed to fetch projects: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getInfo: $e');
    }
  }

  Future<void> getWorkspaceById(String workspaceId) async {
    String path = '/api/workspace/get_workspace';
    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };
    Map<String, String> params = {
      'workspace_id': workspaceId,
    };

    try {
      final response =
          await http.get(Uri.https(url, path, params), headers: headers);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        final data = responseData['data'];
        final textList = data['text_list'] as List<dynamic>;
        _textList = textList.cast<Map<String, dynamic>>();
      
        for (var project in listProjects) {
          if (project.workspaceId == workspaceId) {
            project.updateWorkSpaces(_textList);
          }
        }
        print('Workspace Details for $workspaceId: $_textList');
      } else {
        print('Failed to load workspace details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getWorkspaceById: $e');
    }
  }

  Future<void> updateWorkSpaces(String workspaceId, List<WorkSpace> workSpaces) async {
    String path = '/api/workspace/workspace_text_save';
    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json'
    };
    try {
      // Prepare the request body
      List<Map<String, dynamic>> textList = [];

      // Build textList from workSpaces
      for (var workSpace in workSpaces) {
        textList.add({
          'text': workSpace.text,
          'speaker': workSpace.speaker,
          'audio_id': workSpace.audioId,
          'speed': workSpace.speed,
          'status_download': workSpace.statusDownload,
          'url': workSpace.url,
          'volume': workSpace.volume,
        });
      }

      // Construct the request body
      Map<String, dynamic> requestBody = {
        'workspace_id': workspaceId,
        'text_list': textList,
      };

      // Convert the request body to JSON
      String requestBodyJson = jsonEncode(requestBody);

      // Make the POST request
      final response = await http.post(
        Uri.https(url, path),
        headers: headers,
        body: requestBodyJson,
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('Post successful');
      } else {
        print('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in updateWorkSpaces: $e');
    }
  }

  Future<String?> generateAudio (String text,int speaker) async {
    String genUrl =
        "https://api-voice.botnoi.ai/openapi/v1/generate_audio";
    Map<String, dynamic> payload = {
      "text": text,
      "speaker": speaker,
      "volume": 1,
      "speed": 1,
      "type_media": "wav",
      "save_file": true,
    };

    Map<String, String> headers = {
      'Botnoi-Token': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.post(
        Uri.parse(genUrl),
        headers: headers,
        body: jsonEncode(payload),
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData['audio_url'];
      } else {
        print('Failed to post data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error in _generateAudio: $e');
      return null;
    }
  }
  Future<List<Map<String, String>>> fetchImageUrl(List<int> speakerIds) async {
  String path = '/api/service/get_all_marketplace';
  Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
  };
    try {
      final response = await http.get(Uri.https(url, path), headers: headers);
      if (response.statusCode == 200) {
        print("connected");
        final data = json.decode(response.body);
        final speakers = data['response'] as List;
        List<Map<String, String>> speakerDetails = [];
        for (var speakerId in speakerIds) {
          for (var speaker in speakers) {
            if (speaker['speaker_id'] == speakerId.toString()) {
              speakerDetails.add({
              'face_image': speaker['face_image'],
              'eng_name': speaker['eng_name'], // assuming you want to use thai_name as eng_name
              });
              break;
              }
          }
        } 
        return speakerDetails;
      } else {
        print('Failed to post data: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error in fetchImageUrls: $e');
      return [];
    }
  }
}
