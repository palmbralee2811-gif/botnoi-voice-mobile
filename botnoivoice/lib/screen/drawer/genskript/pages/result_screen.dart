import 'dart:async';
import 'dart:io';
import 'package:botnoivoice/screen/drawer/genskript/models/result_item_model.dart';
import 'package:botnoivoice/screen/drawer/genskript/widgets/genskript_download_all_dialog.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/models/mar_ads_speaker_selection_modal.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/mar_ads_speaker_selector_button.dart';
import 'package:botnoivoice/screen/main/speaker/entities/speaker_entity.dart';
import 'package:botnoivoice/screen/main/speaker/model/speaker_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import '../services/script_service.dart';
import '../services/translation_service.dart';
import '../services/video_service.dart';
import '../services/voice_service.dart';
import '../services/download_service.dart';
import '../data/app_data.dart';

// ✅ Import all your dialog widgets
import '../widgets/genskript_audio_player_dialog.dart';
import '../widgets/genskript_download_options_dialog.dart';
import '../widgets/genskript_success_dialog.dart';
import '../widgets/genskript_video_creation_dialog.dart';

var logger = Logger();

class ResultScreen extends StatefulWidget {
  final List<ResultItem> items;
  final String language;
  final VoidCallback onBack;

  const ResultScreen({
    super.key,
    required this.items,
    required this.language,
    required this.onBack,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late TextEditingController _editController;
  final AudioPlayer _player = AudioPlayer();
  final PageController _pageController =
      PageController(); // ควบคุมการเลื่อนหน้า
  int _currentIndex = 0; // เก็บหน้าปัจจุบัน

  SpeakerEntity? _selectedSpeaker;

  // Settings
  int userPoints = 5000; // Mock balance
  String _selectedSpeed = '1x';
  String _selectedVolume = '100%';
  String? _currentFileName;

  final List<String> speedOptions = [
    '0.5x',
    '0.6x',
    '0.7x',
    '0.8x',
    '0.9x',
    '1x',
    '1.2x',
    '1.5x',
    '2.0x'
  ];
  final List<String> volumeOptions = [
    '50%',
    '60%',
    '70%',
    '80%',
    '90%',
    '100%',
    '110%',
    '120%',
    '130%',
    '140%',
    '150%'
  ];

  @override
  void initState() {
    super.initState();
    // เริ่มต้นด้วยสคริปต์ของหน้าแรก (ถ้ามีข้อมูล)
    _editController = TextEditingController(
        text: widget.items.isNotEmpty ? widget.items[0].script : "");
    _initializeDownloader();

    if (SpeakerModel.speakerItem.isNotEmpty) {
      // ตรวจสอบภาษาเพื่อเลือกเสียงเริ่มต้น (ไทย -> 1, อังกฤษ -> 55)
      String defaultId = '5';
      if (widget.language.toLowerCase().contains('en') ||
          widget.language.toLowerCase().contains('eng')) {
        defaultId = '55';
      }

      _selectedSpeaker = SpeakerModel.speakerItem.firstWhere(
        (s) => s.speakerId == defaultId,
        orElse: () => SpeakerModel.speakerItem.first,
      );
    }
  }

  Future<void> _initializeDownloader() async {
    try {
      await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
    } catch (e) {
      debugPrint("FlutterDownloader init warning: $e");
    }
  }

  @override
  void dispose() {
    _editController.dispose();
    _player.dispose();
    super.dispose();
  }

  // ฟังก์ชันเมื่อมีการเลื่อนเปลี่ยนหน้า
  void _onPageChanged(int index) {
    setState(() {
      // 1. บันทึกสิ่งที่แก้ในหน้าเก่าลงไปใน List ก่อน
      widget.items[_currentIndex].script = _editController.text;

      // 2. เปลี่ยน index ไปหน้าใหม่
      _currentIndex = index;

      // 3. โหลดสคริปต์ของหน้าใหม่มาใส่ Controller
      _editController.text = widget.items[index].script;

      // 4. (Option) ถ้าหน้าใหม่มีเสียงแล้ว อาจจะโหลดรอไว้ตรงนี้ได้
    });
  }

  // ==========================================
  //  VIDEO GENERATION LOGIC (FIXED)
  // ==========================================
  Future<void> _handleCreateVideo() async {
    if (_editController.text.trim().isEmpty) return;

    // 1. Calculate Points based on your screenshots/logic
    int audioPoints = _editController.text.length;
    int videoPoints = 200;

    // 2. Show Confirmation Dialog
    showDialog(
      context: context,
      builder: (context) => GenskriptVideoCreationDialog(
        videoPoints: videoPoints,
        voicePoints: audioPoints,
        // ✅ FIX 1: Callback now accepts the selected 'codec' string
        onConfirm: (String selectedCodec) {
          _processVideoCreation(audioPoints, videoPoints, selectedCodec);
        },
      ),
    );
  }

  // ✅ FIX 2: Added 'videoCodec' parameter
  Future<void> _processVideoCreation(
      int audioPoints, int videoPoints, String videoCodec) async {
    // 3. Show Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.blue),
              SizedBox(height: 20.h),
              Text("กำลังเตรียมการสร้างวิดีโอ HQ...",
                  style: GoogleFonts.prompt(
                      fontSize: 16.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              Text("ปิดหน้าต่างนี้ได้เลย\nระบบจะประมวลผลต่อในเบื้องหลัง",
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );

    try {
      String? videoUrl = await VideoService.handleCreateVideo(
        scriptText: _editController.text,
        imageUrl: widget.items[_currentIndex].imageUrl,
        language: "th",
        audioPoints: audioPoints,
        videoPoints: videoPoints,
        // ✅ FIX 3: Pass the codec received from the dialog
        videoCodec: videoCodec,
      );

      if (mounted) Navigator.pop(context); // Close loading

      if (videoUrl != null) {
        _showVideoSuccessDialog(videoUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to create video.")));
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      logger.e("Video Create Error", error: e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void _showVideoSuccessDialog(String videoUrl) {
    showDialog(
      context: context,
      builder: (context) => GenskriptSuccessDialog(
        title: "Video Generation Started",
        subtitle:
            "Your video is being processed. You can download or share it below.",
      ),
    ).then((_) {
      // Bottom sheet to download/share the video result
      if (mounted) {
        showModalBottomSheet(
          context: context,
          builder: (c) => Container(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Video Options",
                    style: GoogleFonts.prompt(
                        fontSize: 18.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 20.h),
                ListTile(
                  leading: const Icon(Icons.download, color: Colors.blue),
                  title: Text("Download Video", style: GoogleFonts.prompt()),
                  onTap: () {
                    Navigator.pop(c);
                    _executeDownload(
                        url: videoUrl,
                        fileName:
                            "genskript_video_${DateTime.now().millisecondsSinceEpoch}.mp4",
                        onSuccess: () => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text("Video Downloaded!"))));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share, color: Colors.blue),
                  title: Text("Share Video", style: GoogleFonts.prompt()),
                  onTap: () {
                    Navigator.pop(c);
                    _downloadAndShare(videoUrl);
                  },
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  // ==========================================
  //  VOICE GENERATION LOGIC (Existing code kept intact)
  // ==========================================
  Future<void> _handleCreateVoice() async {
    if (_editController.text.trim().isEmpty) return;

    FocusManager.instance.primaryFocus?.unfocus();
    await Future.delayed(const Duration(milliseconds: 200));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    String? resultUrl;
    try {
      String langCode = 'th';
      if (widget.language.toLowerCase().contains('en')) langCode = 'en';

      resultUrl = await VoiceService.handleCreateVoice(
        scriptText: _editController.text,
        speed: _selectedSpeed,
        volume: _selectedVolume,
        languageValue: langCode,
        speakerId: _selectedSpeaker?.speakerId,
      );

      // บันทึก URL เสียงลงใน Item ปัจจุบันด้วย
      if (resultUrl != null) {
        widget.items[_currentIndex].audioUrl = resultUrl;
      }
    } catch (e) {
      logger.e("Error in handleCreateVoice wrapper", error: e);
    }

    if (mounted) Navigator.pop(context);

    if (resultUrl != null && resultUrl.isNotEmpty) {
      _currentFileName =
          "botnoi_genskript_${DateTime.now().millisecondsSinceEpoch}.mp3";

      // แสดง Success Dialog หรือเล่นเสียงทันที
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("สร้างเสียงสำเร็จ! กำลังเล่นเสียง..."),
          backgroundColor: Colors.green,
        ),
      );
      _loadAndShowDialog(resultUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("เกิดข้อผิดพลาดในการสร้างเสียง กรุณาลองใหม่อีกครั้ง"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _loadAndShowDialog(String url) async {
    try {
      await _player.stop();
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(Uri.encodeFull(url)),
          headers: {
            'Referer': 'https://voice.botnoi.ai/',
            'User-Agent': 'BotnoiVoiceMobile'
          },
        ),
      );
      if (mounted) _showAudioPlayerDialog(_player, url);
    } catch (e) {
      logger.e("Error loading audio", error: e);
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Could not play audio: $e")));
    }
  }

  void _showAudioPlayerDialog(AudioPlayer player, String url) {
    showDialog(
      context: context,
      builder: (context) => GenskriptAudioPlayerDialog(
        player: player,
        fileName: _currentFileName ?? "generated_audio.mp3",
        onDownload: () {
          Navigator.pop(context);
          _handleDownload(url,
              existingFileName: _currentFileName, isShare: false);
        },
        onShare: () {
          _handleDownload(url,
              existingFileName: _currentFileName, isShare: true);
        },
      ),
    );
  }

  // ==========================================
  //  SHARED DOWNLOAD & SHARE UTILS
  // ==========================================
  Future<void> _executeDownload(
      {required String url,
      required String fileName,
      required Function onSuccess}) async {
    bool hasPermission = false;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        hasPermission = true;
      } else {
        var status = await Permission.storage.request();
        hasPermission = status.isGranted;
      }
    } else {
      hasPermission = true;
    }

    if (!hasPermission) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please grant storage permission.")));
      return;
    }

    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists())
        directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    if (directory == null) return;

    try {
      await FlutterDownloader.enqueue(
        url: url,
        headers: {
          'Referer': 'https://voice.botnoi.ai/',
          'User-Agent': 'BotnoiVoiceMobile'
        },
        savedDir: directory.path,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
        saveInPublicStorage: true,
      );
      onSuccess();
    } catch (e) {
      logger.e("Download failed: $e");
    }
  }

  Future<void> _downloadAndShare(String url) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) => const Center(
            child: CircularProgressIndicator(color: Colors.white)));
    try {
      final tempDir = await getTemporaryDirectory();
      String ext = url.endsWith(".mp4") ? "mp4" : "mp3";
      final fileName = "share_${DateTime.now().millisecondsSinceEpoch}.$ext";
      final file = File('${tempDir.path}/$fileName');

      final response = await http.get(Uri.parse(url), headers: {
        'Referer': 'https://voice.botnoi.ai/',
        'User-Agent': 'BotnoiVoiceMobile'
      });

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        if (mounted) Navigator.pop(context);
        await Share.shareXFiles([XFile(file.path)],
            text: 'Created with Genskript!');
      } else {
        throw Exception("Share download failed");
      }
    } catch (e) {
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);
      logger.e("Share failed", error: e);
    }
  }

  Future<void> _handleDownload(String url,
      {String? existingFileName, bool isShare = false}) async {
    if (isShare) {
      await _downloadAndShare(url);
      return;
    }

    final int estimatedPoints = _editController.text.length * 1;

    if (mounted) {
      showDialog(
        context: context,
        builder: (dialogContext) => GenskriptDownloadOptionsDialog(
          points: estimatedPoints,
          onConfirm: (selectedExtension) async {
            final timestamp = DateTime.now().millisecondsSinceEpoch;
            final finalFileName =
                "botnoi_genskript_$timestamp.$selectedExtension";

            await _executeDownload(
                url: url,
                fileName: finalFileName,
                onSuccess: () {
                  if (!mounted) return;
                  showDialog(
                    context: context,
                    builder: (context) => const GenskriptSuccessDialog(
                      title: "Download Successful",
                      subtitle: "File saved to device successfully.",
                    ),
                  );
                });
          },
        ),
      );
    }
  }

  // --- TRANSLATION LOGIC (Helper) ---
  void _showLanguagePicker(BuildContext context) {
    String? tempSelected = "";
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FB),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  const Text("Select Language",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54)),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: ListView.builder(
                        itemCount: AppData.languages.length,
                        itemBuilder: (context, index) {
                          final lang = AppData.languages[index];
                          bool isSelected = tempSelected == lang['name'];
                          return GestureDetector(
                            onTap: () {
                              setModalState(() => tempSelected = lang['name']!);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? const LinearGradient(colors: [
                                        Color(0xFFE1D5F5),
                                        Color(0xFFB3E5FC)
                                      ])
                                    : null,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                    backgroundColor: Colors.grey.shade100,
                                    child: Text(lang['flag']!,
                                        style: const TextStyle(fontSize: 20))),
                                title: Text(lang['name']!,
                                    style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: Colors.black87)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: tempSelected!.isEmpty
                          ? null
                          : () => Navigator.pop(context, tempSelected),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text("Confirm",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((selectedLang) {
      if (selectedLang != null) _executeTranslation(selectedLang);
    });
  }

  void _executeTranslation(String targetLang) async {
    if (userPoints < 100) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Insufficient Points")));
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
            child: CircularProgressIndicator(color: Colors.white)));
    try {
      String? result = await TranslationService.handleTranslate(
          currentScript: _editController.text,
          targetLanguageName: targetLang,
          imageUrl: widget.items[_currentIndex].imageUrl);
      if (mounted) Navigator.pop(context);
      if (result != null) {
        setState(() {
          _editController.text = result;
          widget.items[_currentIndex].script = result;
          userPoints -= 100;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Translated to $targetLang successfully!")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Translation Failed")));
      }
    } catch (e) {
      logger.e("Translation Error", error: e);
      if (mounted) Navigator.pop(context);
    }
  }

  // ฟังก์ชันสำหรับปุ่มดาวน์โหลดทั้งหมด
  void _showDownloadAllDialog() {
    // คำนวณพอยท์ทั้งหมดจากทุกสไลด์ที่มีข้อความ (จำนวนตัวอักษรรวม)
    int totalPoints =
        widget.items.fold(0, (sum, item) => sum + item.script.trim().length);

    if (totalPoints == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ไม่มีข้อความให้สร้างเสียง")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => GenskriptDownloadAllDialog(
        points: totalPoints,
        onConfirm: (String extension, DownloadMode mode) async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (loadingContext) => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );

          // เตรียมข้อมูล Payload ให้เหมือนในรูป API JSON ที่แนบมา
          String langCode =
              widget.language.toLowerCase().contains('en') ? 'en' : 'th';
          String speakerId =
              _selectedSpeaker?.speakerId ?? (langCode == 'en' ? '55' : '5');
          String randomId =
              DateTime.now().millisecondsSinceEpoch.toString().substring(5);
          String workspaceId = "genskript_$randomId";

          // ตรวจสอบและเตรียมลิงก์ไฟล์เสียงของทุกสไลด์ให้ครบ (ใช้ร่วมกันทั้ง Zip และ Single)
          List<String> validAudioUrls = [];
          for (int i = 0; i < widget.items.length; i++) {
            final item = widget.items[i];
            if (item.script.trim().isEmpty) continue;

            if (item.audioUrl != null && item.audioUrl!.isNotEmpty) {
              // ถ้ามีเสียงถูกสร้างไว้แล้ว ดึงมาใช้ได้เลย
              validAudioUrls.add(item.audioUrl!);
            } else {
              // ถ้าย้งไม่มีเสียง ให้เรียก API สร้างเสียงขึ้นมาใหม่
              String? newAudio = await VoiceService.handleCreateVoice(
                scriptText: item.script,
                speed: _selectedSpeed,
                volume: _selectedVolume,
                languageValue: langCode,
                speakerId: speakerId,
              );

              if (newAudio != null && newAudio.isNotEmpty) {
                setState(() {
                  item.audioUrl = newAudio; // อัปเดตกลับไปที่หน้า UI ด้วย
                });
                validAudioUrls.add(newAudio);
              }
            }
          }

          // ถ้าพยายามสร้างแล้ว แต่ยังไม่มีไฟล์เสียงเลยสักหน้า ให้หยุดทำงาน
          if (validAudioUrls.isEmpty) {
            if (mounted) Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      "เกิดข้อผิดพลาด ไม่สามารถเตรียมไฟล์เสียงสำหรับการดาวน์โหลดได้")),
            );
            return;
          }

          // แยกการทำงานระหว่าง Zip กับ Single File
          if (mode == DownloadMode.zip) {
            String finalFileName = "botnoi_genskript_$randomId.zip";

            String? savedPath = await DownloadService.createLocalZip(
              audioUrls: validAudioUrls,
              fileName: finalFileName,
              extension: extension, //ส่งนามสกุลไฟล์เข้าไปแพ็กใน Zip
            );

            if (mounted) Navigator.pop(context); // ปิด Loading Dialog

            if (savedPath != null && mounted) {
              showDialog(
                context: context,
                builder: (successContext) => const GenskriptSuccessDialog(
                  title: "ดาวน์โหลดสำเร็จ",
                  subtitle:
                      "ไฟล์ Zip ของคุณถูกบันทึกลงในโฟลเดอร์ Download แล้ว",
                ),
              );
            } else if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("เกิดข้อผิดพลาดในการสร้างไฟล์ Zip")),
              );
            }
          } else {
            //  เรียก API ใหม่ สำหรับรวมไฟล์หลายสไลด์ให้เป็นไฟล์เดียว (Merge)
            String? downloadUrl = await DownloadService.mergeAudioToSingleFile(
              audioUrls: validAudioUrls,
              extension: extension,
              workspaceId: workspaceId,
            );

            if (mounted) Navigator.pop(context); // ปิด Loading

            if (downloadUrl != null && downloadUrl.isNotEmpty && mounted) {
              String finalFileName = "botnoi_genskript_$randomId.$extension";
              await _executeDownload(
                url: downloadUrl,
                fileName: finalFileName,
                onSuccess: () {
                  if (mounted) {
                    showDialog(
                      context: context,
                      builder: (successContext) => const GenskriptSuccessDialog(
                        title: "ดาวน์โหลดสำเร็จ",
                        subtitle: "ไฟล์ของคุณถูกบันทึกลงเครื่องเรียบร้อยแล้ว",
                      ),
                    );
                  }
                },
              );
            } else if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        "เกิดข้อผิดพลาด หรือ API ไม่ได้ส่ง URL ดาวน์โหลดกลับมา")),
              );
            }
          }
        },
      ),
    );
  }

  // --- UI WIDGETS ---
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> footerActions = [
      {
        'label': "Link Script",
        'icon': Icons.link,
        'action': () => ScriptService.handleJoinScript()
      },
      {
        'label': "Download All",
        'icon': Icons.download_rounded,
        'action': () => _showDownloadAllDialog()
      },
      {
        'label': "Translate",
        'icon': Icons.translate,
        'action': () => _showLanguagePicker(context)
      },
      {
        'label': "Create Free Video",
        'icon': Icons.card_giftcard,
        'action': () => VideoService.handleFreeVideo(context)
      },
      {
        'label': "Auto Voice",
        'icon': Icons.settings_voice,
        'action': () => _handleCreateVoice()
      },
      {
        'label': "Create Video",
        'icon': Icons.movie_creation_outlined,
        'action': () => _handleCreateVideo()
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),

            // เพิ่มส่วนแสดงผล Image Carousel
            _buildImageCarousel(),
            const SizedBox(height: 10),
            _buildPageIndicator(),
            const SizedBox(height: 10),

            _buildScriptEditor(),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildDropdownSelector(
                    icon: Icons.speed,
                    currentValue: _selectedSpeed,
                    options: speedOptions,
                    title: "Speed",
                    onChanged: (val) => setState(() => _selectedSpeed = val)),
                const SizedBox(width: 8),
                _buildDropdownSelector(
                    icon: Icons.volume_up_outlined,
                    currentValue: _selectedVolume,
                    options: volumeOptions,
                    title: "Volume",
                    onChanged: (val) => setState(() => _selectedVolume = val)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${_editController.text.length} PT",
                    style: const TextStyle(color: Colors.grey, fontSize: 14)),
                // ปุ่มสร้างเสียงจะสร้างสำหรับหน้านี้เท่านั้น
                _buildGenerateButton(),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: footerActions.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: item['action'] as VoidCallback,
                      icon: Icon(item['icon'] as IconData,
                          size: 22, color: Colors.blue),
                      label: Text(item['label'] as String,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black87,
                          backgroundColor: Colors.white,
                          elevation: 0,
                          side: BorderSide(color: Colors.grey.shade200),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 6),
            Center(
                child: TextButton.icon(
                    onPressed: widget.onBack,
                    icon: const Icon(Icons.arrow_back, size: 16),
                    label: const Text("Back to Form"),
                    style: TextButton.styleFrom(foregroundColor: Colors.blue))),
          ],
        ),
      ),
    );
  }

  // Widget ใหม่สำหรับแสดงรูปหลายรูป
  Widget _buildImageCarousel() {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 220,
      child: PageView.builder(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        itemCount: widget.items.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.shade200,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  // เช็คว่าต้องมี URL และต้องขึ้นต้นด้วย http (กัน URL มั่ว)
                  child: (item.imageUrl.isNotEmpty &&
                          item.imageUrl.startsWith('http'))
                      ? Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // แสดง Icon แทนเมื่อโหลดรูปไม่ได้ (แก้ปัญหา SocketException)
                            return const Center(
                              child: Icon(Icons.broken_image,
                                  size: 50, color: Colors.grey),
                            );
                          },
                        )
                      : const Center(
                          // กรณี URL ว่างเปล่า
                          child: Icon(Icons.image_not_supported,
                              size: 50, color: Colors.grey),
                        ),
                ),
                // เพิ่ม Overlay บอกลำดับรูป
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${index + 1}/${widget.items.length}",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget แสดงจุด (Indicator) หรือปุ่มเลื่อน
  Widget _buildPageIndicator() {
    if (widget.items.length <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 16),
          onPressed: _currentIndex > 0
              ? () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                }
              : null,
        ),
        Text("${_currentIndex + 1} of ${widget.items.length}",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey[700])),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: _currentIndex < widget.items.length - 1
              ? () => _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut)
              : null,
        ),
      ],
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildScriptEditor() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: _editController,
        maxLines: 12,
        minLines: 5,
        cursorColor: Colors.blue,
        style:
            const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
        onChanged: (text) {
          setState(() {
            // อัปเดต Model ทันทีที่พิมพ์
            if (widget.items.isNotEmpty) {
              widget.items[_currentIndex].script = text;
            }
          });
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Click to start writing...",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      height: 36,
      child: ElevatedButton.icon(
        onPressed:
            _editController.text.trim().isEmpty ? null : _handleCreateVoice,
        icon:
            const Icon(Icons.record_voice_over, size: 18, color: Colors.white),
        label: const Text("สร้างเสียง",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildDropdownSelector({
    required IconData icon,
    required String currentValue,
    required List<String> options,
    required String title,
    required Function(String) onChanged,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => _showTranslatorStylePicker(
            context, title, options, currentValue, onChanged),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: Colors.black87),
              const SizedBox(width: 8),
              Text(currentValue,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500)),
              const SizedBox(width: 6),
              const Icon(Icons.keyboard_arrow_down,
                  size: 20, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  void _showTranslatorStylePicker(BuildContext context, String title,
      List<String> options, String selectedValue, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final item = options[index];
                  final isSelected = item == selectedValue;
                  return ListTile(
                    title: Text(item,
                        style: TextStyle(
                            color: isSelected ? Colors.blue : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal)),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.blue)
                        : null,
                    onTap: () {
                      onSelect(item);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _handleSpeakerSelectorTap() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        MarAdsSpeakerSelectorButton(
          selectedSpeaker: _selectedSpeaker,
          onTap: _handleSpeakerSelectorTap,
        ),
        const Spacer(),
        _buildIconButton(Icons.copy_outlined, () {
          ScriptService.copyToClipboard(_editController.text, context);
        }),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback tap,
      {Color color = Colors.grey}) {
    return InkWell(
      onTap: tap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}
