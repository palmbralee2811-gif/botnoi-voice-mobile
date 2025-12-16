import 'package:botnoivoice/auth/internet_checker.dart';
import 'package:botnoivoice/screen/main/home/widget/home_header.dart';
import 'package:botnoivoice/screen/main/home_speaker_data_management.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:botnoivoice/screen/main/home/function/generate_audio.dart';
import 'package:botnoivoice/screen/main/home/function/open_audio_player.dart';
import 'package:botnoivoice/screen/main/home/function/random_string.dart';
import 'package:botnoivoice/shared/dialog/notification/notification_popup.dart';
import 'package:botnoivoice/screen/drawer/drawer_appbar.dart';
import 'package:botnoivoice/shared/widget/gradient/gradient_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _textController = TextEditingController();
  final InternetChecker _internetChecker = InternetChecker();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final _logger = Logger();

  // ignore: unused_field
  final String _audioUrl = '';
  bool _isShowClearIcon = false;
  bool _isGenerateAudio = false;

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
  void dispose() {
    _internetChecker.cancelListener();
    _textController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _generateAudio() async {
    if (mounted) setState(() => _isGenerateAudio = true);
    await _audioPlayer.stop();

    if (_textController.text.isEmpty) {
      if (mounted) {
        NotificationPopup(
                context: context, text: 'home_screen.please_type_message'.tr())
            .showAsError();
        setState(() => _isGenerateAudio = false);
      }
      return;
    }

    try {
      final bool isSuccess = await _generateAudioConfirmed();

      if (!isSuccess) {
        if (mounted) setState(() => _isGenerateAudio = false);
        return;
      }

      if (mounted) await loadAllTokensIfLoggedIn(ref);

      if (mounted) {
        setState(() => _isGenerateAudio = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_rounded,
                    color: Colors.white, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  'Successfully Updated Points',
                  style:
                      GoogleFonts.prompt(color: Colors.white, fontSize: 12.sp),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r)),
          ),
        );
      }
    } catch (e) {
      _logger.e("Error: $e");
      if (mounted) {
        setState(() => _isGenerateAudio = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<bool> _generateAudioConfirmed() async {
    final speakerProvider = ref.read(homeSpeakerDataProvider.notifier);
    if (_textController.text.isNotEmpty) {
      final String audioUrl = await generateAudio(
        ref: ref,
        text: _textController.text,
        audioUrl: _audioUrl,
        isGenerateAudio: _isGenerateAudio,
        isV2: speakerProvider.isV2,
      );

      if (audioUrl.isNotEmpty) {
        await openAudioPlayerDialog(
          context,
          audioUrl,
          "BotnoiVoice${randomStringOfNumbers(6)}.mp3",
        );
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Logic for Scaling UI on Tablet Landscape
    bool isTablet = MediaQuery.of(context).size.shortestSide > 550;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double scaleFactor = (isTablet && isLandscape) ? 0.65 : 1.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      resizeToAvoidBottomInset: true,
      drawer: const DrawerAppbar(),
      body: Column(
        children: [
          // 1. Header (รวม AppBarTop + Bottom)
          const HomeHeader(),

          // 2. Text Input Area
          Expanded(
            child: Padding(
              // เพิ่ม Padding ด้านข้างเยอะขึ้นใน Tablet เพื่อให้ดูสมมาตร ไม่กว้างเกินไป
              padding: EdgeInsets.symmetric(
                horizontal: isTablet && isLandscape ? 80.w : 20.w,
                vertical: 16.h * scaleFactor,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r * scaleFactor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        cursorColor: Colors.blueAccent,
                        style: GoogleFonts.prompt(
                          fontSize: 16.sp * scaleFactor,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        onChanged: (text) {
                          if (text.length > 1000) {
                            _textController.text = text.substring(0, 1000);
                            _textController.selection =
                                TextSelection.fromPosition(
                              TextPosition(offset: _textController.text.length),
                            );
                          }
                          setState(() => _isShowClearIcon = text.isNotEmpty);
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(20.w * scaleFactor),
                          hintText:
                              'home_screen.type_message_in_selected_language'
                                  .tr(),
                          hintStyle: GoogleFonts.prompt(
                            color: Colors.grey[400],
                            fontSize: 16.sp * scaleFactor,
                          ),
                        ),
                      ),
                    ),

                    // --- Character Counter & Clear Button ---
                    _buildBottomTextBox(scaleFactor),
                  ],
                ),
              ),
            ),
          ),

          // 3. Generate Button Area
          _buildGenerateButtonArea(isTablet, isLandscape, scaleFactor),
        ],
      ),
    );
  }

  Widget _buildBottomTextBox(double scaleFactor) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 16.w * scaleFactor, vertical: 8.h * scaleFactor),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Clear Button
          AnimatedOpacity(
            opacity: _isShowClearIcon ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              onPressed: _isShowClearIcon
                  ? () {
                      setState(() {
                        _textController.clear();
                        _isShowClearIcon = false;
                      });
                    }
                  : null,
              icon: Icon(Icons.clear_rounded,
                  color: Colors.grey[400], size: 20.sp * scaleFactor),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),

          // Counter
          Row(
            children: [
              GradientText(
                text: '${_textController.text.length}',
                style: GoogleFonts.prompt(
                  fontSize: 12.sp * scaleFactor,
                  fontWeight: FontWeight.w600,
                ),
                gradient: const LinearGradient(
                  colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                ),
              ),
              Text(
                ' / 1000',
                style: GoogleFonts.prompt(
                  fontSize: 12.sp * scaleFactor,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButtonArea(
      bool isTablet, bool isLandscape, double scaleFactor) {
    return Container(
      width: double.infinity,
      // เพิ่ม Padding ให้ปุ่มไม่ชิดขอบจอเกินไปใน Tablet
      padding: EdgeInsets.symmetric(
        horizontal: isTablet && isLandscape ? 80.w : 20.w,
        vertical: 20.h * scaleFactor,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56.h * scaleFactor,
          child: ElevatedButton(
            onPressed: _isGenerateAudio ? null : _generateAudio,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r * scaleFactor)),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16.r * scaleFactor),
              ),
              child: Container(
                alignment: Alignment.center,
                child: _isGenerateAudio
                    ? SizedBox(
                        width: 24.w * scaleFactor,
                        height: 24.w * scaleFactor,
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          strokeWidth: 2.5,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome_rounded,
                              color: Colors.white, size: 20.sp * scaleFactor),
                          SizedBox(width: 8.w * scaleFactor),
                          Text(
                            'home_screen.create_sound'.tr(),
                            style: GoogleFonts.prompt(
                              fontSize: 16.sp * scaleFactor,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12.w * scaleFactor),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w * scaleFactor,
                                vertical: 4.h * scaleFactor),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius:
                                  BorderRadius.circular(20.r * scaleFactor),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/logo/credit-icon.svg',
                                  width: 14.w * scaleFactor,
                                  height: 14.w * scaleFactor,
                                ),
                                SizedBox(width: 4.w * scaleFactor),
                                Text(
                                  '${_textController.text.length}',
                                  style: GoogleFonts.prompt(
                                    fontSize: 12.sp * scaleFactor,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
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
        ),
      ),
    );
  }
}