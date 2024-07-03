import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ไล่แฉดของปุ่ม
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

// import for generate voice
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

// import file
import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:botnoivoice/Model/speaker_model.dart';
import 'package:botnoivoice/Screens/GenerateScreen/home_screen.dart';

class CategoryVoice extends StatefulWidget {
  final String speakerId;
  final TextEditingController textController;

  CategoryVoice(
      {Key? key, required this.textController, required this.speakerId})
      : super(key: key);

  @override
  _CategoryVoiceState createState() => _CategoryVoiceState();
}

class _CategoryVoiceState extends State<CategoryVoice> {
  int selectedIndex = -1;
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
          // เรียงลำดับ speakers ตาม speakerId จากน้อยไปมาก
          speakers.sort((a, b) =>
              int.parse(a.speakerId).compareTo(int.parse(b.speakerId)));
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
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Container(
                color: Colors.white,
                height: 170,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 170,
                      width: 370,
                      child: GridView.builder(
                        itemCount: speakers.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          mainAxisExtent: 110,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          Speaker speaker = speakers[index];
                          return GestureDetector(
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
                                  print(
                                      "Audio URL is empty, cannot play audio");
                                }
                              }

                              print('${speaker.speakerId}');
                              print('${speaker.language}');
                              print('${speaker.thaiName}');
                              print('${speaker.engName}');
                              print('${speaker.audio}');
                              await playAudio();

                              // นำทางไปยัง VoiceScreen พร้อมกับส่งค่า speakerId
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Homescreen(
                                    speakerId: '',
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 120,
                              height: 150,
                              decoration: BoxDecoration(
                                border: GradientBoxBorder(
                                  width: 4,
                                  gradient: selectedIndex == index
                                      ? const LinearGradient(colors: [
                                          Color(0xFF9A96F5),
                                          Color(0xFF00E0FF)
                                        ])
                                      : const LinearGradient(colors: [
                                          Colors.transparent,
                                          Colors.transparent
                                        ]),
                                ),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(speaker.faceImage),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: selectedIndex == index
                                        ? Colors.blue.withOpacity(0.5)
                                        : Colors.transparent,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      '${speaker.thaiName}\n${speaker.engName}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    'assets/logo/Vector.svg',
                                    color: selectedIndex == index
                                        ? const Color(0xFF9A96F5)
                                        : Colors.white,
                                    width: 16,
                                    height: 16,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
