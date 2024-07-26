import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:botnoivoice/model/models.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:botnoivoice/model/models.dart';
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
    print("isAuthenticated -> user: $user");
    return user != null && jwtToken != null && credentialsToken!=null;
  }

  Authentication() {
    FirebaseAuth.instance.authStateChanges().listen((
      User? user,
    ) {
      print("Printing user details");
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
    print('Loaded JWT Token: $jwtToken');
    notifyListeners();
  }

  Future<void> _saveJwtToken(String token) async {
    await _storage.write(key: 'jwtToken', value: token);
    print('Saved JWT Token: $token');
  }
  
  Future<void> _loadCredentialsToken() async {
    credentialsToken = await _storage.read(key: 'credentialsToken');
    print('Loaded Credential Token: $credentialsToken');
    notifyListeners();
  }

  Future<void> _saveCredentialsToken(String token) async {
    await _storage.write(key: 'credentialsToken', value: credentialsToken);
    print('Saved Credential Token: $token');
  }



  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
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
          print("### START -> signInWithGoogle  ### \n");
          print("getIdTokenWithFirebase: $idToken");

          if (jwtToken != null) {
            print("jwtToken: $jwtToken");
            await _saveJwtToken(jwtToken!);
            credentialsToken = await getCredentialsToken(jwtToken);
            await _saveCredentialsToken(credentialsToken!);
            print("getCredentialsToken: $credentialsToken");
            await getProfileWithToken(jwtToken);
            print("getProfileWithToken: $getProfileWithToken");
            print("### END -> signInWithGoogle ### \n");
            notifyListeners(); // แจ้งให้ UI ทราบว่าข้อมูลมีการเปลี่ยนแปลง
          }
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
    print("\n ###### START getIdTokenWithFirebase");
    if (idToken == null) {
      print("getIdTokenWithFirebase -> idToken: $idToken");
    } else {
      print('getIdTokenWithFirebase -> idToken is empty ');
    }
    print(" ###### END getIdTokenWithFirebase \n");
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

        // *** START jwtToken ***
        var tokenIndex = message.indexOf('token=');

        if (tokenIndex != -1) {
          var tokenStartIndex = tokenIndex + 'token='.length;
          jwtToken = message.substring(tokenStartIndex);

          print('jwtToken from getIdTokenWithFirebase: $jwtToken');

          return jwtToken;

          // *** END jwtToken ***
        } else {
          print('Token not found -> getIdTokenWithFirebase: $message');
        }
      } else {
        print(
            'Failed to load data -> getIdTokenWithFirebase: Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error -> getIdTokenWithFirebase: $e');
    }
    return null;
  }

  Future<String?> getProfileWithToken(String? jwtToken) async {
    if (jwtToken == null) {
      print('getProfileWithToken -> jwtToken is null');
      return null;
    }

    String url = 'https://api-voice.botnoi.ai/api/dashboard/get_profile';
    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json'
    };
    print('Testing Signing out');
    
    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print('Response data from getProfileWithToken: $data');

        // เก็บค่า credits ในตัวแปรของ class
        credits = data['data']['credits'].toString(); // ดึงข้อมูล credits จาก data
        print('getProfileWithToken -> credits: $credits');
        notifyListeners(); // แจ้งให้ UI ทราบว่าข้อมูลมีการเปลี่ยนแปลง
        return credits;
      } else {
        print(
            'Failed to load profile from getProfileWithToken. Status code: ${response.statusCode}');
            return null;
      }
    } catch (e) {
      print('Error in getProfileWithToken: $e');
    }

    print('getProfileWithToken -> Returning null');
    return null;
  }

  Future<String?> getCredentialsToken(String? jwtToken) async {
    if (jwtToken == null) {
      print('getCredentialsToken -> jwtToken is null');
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
        print('Response data from getCredentialsToken: $data');

        credentialsToken = data['data'][0]['token'].toString(); // ดึง token จาก data
        print('Credentials Token: $credentialsToken');
        notifyListeners(); // แจ้งให้ UI ทราบว่าข้อมูลมีการเปลี่ยนแปลง
        return credentialsToken; // Return the token here

      }
      else if(response.statusCode==401){
        signOut();
        print('Unauthorized Token ${response.statusCode}');
        return null;
      } 
      else {
        print(
            'Failed to load Credentials-Token. Status code: ${response.statusCode}');
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

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    user = null;
    jwtToken = null;
    credentialsToken = null;
    credits = null;
    await _storage.delete(key: 'jwtToken');
    await _storage.delete(key: 'credentialsToken');
    notifyListeners();
  }
  
}
