import 'dart:math';
import 'package:botnoivoice/screen/drawer/marads/widgets/logic/mar_ads_download_logic.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/screen/mar_ads_history_screen.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/service/generate_audio_marads.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/service/prompt_service.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/components/mar_ads_points_badge.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/mar_ads_audio_player_dialog.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/mar_ads_download_options_dialog.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/mar_ads_loading_dialog.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/models/mar_ads_speaker_selection_modal.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/mar_ads_speaker_selector_button.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/mar_ads_success_dialog.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/result/result_action_buttons.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/result/result_mode_selector.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/result/result_text_box.dart';
import 'package:botnoivoice/screen/main/speaker/entities/speaker_entity.dart';
import 'package:botnoivoice/screen/main/speaker/model/speaker_model.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

class MarAdsResultScreen extends ConsumerStatefulWidget {
  final String? generatedText;
  final String? promptId;
  final String? contentStyle;
  final String? speakerId;
  final String? mode;
  final String? productName;

  const MarAdsResultScreen({
    super.key,
    this.generatedText,
    this.promptId,
    this.contentStyle,
    this.speakerId,
    this.mode,
    this.productName,
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
  bool _isPersuasiveLoading = false;

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

    // โหลด Point ล่าสุดเมื่อเข้าหน้าจอ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadAllTokensIfLoggedIn(ref);
    });

    // กำหนดค่าเริ่มต้นให้กับ Speaker (เช่น id 1 หรือตัวแรกของ List)
    if (SpeakerModel.speakerItem.isNotEmpty) {
      // 1. ลองหาจาก speakerId ที่ส่งมาจาก Advanced Mode ก่อน
      if (widget.speakerId != null && widget.speakerId!.isNotEmpty) {
        _selectedSpeaker = SpeakerModel.speakerItem.firstWhere(
          (s) => s.speakerId == widget.speakerId,
          orElse: () => SpeakerModel.speakerItem.first,
        );
      } else {
        // 2. ถ้าไม่มี ให้ใช้ Default (เช่น เอวา ID: 1)
        _selectedSpeaker = SpeakerModel.speakerItem.firstWhere(
          (s) => s.speakerId == '1',
          orElse: () => SpeakerModel.speakerItem.first,
        );
      }
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
                child: MarAdsResultTextBox(
                  controller: _textController,
                  mode: _selectedMode,
                  onClear: () {
                    _textController.text = widget.generatedText ?? '';
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          MarAdsResultActionButtons(
            onCreateVoice: _handleCreateVoice,
            onMakePersuasive: _handleMakeMorePersuasive,
            isPersuasiveLoading: _isPersuasiveLoading, // ส่งสถานะโหลดไปที่ปุ่ม
            isCreateEnabled: _textController.text.length <
                1000, // ต้องน้อยกว่า 1000 (999 ได้)
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final userTokenState = ref.watch(currentUserTokenStateProvider);
    final remainingCredits = userTokenState.remainingCredits ?? 0;

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
              child: MarAdsPointsBadge(points: remainingCredits.toString()),
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
          MarAdsResultModeSelector(
            selectedMode: _selectedMode,
            onModeChanged: (mode) => setState(() => _selectedMode = mode),
            onHistoryPressed: _openHistoryModal,
          ),
        ],
      ),
    );
  }

