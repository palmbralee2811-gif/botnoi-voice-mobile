import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/Screens/MarketPlaceScreen/marketplace_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// import file for function floder
import 'package:botnoivoice/Screens/AuthScreen/auth_screen.dart';
import 'package:botnoivoice/function/randomString.dart';
import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:provider/provider.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  _VoiceScreenState createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  final TextEditingController _textController = TextEditingController();
  String _response = '';
  String _audioUrl = '';
  String _selectedTypeMedia = 'mp3'; // Default file type

  final List<String> _typeMedia = ['wav', 'mp3', 'm4a'];

  Future<void> _generateAudio(String text) async {
    setState(() {
      _response = '';
      _audioUrl = '';
    });

    final auth = Provider.of<Authentication>(context, listen: false);

    // Call getProfileWithToken before generating audio to fetch new data
    String? profileData = await auth.getProfileWithToken(auth.jwtToken);
    // Use the public method to update the data
    auth.setDataProfileWithToken(profileData); 

    String? token = auth.credentialsToken;

    // String url = "https://api-voice.botnoi.ai/openapi/v1/generate_audio";
    String url =
        "https://api-voice-staging.botnoi.ai/openapi/v1/generate_audio";
    Map<String, dynamic> payload = {
      "text": text,
      "speaker": "1",
      "volume": 1,
      "speed": 1,
      "type_media": _selectedTypeMedia,
      "save_file": true,
      "language": "th"
    };

    Map<String, String> headers = {
      'Botnoi-Token': '$token',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _audioUrl = jsonData['audio_url'];
          _response = "Request successful!";
        });
      } else {
        setState(() {
          _response =
              "Failed to retrieve data. Status Code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _response = "Failed to connect to the server. Error: $e";
      });
    }
  }

  Future<void> _playAudio() async {
    if (_audioUrl.isNotEmpty) {
      print("Audio URL: $_audioUrl");

      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer.play(UrlSource(_audioUrl));

      audioPlayer.onPlayerComplete.listen((event) {
        print("#### Play Audio's Complete");
      });
    } else {
      print("Audio URL is empty, cannot play audio");
    }
  }

  Future<void> downloadFile() async {
    try {
      // Request storage permissions
      if (await Permission.storage.request().isGranted) {
        // Create a Dio instance
        Dio dio = Dio();

        // Get the downloads directory
        Directory? downloadsDir = await getExternalStorageDirectory();
        if (downloadsDir != null) {
          String downloadsPath = downloadsDir.path;
          String url = _audioUrl;
          String filename =
              "Botnoi_Voice_${randomString(6)}.$_selectedTypeMedia";

          // Define the local file path
          String filePath = "$downloadsPath/$filename";

          // Download the file and save it locally
          await dio.download(url, filePath);

          print("#### File downloaded to: $filePath");

          // Open the downloaded file
          await OpenFile.open(filePath);
        } else {
          print("Could not access the downloads directory.");
        }
      } else {
        print("Storage permission denied.");
      }
    } catch (e) {
      print("Error downloading file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authentication>(context, listen: false);

    String? credits = auth.dataProfileWithToken;
    print('credits on voice screen ${credits ?? 'N/A'}');

    return Scaffold(
      appBar: AppBar(
        title: Text('Botnoi Voice Mobile X | Point: ${credits ?? 'N/A'}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Enter text...',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _generateAudio(_textController.text);
                },
                child: const Text('Generate Audio'),
              ),
              const SizedBox(height: 16.0),
              Text(
                _response,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _playAudio,
                child: const Text('Play Audio'),
              ),
              const SizedBox(height: 16.0),
              DropdownButton<String>(
                value: _selectedTypeMedia,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTypeMedia = newValue!;
                  });
                },
                items: _typeMedia.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  downloadFile();
                },
                child: const Text("Download File"),
              ),
              const SizedBox(height: 16.0),
              Consumer<Authentication>(
                builder: (context, auth, child) {
                  return auth.user != null
                      ? Text(
                          'Signed in as ${auth.user!.displayName}',
                          style: const TextStyle(fontSize: 20),
                        )
                      : const Text(''); // Display nothing if not signed in
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  await auth.signOut();
                  if (!context.mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthScreen(),
                    ),
                  );
                },
                child: const Text('Sign-out'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MarketplaceScreen(),
                    ),
                  );
                },
                child: const Text('Marketplace Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
