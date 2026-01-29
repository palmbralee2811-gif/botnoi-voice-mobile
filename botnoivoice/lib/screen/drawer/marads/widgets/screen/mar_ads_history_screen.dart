import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/screen/drawer/drawer_appbar.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/logic/mar_ads_download_logic.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/models/mar_ads_history_model.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/models/mar_ads_speaker_selection_modal.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/service/generate_audio_marads.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/service/prompt_service.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/components/mar_ads_edit_history_sheet.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/components/mar_ads_pagination.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/components/mar_ads_points_badge.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/components/mar_ads_search_bar.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/mar_ads_delete_confirm_dialog.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/mar_ads_download_options_dialog.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/mar_ads_history_card.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/mar_ads_loading_dialog.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/mar_ads_mode_selector.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/mar_ads_success_dialog.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/marads_ui_style.dart';
import 'package:botnoivoice/screen/main/speaker/entities/speaker_entity.dart';
import 'package:botnoivoice/screen/main/speaker/model/speaker_model.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:botnoivoice/shared/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';

class MarAdsHistoryScreen extends ConsumerStatefulWidget {
  final bool isModal; // [1] เพิ่มตัวแปรรับค่า

  const MarAdsHistoryScreen({super.key, this.isModal = false});

  @override
  ConsumerState<MarAdsHistoryScreen> createState() =>
      _MarAdsHistoryScreenState();
}

