import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:botnoivoice/data/repositories/speaker_repository_impl.dart';
import 'package:botnoivoice/data/repositories/token_manager.dart';
import 'package:botnoivoice/presentation/screens/appbar/appbar_top.dart';
import 'package:botnoivoice/presentation/screens/drawer/drawer_appbar.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_icon.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_row.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text.dart';
import 'package:botnoivoice/presentation/widgets/dialog/audio_player_dialog.dart';
import 'package:botnoivoice/presentation/widgets/dialog/error_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
    speakerId = Provider.of<SpeakerRepositoryImpl>(context).speakerId;
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
      drawer: const DrawerAppbar(),
      appBar: const AppBarTop(),
      body: Column(
        children: [
          Expanded(
            child: buildTextBox(),
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            child: buildGenerateButton(context),
          ),
        ],
      ),
    );
  }

  Widget buildTextBox() {
    return Container(
      width: 320.w,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB1E9FD), Color(0xFFF9D8FD)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Center(
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
              padding: EdgeInsets.only(left: 25.w, right: 10.w, top: 20.w),
              child: Column(
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: const Color(0xFF000000),
                      style: GoogleFonts.prompt(
                        fontSize: 14.sp,
                        color: const Color(0xFF323130),
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      controller: textController,
                      onChanged: (text) {
                        if (textController.text.length > 1000) {
                          textController.text =
                              textController.text.substring(0, 1000);
                          textController.selection = TextSelection.fromPosition(
                            TextPosition(offset: textController.text.length),
                          );
                        }
                        setState(() {
                          isShowClearIcon = textController.text.isNotEmpty;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'พิมพ์ข้อความให้ตรงกับภาษาที่เลือก . . .',
                        hintStyle: TextStyle(
                          color: const Color(0xFFA19F9D),
                          fontStyle:
                              GoogleFonts.prompt(fontSize: 14.sp).fontStyle,
                        ),
                        hintMaxLines: 1,
                      ),
                    ),
                  ),
                  buildBottomTextBox(),
                ],
              ),
            ),
          ),
        ),
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
    return Padding(
      padding:
          EdgeInsets.only(left: 20.w, top: 15.h, right: 20.w, bottom: 15.h),
      child: GradientRow(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'สร้างเสียง',
              style: GoogleFonts.prompt(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600)
            ),
            SizedBox(width: 10.w),
            SvgPicture.asset(
              'assets/images/logo/credit-icon.svg',
              height: 20.h,
              width: 20.w,
            ),
            SizedBox(width: 5.w),
            Text(
              '${textController.text.length}',
              style: GoogleFonts.prompt(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600)
            ),
          ],
        ),
        onPressed: () async {
          if (textController.text.isNotEmpty) {
            setState(() {
              audioPlayer.stop();
            });
            try {
              final audioUrl = await generateAudio(textController.text);
              if (audioUrl.isNotEmpty) {
                await openFile(
                    url: audioUrl,
                    fileName: "BotnoiVoice${randomString(6)}.mp3");
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
    );
  }

  Future<String> generateAudio(String text) async {
    speakerId =
        Provider.of<SpeakerRepositoryImpl>(context, listen: false).speakerId ??
            '1';

    //TODO:// Set new SpeakerProvider for language value
    String language =
        Provider.of<SpeakerRepositoryImpl>(context, listen: false).language ??
            'th';

    String url = "https://api-voice.botnoi.ai/openapi/v1/generate_audio";
    // String url = "https://api-voice-staging.botnoi.ai/openapi/v1/generate_audio";
    Map<String, dynamic> payload = {
      "text": text,
      "speaker": speakerId,
      "volume": 1,
      "speed": 1,
      "type_media": "mp3",
      "save_file": true,
      //TODO: Get language from selected language
      // "language": language,
      // "page": "mobile app"
    };

    Map<String, String> headers = {
      'Botnoi-Token':
          '${Provider.of<TokenManager>(context, listen: false).credentialsToken}',
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
        debugPrint("Failed to generate audio: ${response.statusCode}");
        ErrorDialog.showErrorDialog(
            context, 'กรุณาพิมพ์ข้อความตรงกับภาษาที่ท่านเลือกด้วยครับ');
      }
    } catch (e) {
      debugPrint("Error: $e");
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

      //TODO: สร้างเสร็จแล้ว กดปุ่มเล่นเสียงซ้ำ แล้ว point โดยครั้งทุกครั้งที่เล่นเสียง
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

          final directory = Directory(downloadDirectory);
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
        } else {
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
