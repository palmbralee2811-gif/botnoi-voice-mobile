import 'dart:convert';
import 'dart:io';
import 'package:botnoivoice/data/repositories/speaker_repository_impl.dart';
import 'package:botnoivoice/presentation/configurations/api_url_config.dart';
import 'package:botnoivoice/presentation/constants/styles.dart';
import 'package:botnoivoice/presentation/providers/apple/apple_token_provider.dart';
import 'package:botnoivoice/presentation/providers/credits/credits_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_token_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_token_provider.dart';
import 'package:botnoivoice/data/functions/random_string.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_token_provider.dart';
import 'package:botnoivoice/presentation/screens/appbar/appbar_top.dart';
import 'package:botnoivoice/presentation/screens/drawer/drawer_appbar.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:botnoivoice/presentation/widgets/dialog/notification/notification_dialog.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_icon.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_row.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text.dart';
import 'package:botnoivoice/presentation/widgets/dialog/audio_player/audio_player_dialog.dart';
import 'package:botnoivoice/presentation/widgets/popup/notification_popup.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = TextEditingController();
  final Logger logger = Logger();
  bool isGenerateAudio = false;

  // Generate Audio
  String response = '';
  String audioUrl = '';
  String? speakerId;

  // Show Clear Icon
  bool isShowClearIcon = false;

  // Play Example Audio
  AudioPlayer audioPlayer = AudioPlayer();

  // Show Audio Player
  Duration duration = Duration.zero;
  Duration currentPosition = Duration.zero;

  // Show Quota Download Dialog Before Generating Audio
  bool hasShownQuotaDialog = false;

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
    _textController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _generateAudio() async {
    final creditsProvider =
        Provider.of<CreditsProvider>(context, listen: false);
    setState(() {
      isGenerateAudio = true;
    });

    await audioPlayer.stop();
    if (_textController.text.isEmpty) {
      NotificationPopup(
              context: context,
              text: 'home_screen.please_type_message'.tr()) //กรุณาพิมพ์ข้อความ
          .showAsError();
      setState(() {
        isGenerateAudio = false;
      });
      return;
    }

    if (creditsProvider.remainingQuotaDownload == "0" && !hasShownQuotaDialog) {
      hasShownQuotaDialog = true; // Show dialog only once
      NotificationDialog(
        context: context,
        text: tr(
            'free_quota_use.ten_time_perday'), //คุณใช้โควต้าฟรี 10 ครั้ง/วันครบแล้ว หลังจาก นี้ระบบจะเริ่มหักพ้อยท์ตามการใช้งาน
        onPressed: () {},
      ).showCheckmarkModalWithAction(context);
    } else {
      await _generateAudioConfirmed();
    }

    setState(() {
      isGenerateAudio = false;
    });
  }

  Future<void> _generateAudioConfirmed() async {
    final creditsProvider =
        Provider.of<CreditsProvider>(context, listen: false);

    if (_textController.text.isNotEmpty) {
      final audioUrl = await generateAudio(_textController.text);
      await creditsProvider.callLoadCreditsApi(context);
      if (audioUrl.isNotEmpty) {
        await openAudioPlayerDialog(
            url: audioUrl,
            fileName: "BotnoiVoice${randomStringOfNumbers(6)}.mp3");
      }
    }
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
            height: OrientationHelper.isLandscape ? 75.h : 90.h,
            child: buildGenerateButton(context),
          ),
        ],
      ),
    );
  }

  Widget buildTextBox() {
    return Container(
      width: 320.w,
      height: 80.h,
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
            width: OrientationHelper.isLandscape ? 250.w : 288.w,
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
                  left: OrientationHelper.isLandscape ? 20.w : 30.w,
                  right: OrientationHelper.isLandscape ? 0.w : 10.w,
                  top: OrientationHelper.isLandscape ? 5.w : 20.w),
              child: Column(
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: const Color(0xFF000000),
                      style: GoogleFonts.prompt(
                        fontSize: OrientationHelper.isLandscape ? 8.sp : 14.sp,
                        color: kDark,
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      controller: _textController,
                      onChanged: (text) {
                        if (_textController.text.length > 1000) {
                          _textController.text =
                              _textController.text.substring(0, 1000);
                          _textController.selection =
                              TextSelection.fromPosition(
                            TextPosition(offset: _textController.text.length),
                          );
                        }
                        setState(() {
                          isShowClearIcon = _textController.text.isNotEmpty;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            'home_screen.type_message_in_selected_language'
                                .tr(), //พิมพ์ข้อความให้ตรงกับภาษาที่เลือก . . .
                        hintStyle: TextStyle(
                          color: const Color(0xFFA19F9D),
                          fontStyle: GoogleFonts.prompt(
                                  fontSize: OrientationHelper.isLandscape
                                      ? 8.sp
                                      : 14.sp)
                              .fontStyle,
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
      padding:
          EdgeInsets.only(right: OrientationHelper.isLandscape ? 15.w : 25.w),
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
                            textStyle: TextStyle(
                                fontSize: OrientationHelper.isLandscape
                                    ? 5.sp
                                    : 10.sp)),
                        onPressed: () {
                          setState(() {
                            _textController.clear();
                            isShowClearIcon = false;
                          });
                        },
                        child: GradientIcon(
                          icon: Icons.close_sharp,
                          size: OrientationHelper.isLandscape ? 10.sp : 20.sp,
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
                            textStyle: TextStyle(
                                fontSize: OrientationHelper.isLandscape
                                    ? 12.sp
                                    : 10.sp)),
                        onPressed: () {},
                        child: Icon(
                          Icons.close_sharp,
                          size: OrientationHelper.isLandscape ? 10.sp : 20.sp,
                          color: Colors.transparent,
                        ),
                      ),
                    )
            ],
          ),
          Row(
            children: [
              GradientText(
                text: '${_textController.text.length}',
                style: GoogleFonts.prompt(
                  fontSize: OrientationHelper.isLandscape ? 8.sp : 14.sp,
                  color: const Color(0xFFA19F9D),
                ),
                gradient: const LinearGradient(
                  colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                ),
              ),
              Text(
                ' / 1000',
                style: GoogleFonts.prompt(
                  fontSize: OrientationHelper.isLandscape ? 8.sp : 14.sp,
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
      padding: EdgeInsets.only(
          left: OrientationHelper.isLandscape ? 60.w : 20.w,
          top: OrientationHelper.isLandscape ? 10.h : 15.h,
          right: OrientationHelper.isLandscape ? 60.w : 20.w,
          bottom: OrientationHelper.isLandscape ? 10.h : 15.h),
      child: GradientRow(
        onPressed: isGenerateAudio ? () {} : () async => await _generateAudio(),
        child: isGenerateAudio
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('home_screen.create_sound'.tr(), //สร้างเสียง
                      style: GoogleFonts.prompt(
                          color: Colors.white,
                          fontSize:
                              OrientationHelper.isLandscape ? 11.sp : 16.sp,
                          fontWeight: FontWeight.w600)),
                  SizedBox(width: OrientationHelper.isLandscape ? 5.w : 10.w),
                  SvgPicture.asset(
                    'assets/images/logo/credit-icon.svg',
                    height: OrientationHelper.isLandscape ? 40.h : 20.h,
                    width: OrientationHelper.isLandscape ? 40.w : 20.w,
                  ),
                  SizedBox(width: 5.w),
                  Text('${_textController.text.length}',
                      style: GoogleFonts.prompt(
                          color: Colors.white,
                          fontSize:
                              OrientationHelper.isLandscape ? 11.sp : 16.sp,
                          fontWeight: FontWeight.w600)),
                ],
              ),
      ),
    );
  }

  /// Generate audio from text
  Future<String> generateAudio(String text) async {
    //TODO: TN Mobile S
    //TODO: กำหนดค่าเริ่มต้น เป็นตัวแปรใหม่ เช่น defaultSpeakerId, defaultLanguage ให้รองรับการเปลี่ยนภาษาเป็น 'th', 'en', 'id'
    speakerId =
        Provider.of<SpeakerRepositoryImpl>(context, listen: false).speakerId ??
            '1';
    String language =
        Provider.of<SpeakerRepositoryImpl>(context, listen: false).language ??
            'th';
    String? appleCredentialsToken =
        Provider.of<AppleTokenProvider>(context, listen: false)
            .getCredentialsToken;
    String? googleCredentialsToken =
        Provider.of<GoogleTokenProvider>(context, listen: false)
            .getCredentialsToken;
    String? lineCredentialsToken =
        Provider.of<LineTokenProvider>(context, listen: false)
            .getCredentialsToken;
    String? emailCredentialsToken =
        Provider.of<EmailTokenProvider>(context, listen: false)
            .getCredentialsToken;

    logger.i("speakerId: $speakerId");
    logger.i("language: $language");
    logger.i("Apple-credentialsToken: $appleCredentialsToken");
    logger.i("Google-credentialsToken: $googleCredentialsToken");
    logger.i("LINE-credentialsToken: $lineCredentialsToken");
    logger.i("Email-credentialsToken: $emailCredentialsToken");

    String url = "$apiUrl/openapi/v1/generate_audio";
    Map<String, dynamic> payload = {
      "text": text,
      "speaker": speakerId,
      "volume": 1,
      "speed": 1,
      "type_media": "mp3",
      "save_file": true,
      "language": language,
      "page": "mobile"
    };

    // Determine which token to use in the headers
    String? selectedToken;
    if (Provider.of<LineLoginProvider>(context, listen: false).isLoggedIn) {
      selectedToken = lineCredentialsToken;
    } else if (appleCredentialsToken != null &&
        appleCredentialsToken.isNotEmpty) {
      selectedToken = appleCredentialsToken;
    } else if (googleCredentialsToken != null &&
        googleCredentialsToken.isNotEmpty) {
      selectedToken = googleCredentialsToken;
    } else if (emailCredentialsToken != null &&
        emailCredentialsToken.isNotEmpty) {
      selectedToken = emailCredentialsToken;
    } else {
      selectedToken = ''; // Default or fallback if no token is found
    }

    Map<String, String> headers = {
      'Botnoi-Token': selectedToken ?? '',
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
        audioUrl = jsonData['audio_url'];
        logger.i("generateAudio -> $audioUrl");
      } else {
        setState(() {
          isGenerateAudio = false;
          audioUrl = '';
        });
        logger.e("Failed to generate audio: ${response.statusCode}");
        if (mounted) {
          NotificationPopup(
                  context: context,
                  text: 'home_screen.unable_to_create_sound'
                      .tr()) //ไม่สามารสร้างเสียงได้
              .showAsError();
        }
      }
    } catch (e) {
      logger.e("Error on generateAudio: $e");
    }
    return audioUrl;
  }

  /// Request Permission, Call download function, Open audio player, and open audio file
  Future openAudioPlayerDialog({required String url, String? fileName}) async {
    try {
      final name = fileName ?? url.split("/").last;
      final file = await downloadFileToTemporaryDirectory(url, name);
      if (file == null) return;
      logger.i("Path: ${file.path}");

      await showDialog(
        context: context,
        builder: (context) =>
            AudioPlayerDialog(filePath: file.path, audioUrl: audioUrl),
      );
    } catch (e) {
      logger.e("Failed to open file: $e");
    }
  }

  /// Download file and save to temporary directory
  Future<File?> downloadFileToTemporaryDirectory(
      String url, String name) async {
    try {
      final downloadFolder = await getTemporaryDirectory();
      final String downloadDirectory = downloadFolder.path;
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
          logger.i("File downloaded successfully: ${file.path}");
          return file;
        } else {
          throw Exception("File download failed, file is empty.");
        }
      } else {
        throw Exception("Failed to download file: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("Download file error: $e");
      return null;
    }
  }
}
