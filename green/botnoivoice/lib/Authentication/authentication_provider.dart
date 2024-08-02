import 'dart:convert';
import 'dart:io';
import 'package:botnoivoice/Function/randomString.dart';
import 'package:botnoivoice/Model/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';

class Authentication extends ChangeNotifier {
  User? user;
  String? credits;
  String? response;
  String? jwtToken;
  String? credentialsToken;

  List<ListProject> listProjects = [];
  List<Map<String, dynamic>> _textList = [];
  String url = 'api-voice.botnoi.ai';

  final _storage = const FlutterSecureStorage();

  bool get isAuthenticated {
    if (user == null && jwtToken == null && credentialsToken == null) {
      print("isAuthenticated -> NOT WORKING !!!");
    } else {
      print("isAuthenticated -> WORKING !!!");
    }
    return user != null && jwtToken != null && credentialsToken != null;
  }

  Authentication() {
    FirebaseAuth.instance.authStateChanges().listen((
      User? user,
    ) {
      this.user = user;
      notifyListeners();
    });
    _loadJwtToken();
    _loadCredentialsToken();
  }

  Future<void> loadAuthStatus() async {
    await Future.wait([
      _loadJwtToken(),
      _loadCredentialsToken(),
    ]);
  }

  Future<void> _loadJwtToken() async {
    jwtToken = await _storage.read(key: 'jwtToken');
    if (jwtToken == null) {
      print('Loaded JWT Token: NOT WORKING !!!');
    }
    notifyListeners();
  }

  Future<void> _saveJwtToken(String token) async {
    await _storage.write(key: 'jwtToken', value: token);
    if (token.isEmpty) {
      print('Saved JWT Token: NOT WORKING !!!');
    }
  }

  Future<void> _loadCredentialsToken() async {
    credentialsToken = await _storage.read(key: 'credentialsToken');
    if (credentialsToken == null) {
      print('Loaded Credential Token: NOT WORKING !!!');
    }
    notifyListeners();
  }

