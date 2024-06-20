import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const VoiceApp());
}

class VoiceApp extends StatelessWidget {
  const VoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Voice App',
      home: VoiceScreen(),
    );
  }
}

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  _VoiceScreenState createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  final TextEditingController _textController = TextEditingController();
  String _response = '';
  String _audioUrl = '';

  Future<void> _generateAudio(String text) async {
    setState(() {
      _response = '';
      _audioUrl = '';
    });

    String url = "https://api-voice.botnoi.ai/openapi/v1/generate_audio";
    Map<String, dynamic> payload = {
      "text": text,
      "speaker": "1",
      "volume": 1,
      "speed": 1,
      "type_media": "mp3",
      "save_file": true,
      "language": "th"
    };
    Map<String, String> headers = {
      'Botnoi-Token': 'YW1XdTdDYnpFZFFnWE16c3Q5Yk1kN3l1NE8yMjU2MTg5NA==',
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

  void _playAudio() {
    if (_audioUrl.isNotEmpty) {
      print("Audio URL: $_audioUrl");

      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer.play(UrlSource(_audioUrl));

      audioPlayer.onPlayerComplete.listen((event) {
        print("Playback complete");
      });
    } else {
      print("Audio URL is empty, cannot play audio");
    }
  }

  Future<void> downloadFile(String url, String filename) async {
    try {
      // Request storage permissions
      if (await Permission.storage.request().isGranted) {
        // Create a Dio instance
        Dio dio = Dio();

        // Get the downloads directory
        Directory? downloadsDir = await getExternalStorageDirectory();
        if (downloadsDir != null) {
          String downloadsPath = downloadsDir.path;

          // Define the local file path
          String filePath = "$downloadsPath/$filename";

          // Download the file and save it locally
          await dio.download(url, filePath);

          print("File downloaded to: $filePath");
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Botnoi Voice Mobile X'),
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
              ElevatedButton(
                onPressed: () async {
                  // Request permission to access storage
                  if (await Permission.storage.request().isGranted) {
                    // URL of the file to be downloaded
                    String fileUrl = _audioUrl;
                    // Desired filename for the downloaded file
                    String fileName = "downloaded_file.mp3";

                    await downloadFile(fileUrl, fileName);
                  } else {
                    print("Storage permission denied.");
                  }
                },
                child: const Text("Download File"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
