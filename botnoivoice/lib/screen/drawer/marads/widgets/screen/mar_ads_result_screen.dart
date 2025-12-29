import 'dart:math';
import 'package:botnoivoice/screen/drawer/marads/widgets/logic/mar_ads_download_logic.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/service/generate_audio_marads.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/service/prompt_service.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/mar_ads_audio_player_dialog.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/mar_ads_download_options_dialog.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/mar_ads_loading_dialog.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/models/mar_ads_speaker_selection_modal.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/mar_ads_speaker_selector_button.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/mar_ads_success_dialog.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/marads_ui_style.dart';
import 'package:botnoivoice/screen/main/speaker/entities/speaker_entity.dart';
import 'package:botnoivoice/screen/main/speaker/model/speaker_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

class MarAdsResultScreen extends ConsumerStatefulWidget {
  final String? generatedText;
  final String? promptId;
  final String? contentStyle;

  const MarAdsResultScreen({
    super.key,
    this.generatedText,
    this.promptId,
    this.contentStyle,
  });

  @override
  ConsumerState<MarAdsResultScreen> createState() => _MarAdsResultScreenState();
}

class _MarAdsResultScreenState extends ConsumerState<MarAdsResultScreen> {
  late TextEditingController _textController;
  final MarAdsDownloadLogic _downloadLogic = MarAdsDownloadLogic();
  final PromptService _promptService = PromptService();
  SpeakerEntity? _selectedSpeaker;
  String _selectedMode = 'Result';
  String? _currentAudioUrl;
  String? _currentFileName;
  String? _localPromptId;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.generatedText ?? '',
    );
    _localPromptId = widget.promptId;

    // addListener เพื่อสั่ง rebuild เมื่อพิมพ์
    _textController.addListener(() {
      if (mounted) setState(() {});
    });
    _initializeDownloader();

    // กำหนดค่าเริ่มต้นให้กับ Speaker (เช่น id 1 หรือตัวแรกของ List)
    if (SpeakerModel.speakerItem.isNotEmpty) {
      // 1. ลองหาจาก ID ที่ได้รับมา (ถ้าเป็นการเปิดจากหน้า History หรือสร้างเสร็จแล้ว)
      _selectedSpeaker = SpeakerModel.speakerItem.firstWhere(
        (s) => s.speakerId == widget.promptId, // สมมติส่ง ID มาใน promptId
        orElse: () => SpeakerModel.speakerItem.firstWhere(
          (s) => s.speakerId == '1', // ถ้าไม่เจอจริงๆ ให้เป็นเอวา
          orElse: () => SpeakerModel.speakerItem.first,
        ),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _downloadLogic.dispose();
    super.dispose();
  }

  Future<void> _initializeDownloader() async {
    try {
      await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
    } catch (e) {
      // กรณี Init ซ้ำ หรือมี Error อื่นๆ ให้ปล่อยผ่านไป
      debugPrint("FlutterDownloader init warning: $e");
    }

    _downloadLogic.initialize();
  }

  int get _characterCount => _textController.text.length;

  String _generateRandomPromptId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random();
    final randomString =
        List.generate(5, (index) => chars[rnd.nextInt(chars.length)]).join();
    return 'prompt_$randomString';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildModeSelectorRow(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: _buildTextBox(),
              ),
            ),
          ),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: ResponsiveDesignOrientation.isLandscape ? 150.h : 58.h,
      title: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(
                Icons.menu,
                size: ResponsiveDesignOrientation.isLandscape ? 22.sp : 32.sp,
                color: const Color(0xFF3D3D3D),
              ),
              onPressed: () {
                context.go('/home');
              },
            ),
          ),
          Center(
            child: SvgPicture.asset(
              'assets/images/logo/appbar-icon.svg',
              width: ResponsiveDesignOrientation.isLandscape ? 30.w : 28.w,
              height: ResponsiveDesignOrientation.isLandscape ? 30.h : 28.h,
              fit: BoxFit.contain,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: _buildPointsBadge(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsBadge() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20.w,
            height: 20.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF262626),
            ),
            child: Center(
              child: ShaderMask(
                shaderCallback: (bounds) =>
                    MarAdsUIStyle.cyanPurpleGradient.createShader(bounds),
                child: Text(
                  'P',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Text(
              '100',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF262626),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelectorRow() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 5.h, 16.w, 5.h),
      color: Colors.white,
      child: Row(
        children: [
          MarAdsSpeakerSelectorButton(
            selectedSpeaker: _selectedSpeaker,
            onTap: _handleCharacterSelectorTap,
          ),
          const Spacer(),
          _buildResultSelector(),
        ],
      ),
    );
  }

  Widget _buildResultSelector() {
    return GestureDetector(
      onTap: _handleResultSelectorTap,
      child: CustomPaint(
        painter: GradientBorderPainter(
          gradient: MarAdsUIStyle.cyanPurpleGradient,
          radius: 8.r,
        ),
        child: Container(
          height: 33.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) =>
                    MarAdsUIStyle.cyanPurpleGradient.createShader(bounds),
                child: Text(
                  _selectedMode,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    height: 1.67,
                    letterSpacing: 0.25,
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              ShaderMask(
                shaderCallback: (bounds) =>
                    MarAdsUIStyle.cyanPurpleGradient.createShader(bounds),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 12.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextBox() {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: MarAdsUIStyle.cyanPurpleGradient, // ใช้ Style กลาง
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9747FF).withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300.h,
              child: TextField(
                controller: _textController,
                maxLines: null,
                expands: true,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF262626),
                  height: 1.43,
                  letterSpacing: 0.25,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _textController.clear();
                    setState(() {});
                  },
                  child: Icon(
                    Icons.close,
                    size: 24.sp,
                    color: const Color(0xFF4F4F4F),
                  ),
                ),
                Text(
                  '$_characterCount ตัวอักษร',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF888888),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 52.h,
            decoration: BoxDecoration(
              color: const Color(0xFF262626),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              onPressed: _handleCreateVoice,
              child: Text(
                'สร้างเสียง',
                style: GoogleFonts.lexend(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            height: 52.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: const Color(0xFFE5E5E5),
                width: 1,
              ),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              onPressed: _handleMakeMorePersuasive,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ทำให้ดูโน้มน้าวมากขึ้น',
                    style: GoogleFonts.lexend(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF262626),
                      height: 1.4,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  _buildPointsIconWithCount(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsIconWithCount() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16.w,
          height: 16.h,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF262626),
                ),
              ),
              Center(
                child: ShaderMask(
                  shaderCallback: (bounds) =>
                      MarAdsUIStyle.cyanPurpleGradient.createShader(bounds),
                  child: Text(
                    'P',
                    style: GoogleFonts.inter(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          '15',
          style: GoogleFonts.lexend(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF262626),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  void _handleCharacterSelectorTap() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // ให้เห็นมุมโค้งของ Modal
      isScrollControlled: true, // ให้ Modal ยืดได้เต็มที่หากรายการเยอะ
      builder: (context) => MarAdsSpeakerSelectionModal(
        selectedSpeaker: _selectedSpeaker,
        onSelect: (speaker) {
          setState(() {
            _selectedSpeaker = speaker;
          });
        },
      ),
    );
  }

  void _handleResultSelectorTap() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "เลือกโหมด",
              style: GoogleFonts.prompt(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12.h),
            const Divider(),
            ListTile(
              title: const Text('Result'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Edit'),
              onTap: () {
                setState(() => _selectedMode = 'Edit');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCreateVoice() async {
    // สั่งหุบคีย์บอร์ด (Unfocus) ก่อนจะเริ่มทำอะไร
    // เพื่อป้องกันคีย์บอร์ดเด้งสู้กับ Dialog
    FocusManager.instance.primaryFocus?.unfocus();

    // รอแป๊บนึงให้คีย์บอร์ดลงสุด (Optional: ใส่หรือไม่ใส่ก็ได้ แต่ใส่ไว้ 0.2 วิ จะนุ่มนวลกว่า)
    await Future.delayed(const Duration(milliseconds: 200));

    // เช็คว่า Text ว่างไหมก่อนยิง API
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('กรุณาพิมพ์ข้อความก่อนสร้างเสียง')));
      return;
    }

    // โชว์ Loading Dialog
    BuildContext? dialogContext;
    AudioPlayer? preloadedPlayer;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        dialogContext = context;
        return const MarAdsLoadingDialog();
      },
    );

    try {
      // หา Speaker ID (Default เป็น '1' ถ้าไม่มี)
      final String spkId = _selectedSpeaker?.speakerId ?? '1';

      // หา Language Code
      // ลำดับความสำคัญ: languageCode -> language (ตัวพิมพ์เล็ก) -> 'th' (Default)
      String langCode = _selectedSpeaker?.languageCode ?? '';
      if (langCode.isEmpty) {
        langCode = _selectedSpeaker?.language.toLowerCase() ?? '';
      }
      if (langCode.isEmpty) {
        langCode = 'th';
      }

      // ดึงค่า V2 และ ชื่อ Speaker มา Log ดู
      final bool isV2Speaker = (_selectedSpeaker?.v2 ?? false) ||
          (_selectedSpeaker?.engName ?? '').contains('V2') ||
          (_selectedSpeaker?.speakerName ?? '').contains('V2');
      final String debugName = _selectedSpeaker?.thaiName ??
          _selectedSpeaker?.speakerName ??
          'Unknown';

      // ปริ้นท์ Log ออกมาดูเลยว่าส่งใครไป
      print(
          " Generating Audio for: $debugName (ID: $spkId) | V2: $isV2Speaker | Lang: $langCode");

      // เรียก API สร้างเสียงก่อน เพื่อเอาค่า audioUrl มาใช้ในบรรทัดถัดไป
      final audioUrl = await generateAudioPreview(
        ref: ref,
        context: context,
        text: _textController.text,
        isV2: isV2Speaker,
        speakerId: spkId,
        language: langCode,
      );

      if (audioUrl.isNotEmpty) {
        //  ถ้ามี promptId ส่งมา ให้ทำการบันทึกเสียงลง History ทันที
        _currentAudioUrl = audioUrl;
        _currentFileName =
            "botnoi_marads_${DateTime.now().millisecondsSinceEpoch}.mp3";

        final String promptTitle = _textController.text.length > 20
            ? "${_textController.text.substring(0, 20)}..."
            : _textController.text;

        // Save ลง History (ทำหลังจากได้เสียงแล้ว)
        try {
          if (_localPromptId == null || _localPromptId!.isEmpty) {
            final newPromptId = _generateRandomPromptId();
            _localPromptId = newPromptId; // อัปเดตตัวแปรทันที

            //  ส่งข้อมูลครบชุด (Text + Audio + Style)
            await _promptService.addWorkspacePrompt(
              context: context,
              payload: {
                "prompt_id": newPromptId,
                "text": _textController.text,
                "title": promptTitle,
                "category": "text",
                "speaker": spkId,
                "speaker_v2": isV2Speaker,
                "language": langCode,
                "audio": audioUrl,
                "text_read": _textController.text,
                "text_read_with_delay": _textController.text,
                "volume": "100",
                "speed": "1",
                "is_download": true,
                "isDownloaded": false,
                "isEdit": false,
                "isgenerate": true,
                "isPlaying": false,
                "prompt_style": {
                  "TH_label": widget.contentStyle ?? "-",
                  "EN_label": widget.contentStyle ?? "-",
                  "value": widget.contentStyle ?? "-"
                },
              },
            );
            setState(() {
              // ยืนยัน Speaker ที่เลือกไว้ใน State อีกครั้งป้องกันการหลุด
              _selectedSpeaker = _selectedSpeaker;
            });
          } else {
            // ถ้ามี ID อยู่แล้ว ให้ Update
            await _promptService.updatePromptHistory(
              context: context,
              promptId: _localPromptId!,
              audioUrl: audioUrl,
              speakerId: spkId,
              isV2: isV2Speaker,
              language: langCode,
              text: _textController.text,
              contentStyle: widget.contentStyle ?? "-",
              title: promptTitle,
              category: "text",
            );
          }
        } catch (e) {
          print("⚠️ Failed to save history: $e");
        }

        // สร้าง Player และโหลดเสียงรอเลย (Pre-load)
        preloadedPlayer = AudioPlayer();
        await preloadedPlayer.setUrl(audioUrl);

        // ปิด Loading เมื่อ Buffer เสียงเสร็จแล้วจริงๆ
        if (dialogContext != null && mounted) {
          Navigator.of(dialogContext!).pop();
          dialogContext = null;
        }

        // เปิด Dialog เล่นเสียง โดยส่ง Player ที่พร้อมแล้วเข้าไป
        if (mounted) {
          _showAudioPlayerDialog(preloadedPlayer);
        }
      } else {
        // กรณีไม่มี URL ก็ปิด Dialog ตามปกติ
        if (dialogContext != null && mounted) {
          Navigator.of(dialogContext!).pop();
          dialogContext = null;
        }
      }
    } catch (e) {
      preloadedPlayer?.dispose();

      // ปิด Loading Dialog ก่อนแสดง Error
      if (dialogContext != null && mounted) {
        Navigator.of(dialogContext!).pop();
        dialogContext = null;
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          backgroundColor: Colors.white,
          title: Center(
            child: Icon(Icons.error_outline, color: Colors.red, size: 50.sp),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "สร้างเสียงไม่สำเร็จ",
                style: GoogleFonts.prompt(
                    fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              Text(
                "กรุณาลองใหม่อีกครั้ง\n($e)",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("ตกลง",
                    style: GoogleFonts.prompt(color: Colors.black)),
              ),
            )
          ],
        ),
      );
    } finally {
      if (dialogContext != null && mounted) {
        Navigator.of(dialogContext!).pop();
      }
    }
  }

  // เพิ่มฟังก์ชันโชว์ Dialog
  void _showAudioPlayerDialog(AudioPlayer player) {
    showDialog(
      context: context,
      builder: (context) => MarAdsAudioPlayerDialog(
        player: player,
        fileName: _currentFileName ?? "unknown.mp3",
        onDownload: () {
          Navigator.pop(context);
          // เรียกฟังก์ชันดาวน์โหลด
          if (_currentAudioUrl != null) {
            _handleDownload(_currentAudioUrl!,
                existingFileName: _currentFileName, isShare: false);
          }
        },
        // ปุ่มแชร์: โหลด + เปิด Share Sheet
        onShare: () {
          Navigator.pop(context);
          if (_currentAudioUrl != null) {
            _handleDownload(_currentAudioUrl!,
                existingFileName: _currentFileName, isShare: true);
          }
        },
      ),
    );
  }

  Future<void> _handleDownload(String url,
      {String? existingFileName, bool isShare = false}) async {
    // กรณีแชร์: ไม่ต้องเลือกนามสกุล ให้โหลดเลย (Logic เดิม)
    if (isShare) {
      await _downloadLogic.handleDownload(
        context: context,
        url: url,
        existingFileName: existingFileName,
        isShare: true,
        onSuccess: () {}, // แชร์ไม่มี dialog success อยู่แล้ว
      );
      return;
    }

    // กรณีดาวน์โหลด: โชว์ Dialog ให้เลือกก่อน
    showDialog(
      context: context,
      builder: (dialogContext) => MarAdsDownloadOptionsDialog(
        onConfirm: (selectedExtension) async {
          // เมื่อผู้ใช้กด "ตกลง" และเลือกนามสกุลมาแล้ว

          // สร้างชื่อไฟล์ใหม่ตามนามสกุลที่เลือก
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final finalFileName = "botnoi_marads_$timestamp.$selectedExtension";

          // เรียก Logic ดาวน์โหลดของจริง
          await _downloadLogic.handleDownload(
            context: context,
            url: url,
            existingFileName: finalFileName, // ส่งชื่อใหม่ที่มีนามสกุลถูกต้อง
            isShare: false,
            onSuccess: () {
              if (!mounted) return;
              showDialog(
                context: context,
                builder: (context) => const MarAdsSuccessDialog(
                  title: "ดาวน์โหลดสำเร็จ",
                  subtitle: "บันทึกไฟล์เสียงลงในเครื่องเรียบร้อยแล้ว",
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _handleMakeMorePersuasive() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('กำลังปรับปรุงข้อความให้โน้มน้าวมากขึ้น...'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
