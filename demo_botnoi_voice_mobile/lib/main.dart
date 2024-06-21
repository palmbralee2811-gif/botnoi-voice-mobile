import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

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
  String _selectedTypeMedia = 'mp3'; // Default file type

  final List<String> _typeMedia = ['wav', 'mp3', 'm4a'];

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
      "type_media": _selectedTypeMedia,
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
          String filename = "Botnoi_Voice_${randomString(6)}.$_selectedTypeMedia";

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

  // ฟังก์ชันสุ่มชื่อไฟล์ a-z, A-Z และ 0-9
  String randomString(int length) {
    // const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    const characters = '0123456789';

    final random = Random();
    return String.fromCharCodes(Iterable.generate(length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length))));
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
            ],
          ),
        ),
      ),
    );
  }
}
