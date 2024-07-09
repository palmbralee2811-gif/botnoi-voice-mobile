import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/Model/speaker_model.dart';
import 'package:botnoivoice/Screens/AuthScreen/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

class VoiceScreen extends StatefulWidget {
  VoiceScreen({Key? key}) : super(key: key);

  @override
  _VoiceScreenState createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  final TextEditingController textController = TextEditingController();
  String _response = '';
  String _audioUrl = '';
  String _selectedTypeMedia = 'mp3';
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
    String? jwtToken = auth.idTokenWithFirebase;

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

  Future<void> _generateAudio(String text) async {
    setState(() {
      isLoading = true;
      _response = '';
      _audioUrl = '';
    });

    final auth = Provider.of<Authentication>(context, listen: false);
    String? profileData = await auth.getProfileWithToken(auth.jwtToken);
    auth.setDataProfileWithToken(profileData);

    String? token = auth.credentialsToken;

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

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authentication>(context, listen: false);
    String? credits = auth.dataProfileWithToken;

    return Scaffold(
      appBar: AppBar(
        title: Text('Botnoi Voice'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('credits: $credits'),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'Enter text...',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        _generateAudio(textController.text).then((_) {
                          print('_response $_response');
                          downloadFile();
                        });
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
              Consumer<Authentication>(
                builder: (context, auth, child) {
                  return auth.user != null
                      ? Text(
                          'Signed in as ${auth.user!.displayName}',
                          style: const TextStyle(fontSize: 20),
                        )
                      : const Text('');
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  await auth.signOut();
                  if (!context.mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text('Sign-out'),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Marketplace Data',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 400,
                // child: DataVoice(),

                child: categoryVoice(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
  Widget DataVoice() {
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

          return ListView.builder(
            itemCount: speakers.length,
            itemBuilder: (context, index) {
              Speaker speaker = speakers[index];

              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: InkWell(
                  onTap: () {
                    speakerId = speaker.speakerId;
                    print('speakerId -> Widget(DataVoice): $speakerId');
                    print('thaiName -> Widget(DataVoice): ${speaker.thaiName}');
                    print('engName -> Widget(DataVoice): ${speaker.engName}');
                    setState(() {});
                  },
                  child: Material(
                    elevation: 2,
                    child: ListTile(
                      leading: Image.network(speaker.faceImage),
                      title: Text(speaker.thaiName),
                      subtitle: Text(speaker.engName),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
  */

  // logic
  int selectedIndex = -1;
  int selectedIndex2 = -1;

  Widget categoryVoice() {
    double screenSizewidth = MediaQuery.of(context).size.width;
    double screenSizeheight = MediaQuery.of(context).size.height;
    // var screenSize = MediaQuery.of(context).size;
    // final data = AppDataBase.data;

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

                              // itemCount: data.length,
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
                                      onTap: ()  {
                                        speakerId = speaker.speakerId;
                                        print('speakerId -> Widget(DataVoice): $speakerId');
                                        print('thaiName -> Widget(DataVoice): ${speaker.thaiName}');
                                        print('engName -> Widget(DataVoice): ${speaker.engName}');
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
                                            image: NetworkImage(speaker.squareImage),
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
                                                            fontSize: 11.sp,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          speaker.engName,
                                                          style: TextStyle(
                                                            fontSize: 11.sp,
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

}
