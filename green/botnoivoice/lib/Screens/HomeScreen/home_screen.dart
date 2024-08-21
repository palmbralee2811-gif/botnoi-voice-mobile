import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:botnoivoice/Database/newdata.dart';
import 'package:botnoivoice/Screens/AllSpeakerScreen/all_speaker_screen.dart';
import 'package:botnoivoice/Screens/AppBarScreen/appbar_bottom_navbar.dart';
import 'package:botnoivoice/Screens/AppBarScreen/appbar_screen.dart';
import 'package:botnoivoice/Screens/DrawerAppBarScreen/drawer_appbar_screen.dart';
import 'package:botnoivoice/Screens/GradientScreen/gradient_button.dart';
import 'package:botnoivoice/Screens/GradientScreen/gradient_icon.dart';
import 'package:botnoivoice/Screens/GradientScreen/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  final int maxLength = 1000;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController textController = TextEditingController();

  // Generate Audio
  String response = '';
  String audioUrl = '';
  String? speakerId;
  String? language;
  String? gender;
  String? speechStyle; // เลือกสไตล์
  String? voiceStyle; //เลือกหมวดหมู่

  // Download File
  AudioPlayer audioPlayer = AudioPlayer();

  // Player Audio
  List<NewAppDataBase>? data;

  // Download Audio
  String selectedTypeMedia = 'mp3';

  // เลือกเสียงที่ชอบ
  Set<int> selectedIndex = <int>{};
  List<String> selectedIndexFavorites = [];

  bool showClearIcon = false;
  bool isSelectedFilter = false;

  String selectedLanguage = 'ไทย'; // ค่าเริ่มต้น ภาษา
  String selectedLanguageImage =
      'assets/images/national_flag/thai.png'; // ค่าเริ่มต้นรูป
  bool isExpanded = false;

  String selectedGender = 'ช/ญ'; //ค่าเริ่มต้น เพศ
  String selectedGenderImage =
      'assets/images/gender/all.svg'; // ค่าเริ่มต้น ไอเพศ
  bool changeIcon = false; // เลือกเพศ

  // เลือกสไตล์
  bool selectStyle = false;
  bool selectStyle1 = false;
  bool selectStyle2 = false;
  bool selectStyle3 = false;
  bool selectStyle4 = false;
  bool selectStyle5 = false;
  bool selectStyle6 = false;
  bool selectStyle7 = false;
  bool selectStyle8 = false;
  bool selectStyle9 = false;
  bool selectStyle10 = false;
  bool selectStyle11 = false;
  bool selectStyle12 = false;
  bool selectStyle13 = false;
  bool selectStyle14 = false;
  bool selectStyle15 = false;
  bool selectStyle16 = false;

  // เลือกหมวดหมู่
  bool selectCategory = false;
  bool selectCategory1 = false;
  bool selectCategory2 = false;
  bool selectCategory3 = false;
  bool selectCategory4 = false;
  bool selectCategory5 = false;
  bool selectCategory6 = false;
  bool selectCategory7 = false;
  bool selectCategory8 = false;
  bool selectCategory9 = false;
  bool selectCategory10 = false;

  @override
  void initState() {
    super.initState();
    speakerId = '1';
    language = 'TH'; // ค่าเริ่มต้น ภาษา
    gender = ''; // ค่าเริ่มต้น เพศ
    speechStyle = ''; // ค่าเริ่มต้น สไตล์
    voiceStyle = ''; // ค่าเริ่มต้น หมวดหมู่
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: const DrawerAppbarScreen(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              padding: EdgeInsets.only(left: 15.w),
              icon: Icon(
                Icons.menu_rounded,
                size: 32.sp,
                color: const Color(0xFF323130),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        backgroundColor: const Color(0xFFFFFFFF),
        title: AppbarScreen(context),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: AppbarBottomNavbar(
            imagePath: 'assets/square_image/square_ava.webp',
            languageIconPath: 'assets/images/national_flag/thai.png',
            onChangePressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllSpeakerScreen()));
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Container(
                width: 320.w,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFB1E9FD), Color(0xFFF9D8FD)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                height: 450.h,
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          width: 288.w,
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
                            padding: EdgeInsets.only(
                                left: 25.w, right: 10.w, top: 20.w),
                            child: Column(
                              children: [
                                TextField(
                                  cursorColor: const Color(0xFF000000),
                                  style: GoogleFonts.prompt(
                                    fontSize: 14.sp,
                                    color: const Color(0xFF323130),
                                  ),
                                  maxLines: 15,
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
                                    setState(() {
                                      showClearIcon =
                                          textController.text.isNotEmpty;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        'พิมพ์ข้อความให้ตรงกับภาษาที่เลือก . . .',
                                    hintStyle: TextStyle(
                                      color: const Color(0xFFA19F9D),
                                      fontStyle:
                                          GoogleFonts.prompt(fontSize: 14.sp)
                                              .fontStyle,
                                    ),
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
                                          showClearIcon
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 1.w),
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                        textStyle: TextStyle(
                                                            fontSize: 10.sp)),
                                                    onPressed: () {
                                                      setState(() {
                                                        textController.clear();
                                                        showClearIcon = false;
                                                      });
                                                    },
                                                    child: GradientIcon(
                                                      icon: Icons.close_sharp,
                                                      size: 20.sp,
                                                      gradient:
                                                          const LinearGradient(
                                                        colors: [
                                                          Color(0xFF9340FF),
                                                          Color(0xFF34BDFA)
                                                        ],
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 1.w),
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                        textStyle: TextStyle(
                                                            fontSize: 10.sp)),
                                                    onPressed: () {},
                                                    child: Icon(
                                                      Icons.close_sharp,
                                                      size: 20.sp,
                                                      color: Colors.transparent,
                                                    ),
                                                  ),
                                                )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          GradientText(
                                            text:
                                                '${textController.text.length}',
                                            style: GoogleFonts.prompt(
                                              fontSize: 14.sp,
                                              color: const Color(0xFFA19F9D),
                                            ),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF9340FF),
                                                Color(0xFF34BDFA)
                                              ],
                                            ),
                                          ),
                                          Text(
                                            ' / ${widget.maxLength}',
                                            style: GoogleFonts.prompt(
                                              fontSize: 14.sp,
                                              color: const Color(0xFFA19F9D),
                                            ),
                                          ),
                                        ],
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
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.white,
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3)),
                ],
              ),
              child: buildGenerateButton(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGenerateButton(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: 20.w, top: 0, right: 20.w, bottom: 30.h),
          child: GradientButton(
            text: 'สร้างเสียง',
            onPressed: () async {
              try {
                if (textController.text.isNotEmpty) {
                  setState(() {
                    audioPlayer.stop();
                  });
                  await generateAudio(textController.text).then((_) {
                    if (audioUrl.isNotEmpty) {
                      downloadFile();
                    }
                  });
                }
              } catch (e) {
                debugPrint("Error: $e");
              }
            },
          ),
        ),
      ],
    );
  }

  Future<String> generateAudio(String text) async {
    setState(() {
      audioUrl = '';
    });

    final auth = Provider.of<Authentication>(context, listen: false);

    String url = "https://api-voice.botnoi.ai/openapi/v1/generate_audio";
    Map<String, dynamic> payload = {
      "text": text,
      "speaker": speakerId,
      "volume": 1,
      "speed": 1,
      "type_media": selectedTypeMedia,
      "save_file": true,
    };

    Map<String, String> headers = {
      'Botnoi-Token': '${auth.credentialsToken}',
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
          audioUrl = jsonData['audio_url'];
        });
      }
    } catch (e) {
      debugPrint("Error:$e");
    }
    return audioUrl;
  }

  String randomString(int length) {
    const characters = '0123456789';

    final random = Random();
    return String.fromCharCodes(Iterable.generate(length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }

  Future<void> downloadFile() async {
    if (Platform.isAndroid) {
      await _androidDownloadFunction();
    } else if (Platform.isIOS) {
      await _iOSDownloadFunction();
    }
  }

  Future<void> _iOSDownloadFunction() async {
    try {
      String url = audioUrl;
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        String filename = "BotnoiVoice${randomString(6)}.$selectedTypeMedia";
        var tempDir = await getTemporaryDirectory();
        var path = '${tempDir.path}/$filename';
        var file = File(path);
        await file.writeAsBytes(response.bodyBytes);
        OpenAppFile.open(path);
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<void> _androidDownloadFunction() async {
    try {
      var filename = "BotnoiVoice${randomString(6)}.$selectedTypeMedia";
      List<Directory>? directories =
          await getExternalStorageDirectories(type: StorageDirectory.downloads);
      if (directories == null || directories.isEmpty) {
        throw Exception('No external storage directories found');
      }
      String directoryPath = directories.first.path;
      String filePath = "$directoryPath/$filename";
      var file = File(filePath);
      String url = audioUrl;
      var res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        await file.writeAsBytes(res.bodyBytes);
        OpenAppFile.open(filePath);
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