  void _openHistoryModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            SizedBox(height: 12.h), // ระยะห่างด้านบน
            // [เพิ่ม] ติ่งเทาๆ (Drag Handle)
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300], // สีเทา
                borderRadius: BorderRadius.circular(2.r), // มนๆ
              ),
            ),
            SizedBox(height: 12.h), // ระยะห่างระหว่างติ่งกับเนื้อหา

            // [เพิ่ม] เนื้อหา History (ใช้ Expanded เพื่อให้ยืดเต็มพื้นที่ที่เหลือ)
            const Expanded(
              child: MarAdsHistoryScreen(isModal: true),
            ),
          ],
        ),
      ),
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

  // Helper: ดึงและจัด Format ภาษาให้เหลือ 2 ตัวอักษร
  String _getSafeLanguageCode(SpeakerEntity? speaker) {
    String lang = speaker?.languageCode ?? '';
    if (lang.isEmpty) lang = speaker?.language.toLowerCase() ?? '';
    if (lang.length >= 2) lang = lang.substring(0, 2).toLowerCase();
    return lang.isEmpty ? 'th' : lang;
  }

  bool _isVoiceLoading = false; // สถานะ Loading สำหรับป้องกันการหักพอยท์ซ้ำ

  Future<void> _handleCreateVoice() async {
    if (_isVoiceLoading) return; // ถ้ากำลังทำงานอยู่ให้หยุด เพื่อกัน Double Tap
    setState(() => _isVoiceLoading = true);
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

    String currentMode = widget.mode ?? 'basic'; // ตั้งค่าเริ่มต้น
    String? effectiveProductName = widget.productName;

    try {
      // พยายามดึงจาก GoRouterState อีกครั้งเพื่อความชัวร์
      final state = GoRouterState.of(context);
      final queryMode = state.uri.queryParameters['mode'];
      if (queryMode != null && queryMode.isNotEmpty) {
        currentMode = queryMode;
      }
      final queryProduct = state.uri.queryParameters['product_name'];
      if (queryProduct != null && queryProduct.isNotEmpty) {
        effectiveProductName = queryProduct;
      }
    } catch (e) {
      debugPrint("Error parsing mode from router: $e");
    }

    print(" Creating Voice with Mode: '$currentMode'");

    // โชว์ Loading Dialog
    AudioPlayer? preloadedPlayer;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const MarAdsLoadingDialog();
      },
    );

    try {
      // หา Speaker ID (Default เป็น '1' ถ้าไม่มี)
      final String spkId = _selectedSpeaker?.speakerId ?? '1';

      // หา Language Code
      // ลำดับความสำคัญ: languageCode -> language (ตัวพิมพ์เล็ก) -> 'th' (Default)
      final String langCode = _getSafeLanguageCode(_selectedSpeaker);

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

        // ใช้ productName เป็น Title
        String promptTitle =
            (effectiveProductName != null && effectiveProductName!.isNotEmpty)
                ? effectiveProductName!
                : (_textController.text.length > 20
                    ? "${_textController.text.substring(0, 20)}..."
                    : _textController.text);

        // Save ลง History (ทำหลังจากได้เสียงแล้ว)
        try {
          final bool isNew =
              (_localPromptId == null || _localPromptId!.isEmpty);
          if (isNew) _localPromptId = _generateRandomPromptId();

          final payload = {
            "prompt_id": _localPromptId,
            "text": _textController.text,
            "mode": currentMode,
            "title": promptTitle,
            "category": "text",
            "speaker": spkId,
            "speaker_v2": isV2Speaker,
            "language": langCode,
            "audio": audioUrl,
            "is_download": true,
            "content_length": GoRouterState.of(context)
                    .uri
                    .queryParameters['content_length'] ??
                'กลาง',
            "prompt_style": {"value": widget.contentStyle ?? "-"},
          };

          // ลอจิกการแยก Add/Update เพื่อบันทึกประวัติการใช้พอยท์
          if (isNew) {
            await _promptService.addWorkspacePrompt(
                context: context, payload: payload);
          } else {
            await _promptService.updatePromptHistory(
              context: context,
              promptId: _localPromptId!,
              audioUrl: audioUrl,
              speakerId: spkId,
              isV2: isV2Speaker,
              language: langCode,
              text: _textController.text,
              title: promptTitle,
              contentStyle: widget.contentStyle ?? "-",
              category: "text",
            );
          }
          //อัปเดต Point ทันทีหลังจากสร้างเสียงสำเร็จ
          loadAllTokensIfLoggedIn(ref);

          if (mounted) setState(() {});
        } catch (e) {
          debugPrint("⚠️ History Sync Error: $e");
        }

        // สร้าง Player และโหลดเสียงรอเลย (Pre-load)
        preloadedPlayer = AudioPlayer();
        await preloadedPlayer.setUrl(audioUrl);

        // ปิด Loading เมื่อ Buffer เสียงเสร็จแล้วจริงๆ
        if (mounted && context.canPop()) {
          context.pop();
        }

        // เปิด Dialog เล่นเสียง โดยส่ง Player ที่พร้อมแล้วเข้าไป
        if (mounted) {
          _showAudioPlayerDialog(preloadedPlayer);
        }
      } else {
        // กรณีไม่มี URL ก็ปิด Dialog ตามปกติ
        if (mounted && context.canPop()) {
          context.pop();
        }
        // if (mounted) setState(() => _isVoiceLoading = false);
      }
    } catch (e) {
      preloadedPlayer?.dispose();

      // ปิด Loading Dialog ก่อนแสดง Error
      if (mounted && context.canPop()) {
        context.pop();
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
                onPressed: () {
                  context.pop();
                },
                child: Text("ตกลง",
                    style: GoogleFonts.prompt(color: Colors.black)),
              ),
            )
          ],
        ),
      );
    } finally {
      // ใช้ finally เพื่อรีเซ็ตสถานะปุ่มเสมอ ไม่ว่าจะสำเร็จหรือพัง
      if (mounted) {
        setState(() => _isVoiceLoading = false);
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
          // Close Dialog
          context.pop();

          // เรียกฟังก์ชันดาวน์โหลด
          if (_currentAudioUrl != null) {
            _handleDownload(_currentAudioUrl!,
                existingFileName: _currentFileName, isShare: false);
          }
        },
        // ปุ่มแชร์: โหลด + เปิด Share Sheet
        onShare: () {
          // Close Dialog
          context.pop();

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
    final int estimatedPoints = _textController.text.length * 1;

    // กรณีดาวน์โหลด: โชว์ Dialog ให้เลือกก่อน
    showDialog(
      context: context,
      builder: (dialogContext) => MarAdsDownloadOptionsDialog(
        points: estimatedPoints,
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

  Future<void> _handleMakeMorePersuasive() async {
    if (_textController.text.trim().isEmpty || _isPersuasiveLoading) return;

    // ดึงข้อมูลเสริมจาก URL เผื่อมาจาก Advanced Mode
    final state = GoRouterState.of(context);
    final salesChar = state.uri.queryParameters['sales_character'] ?? "";
    final contentLength = state.uri.queryParameters['content_length'] ?? "กลาง";
    final currentMode = widget.mode ?? 'basic';

    setState(() => _isPersuasiveLoading = true);

    try {
      // 2. สร้าง Payload โดยรักษา Context เดิม (เช่น คาแรกเตอร์ หรือ ชื่อสินค้า)
      final Map<String, dynamic> payload = {
        "mode": currentMode,
        "language": "th",
        "product_name": widget.productName ?? "สินค้า",
        "content_style": widget.contentStyle ?? "จูงใจให้ใช้",
        "content_length": contentLength,
        "additional_info":
            "ช่วยปรับปรุงข้อความต่อไปนี้ให้ดูน่าสนใจและโน้มน้าวใจ (Persuasive) มากขึ้น "
                "${salesChar.isNotEmpty ? 'ในสไตล์ $salesChar' : ''}: ${_textController.text}",
      };

      // ถ้าเป็น Advanced mode ให้ใส่ field ที่จำเป็นเพิ่มเพื่อให้ AI เข้าใจบริบท
      if (currentMode == 'advanced') {
        payload["sales_character"] = salesChar;
      }

      final result = await _promptService.createPromptAds(
        context: context,
        payload: payload,
      );

      if (result != null && result['data'] != null) {
        String newText = result['data'].toString();

        // ล้างวงเล็บ [ ] ออกถ้า AI ส่งกลับมาเป็น List string
        if (newText.startsWith('[') && newText.endsWith(']')) {
          newText = newText.substring(1, newText.length - 1);
        }

        setState(() {
          _textController.text = newText;
          _currentAudioUrl = null; // ล้างเสียงเดิมทิ้ง
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ปรับปรุงข้อความเรียบร้อยแล้ว'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _logger.e("Error making persuasive: $e");

      String errorMessage = e.toString().replaceAll('Exception:', '').trim();
      if (e.toString().contains('401')) {
        errorMessage = 'เซสชั่นหมดอายุ กรุณาเข้าสู่ระบบใหม่';
      } else if (e.toString().contains('500')) {
        errorMessage = 'ระบบขัดข้องชั่วคราว กรุณาลองใหม่';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isPersuasiveLoading = false);
    }
  }
}
