import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/Model/speaker_model.dart';
import 'package:botnoivoice/Screens/AuthScreen/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:botnoivoice/function/randomString.dart';
import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  final int maxLength = 1000;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();
  String _response = '';
  String _audioUrl = '';
  String _selectedTypeMedia = 'mp3';
  bool isAudioPlaying = false;
  bool isLoading = false;
  String? speakerId;

  final List<String> _typeMedia = ['wav', 'mp3', 'm4a'];
  Future<List<Speaker>>? _fetchMarketplaceDataFuture;
  bool isPlaying = false;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<Authentication>(context, listen: false);
    if (auth.isAuthenticated) {
      loadData();
      _fetchMarketplaceDataFuture = _fetchData();
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  int _selectedPageIndexVoice = 0;
  int _selectedPageIndexSetting = 0;
  int _inputtext = 0;
  // int _button = 0;

  void _selectPageVoice(int index) {
    setState(() {
      _selectedPageIndexVoice = index;
    });
  }

  void _selectPageSetting(int index) {
    setState(() {
      _selectedPageIndexSetting = index;
    });
  }

  Future<void> loadData() async {
    final auth = Provider.of<Authentication>(context, listen: false);
    await auth.getProfileWithToken(auth.jwtToken);
    setState(() {});
  }

  Future<List<Speaker>> _fetchData() async {
    List<Speaker>? cachedData = await _loadDataFromCache();
    if (cachedData != null && cachedData.isNotEmpty) {
      return cachedData;
    } else {
      return fetchMarketplaceData();
    }
  }

  Future<List<Speaker>> fetchMarketplaceData() async {
    final auth = Provider.of<Authentication>(context, listen: false);
    String? jwtToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MjExMjIwOTUsImlhdCI6MTcyMTAzNTY5NSwibmJmIjoxNzIxMDM1Njk1LCJ1aWQiOiJlNGJmN2I0Zi04M2E3LTU5ZmYtYTMxOC0wMDNmZDRjMjRkMmIiLCJ1c2VyX2lkIjoiOUFnblFEb1J4S1lNWmpyc1o1RkZOcjNtMDZSMiJ9.FQIVHX5NE4F2BYuS4NwKeMr3tVsWU3UXJlcB0TZZDWg';

    if (jwtToken != null) {
      String? data = await getAllMarketplace(jwtToken);
      if (data != null) {
        var jsonData = json.decode(data);
        List<Speaker> speakers = List<Speaker>.from(jsonData['response']
            .map((speakerJson) => Speaker.fromJson(speakerJson)));

        _saveDataToCache(speakers);
        return speakers;
      } else {
        return [];
      }
    } else {
      return [];
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

  Future<List<Speaker>?> _loadDataFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('marketplaceData');
    if (cachedData != null && cachedData.isNotEmpty) {
      var jsonData = json.decode(cachedData);
      return List<Speaker>.from(jsonData.map((x) => Speaker.fromJson(x)));
    }
    return null;
  }

  Future<void> _saveDataToCache(List<Speaker> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = json.encode(data.map((e) => e.toJson()).toList());
    prefs.setString('marketplaceData', jsonData);
  }

  Future<void> generateAudio(String text) async {
    setState(() {
      isLoading = true;
      _response = '';
      _audioUrl = '';
    });

    final auth = Provider.of<Authentication>(context, listen: false);
    String? profileData = await auth.getProfileWithToken(auth.jwtToken);
    auth.setDataProfileWithToken(profileData);

    String? token = auth.credentialsToken;

    /*
    String? language;
    String th = "th";
    String en = "en";

    // Regular expression to check if text contains Thai characters
    RegExp thaiRegex = RegExp(r'[\u0E00-\u0E7F]');

    if (thaiRegex.hasMatch(text)) {
      language = th;
    } else {
      language = en;
    }
    */

    print('\n text: $text \n speaker: $speakerId \n');
    // print('language: $language \n');

    String url =
        "https://api-voice-staging.botnoi.ai/openapi/v1/generate_audio";
    Map<String, dynamic> payload = {
      "text": text,
      "speaker": speakerId,
      "volume": 1,
      "speed": 1,
      "type_media": _selectedTypeMedia,
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
          isLoading = false;
          // downloadFile();
        });
      } else {
        setState(() {
          _response =
              "Failed to retrieve data. Status Code: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _response = "Failed to connect to the server. Error: $e";
        isLoading = false;
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
              "Botnoi_Voice_${randomString(6)}.$_selectedTypeMedia";

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

  Widget appBar() {
    final auth = Provider.of<Authentication>(context, listen: false);
    String? credits = auth.dataProfileWithToken;

    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 90.w),
                child: Image.asset(
                  'assets/logo/Frame.png',
                  width: 30.w,
                  height: 34.h,
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 54.w,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 224, 221, 221),
                              blurRadius: 3.0,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 25.h,
                              width: 20.h,
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/logo/point.png',
                                      width: 20.w,
                                      height: 20.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  " ${credits ?? '100'} ",
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget appBarDrawer(BuildContext context) {
    final auth = Provider.of<Authentication>(context, listen: false);

    return Drawer(
      elevation: 16,
      shadowColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                Consumer<Authentication>(
                  builder: (context, auth, child) {
                    return auth.user != null
                        ? Text(
                            '${auth.user!.displayName}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )
                        : const SizedBox
                            .shrink(); // or any other widget if you want to show something when not signed in
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              color: Colors.black,
            ),
            title: const Text('สตูดิโอ'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
            title: const Text(
              'ออกจากระบบ',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
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
    );
  }

  // logic
  int selectedIndex = -1;
  int selectedIndex2 = -1;

  /*
  Widget categoryVoice(BuildContext context) {
    double screenSizewidth = MediaQuery.of(context).size.width;
    double screenSizeheight = MediaQuery.of(context).size.height;
    // var screenSize = MediaQuery.of(context).size;

    return FutureBuilder<List<Speaker>>(
      future: _fetchMarketplaceDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          List<Speaker> speakers = snapshot.data!;
          speakers.sort((a, b) =>
              int.parse(a.speakerId).compareTo(int.parse(b.speakerId)));

          return InkWell(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      color: Colors.white,
                      height: screenSizeheight * 0.196,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: screenSizeheight * 0.195,
                            width: screenSizewidth * 0.90,
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

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        speakerId = speaker.speakerId;
                                        print(
                                            'speakerId -> Widget(DataVoice): $speakerId');
                                        print(
                                            'thaiName -> Widget(DataVoice): ${speaker.thaiName}');
                                        print(
                                            'engName -> Widget(DataVoice): ${speaker.engName}');
                                        setState(() {});

                                        setState(() {
                                          selectedIndex = index;
                                        });
                                      },
                                      child: Container(
                                        width: screenSizewidth * 0.9,
                                        height: screenSizeheight * 0.180,
                                        decoration: BoxDecoration(
                                          border: GradientBoxBorder(
                                            width: screenSizeheight * 0.01,
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            /*
                                              image
                                              faceImage
                                              horizontalFaceImage 
                                              squareImage
                                            */
                                            image: NetworkImage(
                                                speaker.squareImage),
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 39.w,
                                                                top: 8.w),
                                                        child: selectedIndex ==
                                                                index
                                                            ? Container(
                                                                width: 21.w,
                                                                height: 17.h,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  gradient:
                                                                      const LinearGradient(
                                                                    colors: [
                                                                      Color(
                                                                          0xFF9A96F5),
                                                                      Color(
                                                                          0xFF00E0FF)
                                                                    ],
                                                                  ),
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.r),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                      'เลือก',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            7.sp,
                                                                      )),
                                                                ),
                                                              )
                                                            : const Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .transparent,
                                                              ),
                                                      ),
                                                      GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              selectedIndex2 =
                                                                  index;
                                                            });
                                                          },
                                                          child:
                                                              selectedIndex2 ==
                                                                      index
                                                                  ? ShaderMask(
                                                                      shaderCallback:
                                                                          (Rect
                                                                              bounds) {
                                                                        return const LinearGradient(
                                                                          colors: [
                                                                            Color(0xFF9A96F5),
                                                                            Color(0xFF00E0FF),
                                                                          ],
                                                                        ).createShader(
                                                                            bounds);
                                                                      },
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        'assets/logo/heart (1).svg',
                                                                        width:
                                                                            10.w,
                                                                        height:
                                                                            10.h,
                                                                        color: Colors
                                                                            .white, // Optional: Default color of the SVG
                                                                      ),
                                                                    )
                                                                  : SvgPicture
                                                                      .asset(
                                                                      'assets/logo/heart.svg',
                                                                      width:
                                                                          12.sp,
                                                                      height:
                                                                          12.sp,
                                                                    ))
                                                    ]),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.w,
                                                      right: 8.w,
                                                      top: 45.w),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        selectedIndex == index
                                                            ? ShaderMask(
                                                                shaderCallback:
                                                                    (Rect
                                                                        bounds) {
                                                                  return const LinearGradient(
                                                                    colors: [
                                                                      Color(
                                                                          0xFF9A96F5),
                                                                      Color(
                                                                          0xFF00E0FF),
                                                                    ],
                                                                  ).createShader(
                                                                      bounds);
                                                                },
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  'assets/logo/Vector.svg',
                                                                  width: 10.sp,
                                                                  height: 10.sp,
                                                                  color: Colors
                                                                      .white, // Optional: Default color of the SVG
                                                                ),
                                                              )
                                                            : SvgPicture.asset(
                                                                'assets/logo/Vector.svg',
                                                              ),
                                                        Text(
                                                          speaker.thaiName,
                                                          style: TextStyle(
                                                            fontSize: 10.sp,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ]),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
  */

  Widget categoryVoice02(BuildContext context) {
    double screenSizewidth = MediaQuery.of(context).size.width;
    double screenSizeheight = MediaQuery.of(context).size.height;
    // var screenSize = MediaQuery.of(context).size;

    return FutureBuilder<List<Speaker>>(
      future: _fetchMarketplaceDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          List<Speaker> speakers = snapshot.data!;
          speakers.sort((a, b) =>
              int.parse(a.speakerId).compareTo(int.parse(b.speakerId)));

          return InkWell(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: screenSizeheight * 0.04,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Container(
                            color: Colors.transparent,
                            width: 500.w,
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.w, left: 10.w),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  /*
                            Language(),
                            Sex(),
                            Recommant(),
                            Favorite(),
                            All(),
                            New(),
                            Voice(),
                            Advert(),
                            Podcast(),
                            */
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: screenSizeheight * 0.196,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: screenSizeheight * 0.195,
                            width: screenSizewidth * 0.90,
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
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        // https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/alisa/sound_1_alisa.wav
                                        String? audioURL = speaker.audio;

                                        Future<void> playAudio() async {
                                          if (audioURL.isNotEmpty) {
                                            if (isAudioPlaying) {
                                              // ถ้ามีการเล่นเสียงอยู่ ให้หยุดก่อน
                                              await audioPlayer.stop();
                                            }

                                            await audioPlayer
                                                .play(UrlSource(audioURL));
                                            setState(() {
                                              isAudioPlaying = true;
                                            });

                                            audioPlayer.onPlayerComplete
                                                .listen((event) {
                                              print(
                                                  "#### Play Audio's Complete");
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

                                        await playAudio();

                                        speakerId = speaker.speakerId;
                                        print(
                                            '\n speakerId -> Widget(DataVoice): $speakerId');
                                        print(
                                            'thaiName -> Widget(DataVoice): ${speaker.thaiName}');
                                        print(
                                            'engName -> Widget(DataVoice): ${speaker.engName}');
                                        print(
                                            'language -> Widget(DataVoice): ${speaker.language}');
                                        print(
                                            'availableLanguage -> Widget(DataVoice): ${speaker.availableLanguage}');
                                        setState(() {});

                                        setState(() {
                                          selectedIndex = index;
                                        });
                                      },
                                      child: Container(
                                        width: screenSizewidth * 0.9,
                                        height: screenSizeheight * 0.180,
                                        decoration: BoxDecoration(
                                          border: GradientBoxBorder(
                                            // width: screenSizeheight * 0.01,
                                            width: 3.h,
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                speaker.squareImage),
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 39.w,
                                                                top: 8.w),
                                                        child:
                                                            selectedIndex ==
                                                                    index
                                                                ? Container(
                                                                    width: 21.w,
                                                                    height:
                                                                        17.h,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      gradient:
                                                                          const LinearGradient(
                                                                        colors: [
                                                                          Color(
                                                                              0xFF9A96F5),
                                                                          Color(
                                                                              0xFF00E0FF)
                                                                        ],
                                                                      ),
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.r),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child: Text(
                                                                          'เลือก',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                7.sp,
                                                                            color:
                                                                                Colors.white,
                                                                          )),
                                                                    ),
                                                                  )
                                                                : const Icon(
                                                                    Icons.check,
                                                                    color: Colors
                                                                        .transparent,
                                                                  ),
                                                      ),
                                                      /*
                                                      GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              selectedIndex2 =
                                                                  index;
                                                            });
                                                          },
                                                          child:
                                                              selectedIndex2 ==
                                                                      index
                                                                  ? ShaderMask(
                                                                      shaderCallback:
                                                                          (Rect
                                                                              bounds) {
                                                                        return const LinearGradient(
                                                                          colors: [
                                                                            Color(0xFF9A96F5),
                                                                            Color(0xFF00E0FF),
                                                                          ],
                                                                        ).createShader(
                                                                            bounds);
                                                                      },
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        'assets/logo/heart (1).svg',
                                                                        width:
                                                                            10.w,
                                                                        height:
                                                                            10.h,
                                                                        color: Colors
                                                                            .white, // Optional: Default color of the SVG
                                                                      ),
                                                                    )
                                                                  : SvgPicture
                                                                      .asset(
                                                                      'assets/logo/heart.svg',
                                                                      width:
                                                                          12.sp,
                                                                      height:
                                                                          12.sp,
                                                                    ))
                                                                    */
                                                    ]),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 6.w,
                                                      right: 6.w,
                                                      top: 45.w),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        selectedIndex == index
                                                            ? ShaderMask(
                                                                shaderCallback:
                                                                    (Rect
                                                                        bounds) {
                                                                  return const LinearGradient(
                                                                    colors: [
                                                                      Color(
                                                                          0xFF9A96F5),
                                                                      Color(
                                                                          0xFF00E0FF),
                                                                    ],
                                                                  ).createShader(
                                                                      bounds);
                                                                },
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  'assets/logo/Vector.svg',
                                                                  width: 10.sp,
                                                                  height: 10.sp,
                                                                  color: Colors
                                                                      .white, // Optional: Default color of the SVG
                                                                ),
                                                              )
                                                            : SvgPicture.asset(
                                                                'assets/logo/Vector.svg',
                                                              ),
                                                        Text(
                                                          speaker.thaiName,
                                                          style: TextStyle(
                                                            fontSize: 10.sp,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ]),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }

  /*
  // Original (ต้นฉบับ)
  Widget buildVoiceButton() {
    double screenSizewidth = MediaQuery.of(context).size.width;
    double screenSizeheight = MediaQuery.of(context).size.height;

    return Container(
      height: screenSizeheight * 0.093.h,
      width: screenSizewidth * 0.78.w,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 55.h,
                width: screenSizewidth * 0.7.w,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 224, 221, 221),
                      blurRadius: 6.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.r),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9A96F5), Color(0xFF00E0FF)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "สร้างเสียง",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w, top: 4.w),
                      child: Image.asset(
                        'assets/logo/point.png',
                        width: 18.w,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: Text(
                        '0',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  */

  Widget buildVoiceButton02() {
    //final auth = Provider.of<Authentication>(context, listen: false);
    //String? credits = auth.dataProfileWithToken;

    double screenSizewidth = MediaQuery.of(context).size.width;
    double screenSizeheight = MediaQuery.of(context).size.height;
    return Container(
      height: screenSizeheight * 0.093.h,
      width: screenSizewidth * 0.78.w,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 55.h,
                width: screenSizewidth * 0.7.w,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 224, 221, 221),
                      blurRadius: 6.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.r),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9A96F5), Color(0xFF00E0FF)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "สร้างเสียง",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    /*
                    Padding(
                      padding: EdgeInsets.only(left: 5.w, top: 4.w),
                      child: Image.asset(
                        'assets/logo/point.png',
                        width: 18.w,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: Text(
                        " ${credits ?? '100'} ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    */
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final auth = Provider.of<Authentication>(context, listen: false);
    // String? credits = auth.dataProfileWithToken;

    final screenHeight = MediaQuery.of(context).size.height;
    double screenSizewidth = MediaQuery.of(context).size.width;
    double screenSizeheight = MediaQuery.of(context).size.height;
    int _currentIndex = 0;

    if (_selectedPageIndexVoice == 1) {
      _inputtext = 1;
      // _button = 1;
      // if (_selectedPageIndexSetting == 1) {
      //   _selectedPageIndexVoice = 0;
      //   _selectedPageIndexSetting = 1;
      // }
    }
    // if (_selectedPageIndexSetting == 2) {
    //   _selectedPageIndexVoice = 1;
    //   _selectedPageIndexSetting = 0;
    // }
    if (_selectedPageIndexVoice == 2) {
      _inputtext = 0;
    }
    if (_selectedPageIndexSetting == 1) {
      _inputtext = 1;
    }

    return Scaffold(
      // ปิด Tag แสดงผล คำเตือน สีเหลือง
      resizeToAvoidBottomInset: false,

      drawer: appBarDrawer(context),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: appBar(),
      ),
      body: Column(
        children: <Widget>[
          /*
          SafeArea(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 55.w,
                      ),
                      Image.asset(
                        'assets/logo/Frame.png',
                        width: 30.w,
                        height: 34.h,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 54.w,
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 224, 221, 221),
                                      blurRadius: 3.0,
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 25.h,
                                      width: 20.h,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/logo/point.png',
                                              width: 20.w,
                                              height: 20.h,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          " $credits ??  '100' ",
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          */
          Container(
            color: Colors.blue,
            height: _inputtext == 1
                ? screenSizeheight * 0.35
                : screenSizeheight * 0.64,
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      width: screenSizewidth * 0.75.w,
                      height: _inputtext == 1
                          ? screenSizeheight * 0.24.h
                          : screenSizeheight * 0.40.h,
                      // _inputtext == 1
                      //     ? screenSizeheight * 0.270.h
                      //     : screenSizeheight * 0.40.h,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 25.w, right: 10.w, top: 20.w),
                        child: Column(
                          children: [
                            TextField(
                              style: const TextStyle(color: Colors.black),
                              minLines: _inputtext == 1 ? 5 : 13,
                              maxLines: _inputtext == 1 ? 5 : 13,
                              keyboardType: TextInputType.multiline,
                              controller: textController,
                              onChanged: (text) {
                                if (textController.text.length >
                                    widget.maxLength) {
                                  textController.text = textController.text
                                      .substring(0, widget.maxLength);
                                  textController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset: textController.text.length),
                                  );
                                }
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    'กรุณากรอกข้อความที่ต้องการจะสร้าง...',
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 14.sp),
                                hintMaxLines: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 25.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 1.w),
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle:
                                                TextStyle(fontSize: 10.sp),
                                          ),
                                          onPressed: () {
                                            textController.clear();
                                            setState(
                                                () {}); // To update the counter
                                          },
                                          child: Image.asset(
                                              'assets/logo/Frame 1028950648.png'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${textController.text.length}/${widget.maxLength}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.sp,
                                      height: 1.h,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ), // 60% of the screen height
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              height: _inputtext == 1
                  ? screenSizeheight * 0.50
                  : screenSizeheight * 0.26,
              child: Column(children: [
                InkWell(
                    onTap: () {
                      if (_selectedPageIndexVoice == 0) {
                        _selectPageVoice(1);
                      } else if (_selectedPageIndexVoice == 1) {
                        _selectPageVoice(2);
                      } else if (_selectedPageIndexVoice == 2) {
                        _selectPageVoice(1);
                      }
                    },
                    child: Selectvoice(
                        screenSizeheight: screenSizeheight,
                        selectedPageIndexVoice: _selectedPageIndexVoice)),
                if (_selectedPageIndexVoice == 1)
                  if (_selectedPageIndexVoice == 1) ...[
                    categoryVoice02(context)
                  ],
                Expanded(
                  flex: 7,
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          if (textController.text.isNotEmpty) {
                            audioPlayer.stop();
                          }
                        });
                        if (!isLoading) {
                          if (textController.text.isNotEmpty) {
                            generateAudio(textController.text).then((_) {
                              print('_response $_response');
                              downloadFile();
                            });
                          }
                        }
                      },
                      child: buildVoiceButton02()),
                ),
                /*
                Container(
                    height: screenSizeheight * 0.052.h,
                    width: screenSizewidth * 0.78.w,
                    color: const Color(0xFF27282B),
                    child: InkWell(
                      onTap: () {},
                      child: _currentIndex == 1
                          ? SvgPicture.asset(
                              'assets/logo/Property 1=studio, Property 2=deault (2).svg')
                          : SvgPicture.asset(
                              'assets/logo/Property 1=studio, Property 2=hover (1).svg'),
                    ),
                    )
                */
              ]), // 40% of the screen height
            ),
          ),
        ],
      ),
    );
  }
}

class Selectvoice extends StatelessWidget {
  const Selectvoice({
    super.key,
    required this.screenSizeheight,
    required int selectedPageIndexVoice,
  }) : _selectedPageIndexVoice = selectedPageIndexVoice;

  final double screenSizeheight;
  final int _selectedPageIndexVoice;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: screenSizeheight * 0.06.h,
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Colors.grey,
              width: 1.w,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Text(
                "เลือกเสียง",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: _selectedPageIndexVoice == 1
                    ? Icon(
                        Icons.expand_less,
                        color: const Color(0xFF323130),
                        size: 20.sp,
                      )
                    : Icon(
                        Icons.expand_more,
                        color: const Color(0xFF323130),
                        size: 20.sp,
                      )),
          ],
        ));
  }
}