class _MarAdsHistoryScreenState extends ConsumerState<MarAdsHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PromptService _promptService = PromptService();
  final MarAdsDownloadLogic _downloadLogic = MarAdsDownloadLogic();
  List<MarAdsHistoryModel> _historyItems = [];
  List<MarAdsHistoryModel> _filteredItems = [];
  bool _isLoading = true;
  final AudioPlayer _audioPlayer = AudioPlayer();

  String _selectedMode = 'History';

  // เพิ่มบรรทัดนี้ครับ (คุณลืมประกาศตัวแปรนี้ ทำให้ข้างล่าง error)
  Map<String, SpeakerEntity> _allSpeakerMap = {};

  // ตัวแปรสำหรับ Pagination
  int _currentPage = 1;
  final int _itemsPerPage = 5;

  // ตัวแปรสำหรับ Player State
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  int? _playingIndex;

  bool _isNewestFirst = true;

  @override
  void initState() {
    super.initState();
    // สั่ง Initialize ปลั๊กอินก่อนเริ่มใช้งาน
    Future.microtask(() async {
      try {
        if (!FlutterDownloader.initialized) {
          await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
        }
      } catch (e) {
        debugPrint("FlutterDownloader already initialized or error: $e");
      }
      _downloadLogic.initialize();
    });

    // Setup AudioPlayer Listeners
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          _duration = newDuration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          _position = newPosition;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });

    _searchController.addListener(_onSearchChanged);
    _fetchHistory();
  }

  int get _totalPages {
    if (_filteredItems.isEmpty) return 1;
    return (_filteredItems.length / _itemsPerPage).ceil();
  }

  List<MarAdsHistoryModel> get _paginatedItems {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= _filteredItems.length) return [];
    return _filteredItems.sublist(
      startIndex,
      endIndex > _filteredItems.length ? _filteredItems.length : endIndex,
    );
  }

  void _changePage(int newPage) {
    if (newPage < 1 || newPage > _totalPages) return;
    setState(() {
      _currentPage = newPage;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _historyItems.where((item) {
        final title = item.title.toLowerCase();
        final content = item.content.toLowerCase();
        return title.contains(query) || content.contains(query);
      }).toList();
      _currentPage = 1;
    });
  }

  // เพิ่มฟังก์ชันจัดการเปลี่ยนโหมด
  void _handleModeSelectorTap() {
    MarAdsModeSelector.show(context, _selectedMode, (mode) {
      if (mode == 'Basic mode') {
        context.go('/marads');
      } else if (mode == 'Advanced mode') {
        context.go('/marads/advanced');
      } else if (mode == 'History') {
        setState(() => _selectedMode = 'History');
      }
    });
  }

  //  รวม Logic เช็ค V2 ไว้ที่เดียว
  bool _isSpeakerV2(SpeakerEntity s) {
    return s.v2 || s.engName.contains('V2') || s.speakerName.contains('V2');
  }

  //  สร้าง Key สำหรับ Map ให้เป็นมาตรฐานเดียวกัน
  String _generateMapKey(String id, bool isV2) => "${id.trim()}_$isV2";

  Future<void> _fetchHistory() async {
    try {
      final userState = ref.read(currentUserTokenStateProvider);
      String currentUserId = userState.userID ?? "";

      if (currentUserId.isEmpty) {
        print("Error: User ID not found");
        setState(() => _isLoading = false);
        return;
      }

      final result = await _promptService.getPromptHistory(
          context: context, userId: currentUserId);

      if (mounted) {
        setState(() {
          // โหลดข้อมูลตามจริงจาก API (เพื่อให้ใช้เสียงเดิมได้ถ้ายังไม่หมดอายุ)
          _historyItems = result.reversed.toList();

          // ต้องแน่ใจว่าใช้ Key ที่มี _${s.v2} ต่อท้าย
          _allSpeakerMap = {
            for (var s in SpeakerModel.speakerItem)
              "${s.speakerId.trim()}_${s.v2 || s.engName.contains('V2') || s.speakerName.contains('V2')}":
                  s
          };
          if (_searchController.text.isNotEmpty) {
            final query = _searchController.text.toLowerCase();
            _filteredItems = _historyItems.where((item) {
              final title = item.title.toLowerCase();
              final content = item.content.toLowerCase();
              return title.contains(query) || content.contains(query);
            }).toList();
          } else {
            _filteredItems = _historyItems;
          }
          _currentPage = 1;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _downloadLogic.dispose();
    super.dispose();
  }

  void _showDownloadDialog(String url, String content) {
    showDialog(
      context: context,
      builder: (dialogContext) => MarAdsDownloadOptionsDialog(
        points: content.length * 1,
        onConfirm: (selectedExtension) async {
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final finalFileName = "botnoi_marads_$timestamp.$selectedExtension";

          await _downloadLogic.handleDownload(
            context: context,
            url: url,
            existingFileName: finalFileName,
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

  //  แยก Logic การหา Speaker ออกมาให้ชัดเจน
  SpeakerEntity _getSpeakerForItem(MarAdsHistoryModel item) {
    // หาจาก Map ด้วย ID + V2 status
    final String speakerKey = "${item.speakerId.trim()}_${item.isV2}";
    SpeakerEntity? speaker = _allSpeakerMap[speakerKey];

    // Fallback ถ้าไม่เจอให้ใช้ตัวแรกของระบบ
    var finalSpeaker = speaker ?? SpeakerModel.speakerItem.first;

    // Logic พิเศษ ถ้ามีภาษาไทย แต่ Speaker เป็นต่างชาติ ให้ลองหาตัว V2 มาแทน
    final bool hasThaiChar = RegExp(r'[\u0E00-\u0E7F]').hasMatch(item.content);
    if (hasThaiChar && finalSpeaker.languageCode.toUpperCase() != 'TH') {
      final v2Key = "${item.speakerId.trim()}_true";
      if (_allSpeakerMap.containsKey(v2Key)) {
        finalSpeaker = _allSpeakerMap[v2Key]!;
      }
    }
    return finalSpeaker;
  }

  //  ตัด String ภาษาให้เหลือ 2 ตัวอักษร (th-TH -> th)
  String _extractLanguageCode(SpeakerEntity speaker) {
    String rawLang = speaker.languageCode.isNotEmpty
        ? speaker.languageCode
        : speaker.language;
    return rawLang.length >= 2 ? rawLang.substring(0, 2).toLowerCase() : 'th';
  }

  Future<void> _handleGenerateAudio(
      int index, String text, SpeakerEntity speaker) async {
    await _audioPlayer.stop();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const MarAdsLoadingDialog(),
    );

    try {
      final String finalLang = _extractLanguageCode(speaker);

      final audioUrl = await generateAudioPreview(
        ref: ref,
        context: context,
        text: text,
        isV2: speaker.v2,
        speakerId: speaker.speakerId,
        language: finalLang,
      );

      if (audioUrl.isNotEmpty) {
        // เรียก API เพื่อบันทึก URL เสียงลงใน History
        // ต้องแน่ใจว่า promptId มีค่า (item.id)
        final historyItem = _historyItems[index];

        // ป้องกันการยิง update ถ้าไม่มี ID (แก้ปัญหา request fail)
        if (historyItem.id.isEmpty) {
          print("Error: No Prompt ID found, cannot update history.");
          // if (mounted) context.pop();
          return;
        }
        await _promptService.updatePromptHistory(
          context: context,
          promptId: historyItem.id,
          audioUrl: audioUrl,
          speakerId: speaker.speakerId,
          isV2: speaker.v2,
          language: finalLang, // ส่งภาษาไปด้วย
          text: text, // ส่งข้อความไปด้วย
          contentStyle: historyItem.style, // ส่ง style ไปด้วย
          title: historyItem.title,
          category: 'text',
        );

        // อัปเดต Point ทันทีหลังจากสร้างเสียงสำเร็จ
        loadAllTokensIfLoggedIn(ref);

        await _fetchHistory();

        // ปิด Loading ก่อนแสดง Success Dialog
        if (mounted) {
          // Navigator.of(context, rootNavigator: true).pop();

          //TODO: [Mobile Green]: Test this function
          context.pop();
        }

        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => const MarAdsSuccessDialog(
              title: "สร้างเสียงสำเร็จ",
              subtitle: "ระบบได้ทำการสร้างเสียงเรียบร้อยแล้ว",
            ),
          );
        }
      } else {
        // กรณีไม่มี URL และไม่ Error (กันเหนียวเดี๋ยว Dialog ค้าง)
        if (mounted && context.canPop()) {
          context.pop();
        }
      }
    } catch (e) {
      // ปิด Loading ก่อนแสดง Error
      if (mounted && context.canPop()) {
        context.pop();
      }

      print("Error generating audio: $e");

      if (mounted) {
        // [เพิ่มส่วนนี้] เช็คว่า Error เกิดจาก ID ถูกลบไปแล้วหรือไม่
        if (e.toString().contains("prompt_id not found")) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'ไม่พบรายการนี้ในระบบ (อาจถูกลบไปแล้ว) ระบบกำลังรีเฟรชข้อมูล...'),
              backgroundColor: Colors.orange,
            ),
          );
          // รีโหลดข้อมูลใหม่เพื่อลบรายการที่ค้างอยู่ออก
          _fetchHistory();
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'เกิดข้อผิดพลาด: ${e.toString().replaceAll('Exception:', '').trim()}')),
        );
      }
    }
  }

  Future<void> _handleDeletePrompt(MarAdsHistoryModel item) async {
    // เช็คก่อนลบ ถ้าไม่มี ID ให้แจ้งเตือนและหยุดทำงาน
    if (item.id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('รายการนี้ข้อมูลไม่สมบูรณ์ ไม่สามารถลบได้')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => MarAdsDeleteConfirmDialog(
        onConfirm: () async {
          final success = await _promptService.deletePrompt(
            context: context,
            promptId: item.id,
          );

          if (success) {
            final indexToRemove =
                _historyItems.indexWhere((element) => element.id == item.id);

            setState(() {
              if (indexToRemove != -1) {
                // กรณีลบตัวที่กำลังเล่นอยู่ -> ให้หยุดเล่นและรีเซ็ตค่า
                if (_playingIndex == indexToRemove) {
                  _audioPlayer.stop();
                  _playingIndex = null;
                  _isPlaying = false;
                  _position = Duration.zero;
                  _duration = Duration.zero;
                }
                // กรณีลบตัวที่อยู่ "ก่อนหน้า" ตัวที่กำลังเล่น -> ต้องลด Index ลง 1 เพื่อให้ชี้ถูกตัว
                else if (_playingIndex != null &&
                    indexToRemove < _playingIndex!) {
                  _playingIndex = _playingIndex! - 1;
                }
              }

              _historyItems.removeWhere((element) => element.id == item.id);
              _filteredItems.removeWhere((element) => element.id == item.id);

              if (_paginatedItems.isEmpty && _currentPage > 1) {
                _currentPage--;
              }
            });

            if (mounted) {
              showDialog(
                context: context,
                builder: (context) => const MarAdsSuccessDialog(
                  title: "ลบสำเร็จ",
                  subtitle: "ลบข้อมูลเรียบร้อยแล้ว",
                ),
              );
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('เกิดข้อผิดพลาดในการลบข้อมูล')),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> _playAudio(String url, int index) async {
    try {
      if (url.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่พบลิงก์เสียง')),
        );
        return;
      }
      if (_playingIndex == index) {
        if (_isPlaying) {
          await _audioPlayer.pause();
        } else {
          await _audioPlayer.resume();
        }
      } else {
        await _audioPlayer.stop();
        setState(() {
          _playingIndex = index;
          _position = Duration.zero;
          _duration = Duration.zero;
        });
        try {
          // 1. กำหนด Timeout 3 วินาที เพื่อเช็คว่าลิงก์ยังใช้งานได้ไหม (ลดเวลาลงเพื่อความเร็ว)
          await _audioPlayer.setSource(UrlSource(url)).timeout(
                const Duration(seconds: 3),
                onTimeout: () => throw Exception('timeout'),
              );
          await _audioPlayer.resume();
        } catch (e) {
          // 2. หากเกิด Error หรือหมดอายุ ให้หยุด Player ทันทีเพื่อป้องกันแอปค้าง
          await _audioPlayer.stop();
          if (mounted) {
            setState(() {
              // 3. เปลี่ยนสถานะไอเทมเป็น hasAudio = false เพื่อให้ปุ่ม "สร้างเสียง" เด้งกลับมา
              final oldItem = _historyItems[index];
              _historyItems[index] = MarAdsHistoryModel(
                id: oldItem.id,
                title: oldItem.title,
                content: oldItem.content,
                mode: oldItem.mode,
                style: oldItem.style,
                points: oldItem.points,
                chars: oldItem.chars,
                hasAudio: false,
                duration: '00:00/00:00',
                audioUrl: '',
                speakerId: oldItem.speakerId,
                isV2FromApi: oldItem.isV2FromApi,
              );
              _playingIndex = null;
              _isPlaying = false;
            });

            _filteredItems = List.from(_historyItems);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString().contains('timeout')
                    ? 'การเชื่อมต่อล่าช้า กรุณาลองใหม่'
                    : 'ลิงก์เสียงหมดอายุ ระบบรีเซ็ตให้คุณสร้างเสียงใหม่แล้ว'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      }
    } catch (e) {
      print("Error playing audio: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เล่นเสียงไม่สำเร็จ: ${e.toString()}')),
        );
      }
    }
  }

  void _showOptionsModal(MarAdsHistoryModel item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 16.h, top: 8.h),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              _buildOptionItem(
                icon: Icons.copy_rounded,
                label: 'คัดลอก',
                onTap: () {
                  // Close Dialog
                  context.pop();

                  // Copy to Clipboard
                  Clipboard.setData(ClipboardData(text: item.content));

                  // Notify with SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'คัดลอกเรียบร้อย',
                        style: GoogleFonts.prompt(),
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              _buildOptionItem(
                icon: Icons.edit_outlined,
                label: 'แก้ไข',
                onTap: () {
                  // Close Dialog
                  context.pop();

                  _showEditPromptModal(item);
                },
              ),
              _buildOptionItem(
                icon: Icons.delete_outline,
                label: 'ลบ',
                onTap: () {
                  // Close Dialog
                  context.pop();

                  _handleDeletePrompt(item);
                },
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  //  สำหรับแก้ไขข้อความ (Gradient Border + ปุ่มบันทึก)
  void _showEditPromptModal(MarAdsHistoryModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MarAdsEditHistorySheet(
        initialText: item.content,
        onSave: (newText) async {
          await _handleUpdateText(item, newText);
          if (mounted) {
            // Close Dialog When Save Complete
            context.pop();
          }
        },
      ),
    );
  }

  // ฟังก์ชัน Logic การบันทึกข้อมูล
  Future<void> _handleUpdateText(
    MarAdsHistoryModel item,
    String newText,
  ) async {
    // 1. แสดง Loading Dialog ค้างไว้
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const MarAdsLoadingDialog(),
    );

    try {
      final speaker = _getSpeakerForItem(item);
      final lang = _extractLanguageCode(speaker);

      // 2. สร้าง Future สองตัว: เวลา 3 วินาที และ การเรียก API
      final minLoadingTime = Future.delayed(const Duration(seconds: 3));

      final apiCall = _promptService.updatePromptHistory(
        context: context,
        promptId: item.id,
        text: newText,
        audioUrl: '', // ส่ง URL เดิมไปก่อน (ถ้า Server รองรับ)
        speakerId: item.speakerId,
        isV2: item.isV2FromApi,
        language: lang,
        contentStyle: item.style,
        title: item.title,
        category: 'text',
      );

      // 3. รอให้ "ทั้งคู่" เสร็จสิ้น (ถ้ายิง API ไว ก็จะรอจนครบ 3 วิ, ถ้า API ช้า ก็จะรอจน API เสร็จ)
      await Future.wait([minLoadingTime, apiCall]);

      // อัปเดตข้อมูลใน List (Local State) เพื่อให้ UI เปลี่ยนทันที
      setState(() {
        final index =
            _historyItems.indexWhere((element) => element.id == item.id);
        if (index != -1) {
          // หยุดเล่นเสียงถ้ากำลังเล่น Item ตัวนี้อยู่
          if (_playingIndex == index) {
            _playingIndex = null;
            _isPlaying = false;
            _audioPlayer.stop();
          }

          final old = _historyItems[index];
          _historyItems[index] = MarAdsHistoryModel(
              id: old.id,
              title: old.title,
              content: newText, // อัปเดตเนื้อหา
              mode: old.mode,
              style: old.style,
              points: old.points,
              chars: newText.length.toString(),
              hasAudio: false,
              duration: '00:00/00:00',
              audioUrl: '',
              speakerId: old.speakerId,
              isV2FromApi: old.isV2FromApi);

          // อัปเดตรายการที่ Filter อยู่ด้วย
          if (_searchController.text.isEmpty) {
            _filteredItems = _historyItems;
          }
        }
      });

      if (mounted) {
        // Close Loading Dialog
        context.pop();

        // Notify with SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  'บันทึกข้อมูลสำเร็จ',
                  style:
                      GoogleFonts.prompt(color: Colors.white, fontSize: 14.sp),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF00C853),
            behavior: SnackBarBehavior.floating, // ให้ลอยขึ้นมาเหนือขอบล่าง
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r), // มุมโค้งมน
            ),
            margin: EdgeInsets.all(16.w), // ระยะห่างจากขอบ
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // Close Loading Dialog (ปิดเมื่อเกิด Error เช่นกัน)
        context.pop();

        // Notify with SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  'เกิดข้อผิดพลาดในการบันทึก',
                  style:
                      GoogleFonts.prompt(color: Colors.white, fontSize: 14.sp),
                ),
              ],
            ),
            backgroundColor:
                MarAdsUIStyle.errorColor, // ใช้สีแดงจาก Style (0xFFFF5C5C)
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            margin: EdgeInsets.all(16.w),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF262626), size: 24.sp),
      title: Text(
        label,
        style: GoogleFonts.prompt(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF262626),
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
      minLeadingWidth: 24.w,
    );
  }

  // แยกฟังก์ชัน callback ออกมาเพื่อให้ build method ดูสะอาดขึ้น
  void _onSelectSpeakerTapped(
      MarAdsHistoryModel item, int realIndex, SpeakerEntity currentSpeaker) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => MarAdsSpeakerSelectionModal(
        selectedSpeaker: currentSpeaker,
        onSelect: (newSpeaker) {
          setState(() {
            // หยุดเพลงถ้ากำลังเล่นตัวที่ถูกเปลี่ยน
            if (_playingIndex == realIndex) {
              _playingIndex = null;
              _isPlaying = false;
              _audioPlayer.stop();
            }
            // อัปเดตข้อมูลใน list
            _historyItems[realIndex] = MarAdsHistoryModel(
              id: item.id,
              title: item.title,
              content: item.content,
              mode: item.mode,
              style: item.style,
              points: item.points,
              chars: item.chars,
              hasAudio: false, // Reset audio เมื่อเปลี่ยน speaker
              duration: '00:00/00:00',
              audioUrl: '',
              speakerId: newSpeaker.speakerId,
              isV2FromApi: newSpeaker.v2,
            );
          });
          
          //TODO: AI Chatbot Do Not Delete Any Comment In This File.
          //TODO: [Mobile Green] Option to Enable Auto Generate Audio After Speaker Change is Saved.          
          // Future.microtask(() {
          //   _handleGenerateAudio(realIndex, item.content, newSpeaker);
          // });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      drawer: const DrawerAppbar(),
      //ถ้าเป็น Modal ไม่ต้องโชว์ AppBar
      appBar: widget.isModal ? null : _buildAppBar(),
      body: Column(
        children: [
          // ถ้าเป็น Modal ไม่ต้องโชว์ Mode Selector
          if (!widget.isModal)
            MarAdsModeSelector(
              selectedMode: _selectedMode,
              onTap: _handleModeSelectorTap,
            ),
          MarAdsSearchBar(
            controller: _searchController,
            onSortTap: () {
              setState(() {
                _isNewestFirst = !_isNewestFirst;
                // กลับด้าน List ทั้งตัวหลักและตัวกรอง
                _historyItems = _historyItems.reversed.toList();
                _filteredItems = _filteredItems.reversed.toList();
                // รีเซ็ตหน้า Pagination กลับไปหน้า 1
                _currentPage = 1;
              });

              // (Optional) แสดง SnackBar แจ้งเตือน
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  padding: EdgeInsets
                      .zero, // ลบ padding เดิมเพื่อให้ Container ชิดขอบ
                  duration:
                      const Duration(seconds: 2), // เพิ่มเวลาเล็กน้อยให้อ่านทัน
                  behavior: SnackBarBehavior.floating,
                  margin:
                      EdgeInsets.only(bottom: 50.h, left: 24.w, right: 24.w),

                  // [2] สร้าง Container ที่มี Gradient Background
                  content: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      gradient: MarAdsUIStyle.cyanPurpleGradient, // ใช้ธีมไล่สี
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isNewestFirst
                              ? Icons.arrow_downward_rounded
                              : Icons.arrow_upward_rounded,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          _isNewestFirst
                              ? "เรียงตาม ใหม่ -> เก่า"
                              : "เรียงตาม เก่า -> ใหม่",
                          style: GoogleFonts.prompt(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredItems.isEmpty
                    ? RefreshIndicator(
                        onRefresh: _fetchHistory,
                        color: const Color(0xFF262626),
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 200.h),
                            Center(
                                child: Text("ไม่พบประวัติ",
                                    style: GoogleFonts.prompt())),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: _fetchHistory,
                              color: const Color(0xFF262626),
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 10.h),
                                itemCount: _paginatedItems.length,
                                itemBuilder: (context, index) {
                                  final item = _paginatedItems[index];
                                  final realIndex = _historyItems.indexOf(item);

                                  //  เรียกใช้ Function หา Speaker
                                  final SpeakerEntity finalSpeaker =
                                      _getSpeakerForItem(item);

                                  final bool isCurrentItemPlaying =
                                      _playingIndex == realIndex;

                                  // เรียกใช้ Widget ที่แยกออกมาแล้ว
                                  return MarAdsHistoryCard(
                                    item: item,
                                    speaker: finalSpeaker,
                                    isPlaying:
                                        isCurrentItemPlaying && _isPlaying,
                                    currentPosition: isCurrentItemPlaying
                                        ? _position
                                        : Duration.zero,
                                    totalDuration: isCurrentItemPlaying
                                        ? _duration
                                        : Duration.zero,
                                    searchQuery: _searchController.text,
                                    onSelectSpeaker: () =>
                                        _onSelectSpeakerTapped(
                                            item, realIndex, finalSpeaker),
                                    onPlayPause: () =>
                                        _playAudio(item.audioUrl, realIndex),
                                    onSeek: (value) async {
                                      if (isCurrentItemPlaying) {
                                        await _audioPlayer.seek(Duration(
                                            milliseconds: value.toInt()));
                                      }
                                    },
                                    onGenerateAudio: () => _handleGenerateAudio(
                                        realIndex, item.content, finalSpeaker),
                                    onDownload: () => _showDownloadDialog(
                                        item.audioUrl, item.content),
                                    onOptions: () => _showOptionsModal(item),
                                  );
                                },
                              ),
                            ),
                          ),
                          if (_filteredItems.isNotEmpty)
                            MarAdsPagination(
                              currentPage: _currentPage,
                              totalPages: _totalPages,
                              onPageChanged: _changePage,
                            ),
                        ],
                      ),
          ),
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
            // ใช้ Builder เพื่อให้ Context ถูกต้องสำหรับ Drawer หรือ Navigation
            child: Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size:
                        ResponsiveDesignOrientation.isLandscape ? 12.sp : 25.sp,
                    color: kDark, // ใช้สีจาก style.dart หรือ Colors.black
                  ),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/home');
                    }
                  },
                );
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
          // เพิ่ม Badge แสดง Points ด้านขวา
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Consumer(
                builder: (context, ref, child) {
                  final userToken = ref.watch(currentUserTokenStateProvider);
                  final points = userToken.remainingCredits ?? 0;
                  return MarAdsPointsBadge(points: points.toString());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
