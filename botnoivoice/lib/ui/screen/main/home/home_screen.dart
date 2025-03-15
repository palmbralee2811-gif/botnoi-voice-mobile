import 'package:botnoivoice/function/generate_audio.dart';
import 'package:botnoivoice/function/open_audio_player.dart';
import 'package:botnoivoice/ui/style/style.dart';
import 'package:botnoivoice/function/call_reload_data.dart';
import 'package:botnoivoice/function/random_string.dart';
import 'package:botnoivoice/ui/screen/main/home/appbar_top.dart';
import 'package:botnoivoice/ui/screen/drawer/drawer_appbar.dart';
import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/ui/dialog/notification/notification_dialog.dart';
import 'package:botnoivoice/ui/widget/gradient/gradient_icon.dart';
import 'package:botnoivoice/ui/widget/gradient/gradient_row.dart';
import 'package:botnoivoice/ui/widget/gradient/gradient_text.dart';
import 'package:botnoivoice/ui/dialog/notification/notification_popup.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:botnoivoice/auth/internet_checker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = TextEditingController();
  final InternetChecker _internetChecker = InternetChecker();

  // Audio URL
  final String _audioUrl = '';

  /// For debugging
  final _logger = Logger();

  /// Show Clear Icon
  bool _isShowClearIcon = false;

  /// Generate Audio
  bool _isGenerateAudio = false;

  /// Play Example Audio
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Show Quota Download Dialog Before Generating Audio
  bool _hasShownQuotaDialog = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _internetChecker.startListeningToInternetChanges(context, (isAvailable) {
        _logger.d("internet change in home : $isAvailable");
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _internetChecker.cancelListener();
    super.dispose();
  }

  Future<void> _generateAudio() async {
    final creditsProvider = Provider.of<CallReloadData>(context, listen: false);
    setState(() {
      _isGenerateAudio = true;
    });

    await _audioPlayer.stop();
    if (_textController.text.isEmpty) {
      NotificationPopup(
              context: context,
              text: 'home_screen.please_type_message'.tr()) //กรุณาพิมพ์ข้อความ
          .showAsError();
      setState(() {
        _isGenerateAudio = false;
      });
      return;
    }

    if (creditsProvider.remainingQuotaDownload == "0" &&
        !_hasShownQuotaDialog) {
      _hasShownQuotaDialog = true; // Show dialog only once
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
      _isGenerateAudio = false;
    });
  }

  Future<void> _generateAudioConfirmed() async {
    final creditsProvider = Provider.of<CallReloadData>(context, listen: false);

    if (_textController.text.isNotEmpty) {
      final String audioUrl = await generateAudio(
        context,
        _textController.text,
        _audioUrl,
        _isGenerateAudio,
      );
      await creditsProvider.callLoadCreditsApi(context);
      if (audioUrl.isNotEmpty) {
        await openAudioPlayerDialog(
          context,
          audioUrl,
          "BotnoiVoice${randomStringOfNumbers(6)}.mp3",
        );
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
            height: ResponsiveDesignOrientation.isLandscape ? 75.h : 90.h,
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
            width: ResponsiveDesignOrientation.isLandscape ? 250.w : 288.w,
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
                  left: ResponsiveDesignOrientation.isLandscape ? 20.w : 30.w,
                  right: ResponsiveDesignOrientation.isLandscape ? 0.w : 10.w,
                  top: ResponsiveDesignOrientation.isLandscape ? 5.w : 20.w),
              child: Column(
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: const Color(0xFF000000),
                      style: GoogleFonts.prompt(
                        fontSize: ResponsiveDesignOrientation.isLandscape
                            ? 8.sp
                            : 14.sp,
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
                          _isShowClearIcon = _textController.text.isNotEmpty;
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
                                  fontSize:
                                      ResponsiveDesignOrientation.isLandscape
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
      padding: EdgeInsets.only(
          right: ResponsiveDesignOrientation.isLandscape ? 15.w : 25.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _isShowClearIcon
                  ? Padding(
                      padding: EdgeInsets.only(right: 1.w),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            textStyle: TextStyle(
                                fontSize:
                                    ResponsiveDesignOrientation.isLandscape
                                        ? 5.sp
                                        : 10.sp)),
                        onPressed: () {
                          setState(() {
                            _textController.clear();
                            _isShowClearIcon = false;
                          });
                        },
                        child: GradientIcon(
                          icon: Icons.close_sharp,
                          size: ResponsiveDesignOrientation.isLandscape
                              ? 10.sp
                              : 20.sp,
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
                                fontSize:
                                    ResponsiveDesignOrientation.isLandscape
                                        ? 12.sp
                                        : 10.sp)),
                        onPressed: () {},
                        child: Icon(
                          Icons.close_sharp,
                          size: ResponsiveDesignOrientation.isLandscape
                              ? 10.sp
                              : 20.sp,
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
                  fontSize:
                      ResponsiveDesignOrientation.isLandscape ? 8.sp : 14.sp,
                  color: const Color(0xFFA19F9D),
                ),
                gradient: const LinearGradient(
                  colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                ),
              ),
              Text(
                ' / 1000',
                style: GoogleFonts.prompt(
                  fontSize:
                      ResponsiveDesignOrientation.isLandscape ? 8.sp : 14.sp,
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
          left: ResponsiveDesignOrientation.isLandscape ? 60.w : 20.w,
          top: ResponsiveDesignOrientation.isLandscape ? 10.h : 15.h,
          right: ResponsiveDesignOrientation.isLandscape ? 60.w : 20.w,
          bottom: ResponsiveDesignOrientation.isLandscape ? 10.h : 15.h),
      child: GradientRow(
        onPressed:
            _isGenerateAudio ? () {} : () async => await _generateAudio(),
        child: _isGenerateAudio
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('home_screen.create_sound'.tr(), //สร้างเสียง
                      style: GoogleFonts.prompt(
                          color: Colors.white,
                          fontSize: ResponsiveDesignOrientation.isLandscape
                              ? 11.sp
                              : 16.sp,
                          fontWeight: FontWeight.w600)),
                  SizedBox(
                      width:
                          ResponsiveDesignOrientation.isLandscape ? 5.w : 10.w),
                  SvgPicture.asset(
                    'assets/images/logo/credit-icon.svg',
                    height:
                        ResponsiveDesignOrientation.isLandscape ? 40.h : 20.h,
                    width:
                        ResponsiveDesignOrientation.isLandscape ? 40.w : 20.w,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    '${_textController.text.length}',
                    style: GoogleFonts.prompt(
                        color: Colors.white,
                        fontSize: ResponsiveDesignOrientation.isLandscape
                            ? 11.sp
                            : 16.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }
}
