import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:botnoivoice/Screens/AllSpeakerScreen/speaker_provider.dart';
import 'package:botnoivoice/Screens/AppBarScreen/appbar_bottom_navbar.dart';
import 'package:botnoivoice/Screens/AppBarScreen/appbar_screen.dart';
import 'package:botnoivoice/Screens/AppBarScreen/credits_provider.dart';
import 'package:botnoivoice/Screens/DrawerAppBarScreen/drawer_appbar_screen.dart';
import 'package:botnoivoice/Screens/GradientScreen/gradient_button.dart';
import 'package:botnoivoice/Screens/GradientScreen/gradient_icon.dart';
import 'package:botnoivoice/Screens/GradientScreen/gradient_text.dart';
import 'package:botnoivoice/Screens/HomeScreen/audio_player_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController textController = TextEditingController();

  /// Generate Audio
  String response = '';
  String audioUrl = '';
  String? speakerId;

  /// Player Audio
  bool isShowClearIcon = false;

  /// Show Clear Icon
  AudioPlayer audioPlayer = AudioPlayer(); // Play Example Audio

  /// Show Audio Player
  Duration duration = Duration.zero;
  Duration currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    speakerId = Provider.of<SpeakerProvider>(context).speakerId;
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
          child: const AppbarBottomNavbar(),
        ),
      ),
      body: Stack(
        children: [
          buildTextBox(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
                width: 320.w,
                color: Colors.white,
                child: buildGenerateButton(context)),
          ),
        ],
      ),
    );
  }

  Widget buildTextBox() {
    return SizedBox(
      child: Column(
        children: <Widget>[
          Container(
            width: 320.w,
            height: 480.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB1E9FD), Color(0xFFF9D8FD)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
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
                      padding:
                          EdgeInsets.only(left: 25.w, right: 10.w, top: 20.w),
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
                              if (textController.text.length > 1000) {
                                textController.text =
                                    textController.text.substring(0, 1000);
                                textController.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(
                                      offset: textController.text.length),
                                );
                              }
                              setState(() {
                                isShowClearIcon =
                                    textController.text.isNotEmpty;
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  'พิมพ์ข้อความให้ตรงกับภาษาที่เลือก . . .',
                              hintStyle: TextStyle(
                                color: const Color(0xFFA19F9D),
                                fontStyle: GoogleFonts.prompt(fontSize: 14.sp)
                                    .fontStyle,
                              ),
                              hintMaxLines: 1,
                            ),
                          ),
                          buildBottomTextBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomTextBox() {
    return Padding(
      padding: EdgeInsets.only(right: 25.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isShowClearIcon
                  ? Padding(
                      padding: EdgeInsets.only(right: 1.w),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            textStyle: TextStyle(fontSize: 10.sp)),
                        onPressed: () {
                          setState(() {
                            textController.clear();
                            isShowClearIcon = false;
                          });
                        },
                        child: GradientIcon(
                          icon: Icons.close_sharp,
                          size: 20.sp,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(right: 1.w),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            textStyle: TextStyle(fontSize: 10.sp)),
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
                text: '${textController.text.length}',
                style: GoogleFonts.prompt(
                  fontSize: 14.sp,
                  color: const Color(0xFFA19F9D),
                ),
                gradient: const LinearGradient(
                  colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                ),
              ),
              Text(
                ' / 1000',
                style: GoogleFonts.prompt(
                  fontSize: 14.sp,
                  color: const Color(0xFFA19F9D),
                ),
              ),
            ],
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
              EdgeInsets.only(left: 20.w, top: 15.h, right: 20.w, bottom: 15.h),
          child: GradientButton(
            text: 'สร้างเสียง',
            onPressed: () async {
              if (textController.text.isNotEmpty) {
                setState(() {
                  audioPlayer.stop();
                  // Show loading indicator here
                });
                try {
                  final audioUrl = await generateAudio(textController.text);
                  if (audioUrl.isNotEmpty) {
                    await openFile(
                        url: audioUrl,
                        fileName: "BotnoiVoice${randomString(6)}.mp3");

                    final creditsProvider =
                        Provider.of<CreditsProvider>(context, listen: false);
                    final auth =
                        Provider.of<Authentication>(context, listen: false);
                    creditsProvider.fetchCredits(auth);
                  }
                } catch (e) {
                  debugPrint("Error: $e");
                } finally {
                  setState(() {
                    // Hide loading indicator here
                  });
                }
              }
            },
          ),
        ),
      ],
    );
  }

  Future<String> generateAudio(String text) async {
    final auth = Provider.of<Authentication>(context, listen: false);
    speakerId =
        Provider.of<SpeakerProvider>(context, listen: false).speakerId ?? '1';

    String url = "https://api-voice.botnoi.ai/openapi/v1/generate_audio";
    Map<String, dynamic> payload = {
      "text": text,
      "speaker": speakerId,
      "volume": 1,
      "speed": 1,
      "type_media": "mp3",
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
          debugPrint("generateAudio -> $audioUrl");
        });
      } else {
        throw Exception("Failed to generate audio: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to generate audio: $e");
    }
    return audioUrl;
  }

  String randomString(int length) {
    const characters = '0123456789';

    final random = Random();
    return String.fromCharCodes(Iterable.generate(length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }

  Future openFile({required String url, String? fileName}) async {
    try {
      final name = fileName ?? url.split("/").last;
      final file = await downloadFile(url, name);
      if (file == null) return;
      debugPrint("Path: ${file.path}");
      await showDialog(
        context: context,
        builder: (context) => AudioPlayerDialog(filePath: file.path),
      );
    } catch (e) {
      throw Exception("Failed to open file: $e");
    }
  }

  Future<File?> downloadFile(String url, String name) async {
    try {
      String? downloadDirectory;
      if (Platform.isAndroid) {
        final externalStorageFolder = await getExternalStorageDirectory();
        if (externalStorageFolder != null) {
          downloadDirectory = p.join(externalStorageFolder.path, "Downloads");

          // Ensure the directory exists
          final directory = Directory(downloadDirectory);
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
        } else {
          // Fallback to common Download directory
          downloadDirectory = "/storage/emulated/0/Download";
        }
      } else if (Platform.isIOS) {
        final downloadFolder = await getDownloadsDirectory();
        if (downloadFolder != null) {
          downloadDirectory = downloadFolder.path;
        }
      }

      if (downloadDirectory == null) {
        throw Exception("Download directory not found.");
      }

      final file = File("$downloadDirectory/$name");

      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      if (response.statusCode == 200) {
        final raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        await raf.close();

        if (await file.exists() && await file.length() > 0) {
          return file;
        } else {
          throw Exception("File download failed, file is empty.");
        }
      } else {
        throw Exception("Failed to download file: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Download file error: $e");
      return null;
    }
  }
}
