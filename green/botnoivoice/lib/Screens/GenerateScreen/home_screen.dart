import 'dart:convert';
import 'dart:io';
import 'package:botnoivoice/Screens/GenerateScreen/appbar.dart';
import 'package:botnoivoice/Screens/GenerateScreen/textwidget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:audioplayers/audioplayers.dart';

// import file
import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:botnoivoice/function/randomString.dart';

import '../AuthScreen/login_screen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key, required String speakerId});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _currentIndex = 0;
  final TextEditingController _textController = TextEditingController();
  String _selectedSpeakerId = ''; // เลือก speakerId ที่ต้องการ

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authentication>(context, listen: false);

    return Scaffold(
      drawer: Drawer(
        elevation: 16,
        shadowColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: const Text('Sign-out'),
              onTap: () async {
                await auth.signOut();
                if (!context.mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Appbar(),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00E0FF), Color(0xFF9A96F5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                textController: _textController,
                onSpeakerIdSelected: (String speakerId) {
                  setState(() {
                    _selectedSpeakerId = speakerId;
                  });
                },
              ),
              GenerateButton(
                speakerId: _selectedSpeakerId,
                textController: _textController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GenerateButton extends StatefulWidget {
  final String speakerId;
  final TextEditingController textController;

  const GenerateButton({
    Key? key,
    required this.speakerId,
    required this.textController,
  }) : super(key: key);

  @override
  _GenerateButtonState createState() => _GenerateButtonState();
}

class _GenerateButtonState extends State<GenerateButton> {
  String _response = '';
  String _audioUrl = '';
  String selectedTypeMedia = 'mp3'; // Default file type

  final List<String> _typeMedia = ['wav', 'mp3', 'm4a'];

  Future<void> generateAudio(String text) async {
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

    String url =
        "https://api-voice-staging.botnoi.ai/openapi/v1/generate_audio";
    Map<String, dynamic> payload = {
      "text": text,
      "speaker": widget.speakerId,
      "volume": 1,
      "speed": 1,
      "type_media": selectedTypeMedia,
      "save_file": true,
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

  Future<void> playAudio() async {
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
      if (await Permission.storage.request().isGranted) {
        Dio dio = Dio();

        Directory? downloadsDir = await getExternalStorageDirectory();
        if (downloadsDir != null) {
          String downloadsPath = downloadsDir.path;
          String url = _audioUrl;
          String filename =
              "Botnoi_Voice_${randomString(6)}.$selectedTypeMedia";

          String filePath = "$downloadsPath/$filename";

          await dio.download(url, filePath);

          print("#### File downloaded to: $filePath");

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
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      // Generate audio
                      generateAudio(widget.textController.text);
                      downloadFile();
                    } catch (e) {
                      print(
                          'Error during audio generation, playback, or download: $e');
                      // Handle errors appropriately
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, backgroundColor: Colors
                        .transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ), // Set transparent to show the gradient
                    shadowColor: const Color.fromARGB(
                        255, 224, 221, 221), // Box shadow color
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9A96F5), Color(0xFF00E0FF)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      height: 70,
                      width: 170,
                      alignment: Alignment.center,
                      child: const Text(
                        "สร้างเสียง",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Text('_response $_response')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
