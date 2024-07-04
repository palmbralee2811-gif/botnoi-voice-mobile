// marketplace_screen.dart
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:botnoivoice/Screens/HomeScreen/voiceScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// นำเข้า Model โครงสร้างข้อมูล แปลง JSON เป็น Object
import 'package:botnoivoice/Model/speaker_model.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  _MarketplaceScreenState createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  bool isAudioPlaying = false;
  AudioPlayer audioPlayer = AudioPlayer();
  bool _isLoading = true;
  List<Speaker> speakers = [];

  @override
  void initState() {
    super.initState();
    fetchMarketplaceData();
  }

  Future<void> fetchMarketplaceData() async {
    final auth = Provider.of<Authentication>(context, listen: false);
    String? jwtToken = auth.idTokenWithFirebase;
    print('MarketplaceScreen -> fetchMarketplaceData -> jwtToken: $jwtToken');

    if (jwtToken != null) {
      String? data = await getAllMarketplace(jwtToken);
      if (data != null) {
        setState(() {
          var jsonData = json.decode(data);
          speakers = List<Speaker>.from(jsonData['response']
              .map((speakerJson) => Speaker.fromJson(speakerJson)));
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> getAllMarketplace(String? jwtToken) async {
    if (jwtToken == null) {
      print('jwtToken is null');
      return null;
    }

    String url =
        'https://api-voice-staging.botnoi.ai/api/service/get_all_marketplace';

    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return utf8.decode(response.bodyBytes);
      } else {
        print(
            'Failed to load Marketplace data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching Marketplace data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // เรียงลำดับ speakers ตาม speakerId จากน้อยไปมาก 1,2,3,4
    // Debug 1,100,100,13,15,2,3,4 เรียงลำดับผิด เพราะเป็น String จัดเรียงแบบอักษระ
    // แปลงค่า speaker.speakerId จาก String เป็น int 
    speakers.sort((a, b) => int.parse(a.speakerId).compareTo(int.parse(b.speakerId)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace Data'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: speakers.length,
              itemBuilder: (context, index) {
                Speaker speaker = speakers[index];
                // id = speaker.speakerId
                return ListTile(
                  leading: Image.network(speaker.faceImage),
                  title: Text(speaker.thaiName),
                  subtitle: Text(speaker.engName),
                  
                  onTap: () async {
                    // https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/alisa/sound_1_alisa.wav
                    String? audioURL = speaker.audio;

                    Future<void> playAudio() async {
                      if (audioURL.isNotEmpty) {
                        if (isAudioPlaying) {
                          // ถ้ามีการเล่นเสียงอยู่ ให้หยุดก่อน
                          await audioPlayer.stop();
                        }

                        await audioPlayer.play(UrlSource(audioURL));
                        setState(() {
                          isAudioPlaying = true;
                        });

                        audioPlayer.onPlayerComplete.listen((event) {
                          print("#### Play Audio's Complete");
                          setState(() {
                            isAudioPlaying = false;
                          });
                        });
                      } else {
                        setState(() {
                          isAudioPlaying = false;
                        });
                        print("Audio URL is empty, cannot play audio");
                      }
                    }

                    print('${speaker.speakerId}');
                    print('${speaker.language}');
                    print('${speaker.thaiName}');
                    print('${speaker.engName}');
                    print('${speaker.audio}');
                    //await playAudio();
                    
                    // นำทางไปยัง VoiceScreen พร้อมกับส่งค่า speakerId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VoiceScreen(speakerId: speaker.speakerId),
                      ),
                    );
                  },
                  
                );
              },
            ),
    );
  }
}
