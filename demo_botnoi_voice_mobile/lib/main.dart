import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

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
    // Clear previous response
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
      "type_media": "m4a",
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
      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer.play(UrlSource(_audioUrl));
      // Handle audio player state changes, errors, etc.
      audioPlayer.onPlayerComplete.listen((event) {
        // Do something when playback finishes
        print("Playback complete");
      });
    }
  }

  Future openFile({required String url, String? fileName}) async {
    final name = fileName ?? url.split('/').last;
    final file = await pickFile();
    if (file == null) return;

    print('Path: ${file.path}');

    OpenFile.open(file.path);
  }

  Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return null;

    return File(result.files.first.path!);
  }

  // Download file into private folder not visible to user
  Future<File?> downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    try {
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Botnoi Voice Mobile'),
      ),
      body: Padding(
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
            Text(_response, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _playAudio,
              child: const Text('Play Audio'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: const Text('Download & Open'),
              onPressed: () => openFile(
                url:
                    'https://cdn.pixabay.com/photo/2022/02/16/18/10/fox-7017260_640.jpg',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