  Future<void> _saveCredentialsToken(String token) async {
    await _storage.write(key: 'credentialsToken', value: credentialsToken);
    if (credentialsToken == null) {
      print('Saved Credential Token: NOT WORKING !!!');
    }
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final idToken = await user.getIdToken();
        if (idToken != null) {
          await getIdTokenWithFirebase(idToken);
          if (jwtToken != null) {
            await _saveJwtToken(jwtToken!);
            credentialsToken = await getCredentialsToken(jwtToken);
            await _saveCredentialsToken(credentialsToken!);
            await getProfileWithToken(jwtToken);
            notifyListeners(); // แจ้งให้ UI ทราบว่าข้อมูลมีการเปลี่ยนแปลง
          } else {
            print("signInWithGoogle -> jwtToken: NOT WORKING !!!");
          }
        } else {
          print("signInWithGoogle -> idToken: NOT WORKING !!!");
        }
      }
      return user;
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      return null;
    }
  }

  String? getUserEmail(User? user) {
    if (user == null) {
      print('getUserEmail -> user: $user');
      return null;
    }

    // Iterate through providerData to find the email
    for (var userInfo in user.providerData) {
      if (userInfo.email != null) {
        return userInfo.email;
      }
    }
    return null;
  }

  Future<String?> getIdTokenWithFirebase(String? idToken) async {
    if (idToken == null) {
      print("getIdTokenWithFirebase -> NOT WORKING !!!");
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
          if (jwtToken == null) {
            print('getIdTokenWithFirebase -> jwtToken: NOT WORKING !!!');
          }
          notifyListeners(); // แจ้งให้ UI ทราบว่าข้อมูลมีการเปลี่ยนแปลง
          return jwtToken;
        } else {
          print('getIdTokenWithFirebase -> Token not found: $message');
        }
      } else {
        print(
            'getIdTokenWithFirebase -> Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('getIdTokenWithFirebase -> Error: $e');
    }
    return null;
  }

  Future<String?> getProfileWithToken(String? jwtToken) async {
    if (jwtToken == null) {
      print('getProfileWithToken -> jwtToken: NOT WORKING !!!');
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
        if (credits == null) {
          print('getProfileWithToken -> credits: NOT WORKING !!!');
        }
        notifyListeners(); // แจ้งให้ UI ทราบว่าข้อมูลมีการเปลี่ยนแปลง
        return credits;
      } else if (response.statusCode == 403) {
        print(
            "getProfileWithToken -> Something went wrong: ${response.statusCode}");
      } else if (response.statusCode == 404) {
        print(
            "getProfileWithToken- > Not enough credits: ${response.statusCode}");
      } else {
        signOut();
        print(
            "getProfileWithToken -> Failed to retrieve data: ${response.statusCode}");
      }
    } catch (e) {
      print('getProfileWithToken -> Error: $e');
    }
    return null;
  }

  Future<String?> getCredentialsToken(String? jwtToken) async {
    if (jwtToken == null) {
      print('getCredentialsToken -> NOT WORKING !!!');
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
        if (credentialsToken == null) {
          print('getCredentialsToken -> Credentials Token: NOT WORKING !!!');
        }
        notifyListeners(); // แจ้งให้ UI ทราบว่าข้อมูลมีการเปลี่ยนแปลง
        return credentialsToken;
      } else if (response.statusCode == 401) {
        signOut();
        print("getCredentialsToken -> signOut is DONE !!!");
        print(
            'getCredentialsToken -> Unauthorized Token: ${response.statusCode}');
        return null;
      } else {
        print('Failed to load Credentials-Token: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching Credentials-Token: $e');
      return null;
    }
  }

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
              print("printing projects ${project.workSpaces}");
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

  Future<void> updateWorkSpaces(
      String workspaceId, List<WorkSpace> workSpaces) async {
    String path = '/api/workspace/workspace_text_save';
    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json'
    };
    try {
      // Prepare the request body
      List<Map<String, dynamic>> textList = workSpaces
          .map((workSpace) => {
                'text': workSpace.text,
                'speaker': workSpace.speaker,
                'audio_id': workSpace.audioId,
                'speed': workSpace.speed,
                'status_download': workSpace.statusDownload,
                'url': workSpace.url,
                'volume': workSpace.volume,
              })
          .toList();

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
      print(response);
      // Check if the request was successful
      if (response.statusCode == 200) {
        print('updateWorkSpaces -> Post successful');
      } else {
        print(
            'updateWorkSpaces -> Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      print('updateWorkSpaces -> Error: $e');
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
        print("fetchImageUrl -> WORKING !!!");
        final data = json.decode(response.body);
        final speakers = data['response'] as List;
        List<Map<String, String>> speakerDetails = [];
        for (var speakerId in speakerIds) {
          for (var speaker in speakers) {
            if (speaker['speaker_id'] == speakerId.toString()) {
              speakerDetails.add({
                'face_image': speaker['face_image'],
                'eng_name': speaker[
                    'eng_name'], // assuming you want to use thai_name as eng_name
              });
              break;
            }
          }
        }
        return speakerDetails;
      } else {
        print('fetchImageUrl -> Failed to post data: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error in fetchImageUrls: $e');
      return [];
    }
  }

  Future<String?> generateAudio(String text, int speaker) async {
    String genUrl = "https://api-voice.botnoi.ai/openapi/v1/generate_audio";
    Map<String, dynamic> payload = {
      "text": text,
      "speaker": speaker,
      "volume": 1,
      "speed": 1,
      "type_media": "wav",
      "save_file": true,
    };
    print('JWT token at Generate $credentialsToken');
    Map<String, String> headers = {
      'Botnoi-Token': '$credentialsToken',
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
        print('Json data = $jsonData');
        return jsonData['audio_url'];
      } else {
        print('generateAudio -> Failed to post data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('generateAudio -> Error: $e');
      return null;
    }
  }

  Future<void> downloadFile(String audioUrl) async {
    if (Platform.isAndroid) {
      await _androidDownloadFunction(audioUrl);
    } else if (Platform.isIOS) {
      await _iOSDownloadFunction(audioUrl);
    }
  }

  Future<void> _iOSDownloadFunction(String audioUrl) async {
    try {
      var response = await http.get(Uri.parse(audioUrl));
      if (response.statusCode == 200) {
        String filename = "BotnoiVoice${randomString(6)}.mp3";
        var tempDir = await getTemporaryDirectory();
        var path = '${tempDir.path}/$filename';
        var file = File(path);
        await file.writeAsBytes(response.bodyBytes);
        print("Printing Path: ");
        print(tempDir);
        print(path);
        print(file);
        OpenAppFile.open(path);
      } else {
        print('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error ios downloading file: $e');
    }
  }

  Future<void> _androidDownloadFunction(String audioUrl) async {
    try {
      var filename = "BotnoiVoice${randomString(6)}.mp3";
      List<Directory>? directories =
          await getExternalStorageDirectories(type: StorageDirectory.downloads);
      if (directories == null || directories.isEmpty) {
        throw Exception('No external storage directories found');
      }
      String directoryPath = directories.first.path;
      String filePath = "$directoryPath/$filename";
      var file = File(filePath);
      var res = await http.get(Uri.parse(audioUrl));
      if (res.statusCode == 200) {
        await file.writeAsBytes(res.bodyBytes);
        print('Download successful: $filename');
        print('Download complete');
        print("Printing Path: ");
        print(filename);
        print(filePath);
        print(file);
        OpenAppFile.open(filePath);
      } else {
        print('Failed to download file: ${res.statusCode}');
      }
    } catch (e) {
      print('Error android downloading file: $e');
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    user = null;
    jwtToken = null;
    credentialsToken = null;
    credits = null;
    await _storage.delete(key: 'jwtToken');
    await _storage.delete(key: 'credentialsToken');
    print("signOut -> WORKING !!!");
    notifyListeners();
  }
}
