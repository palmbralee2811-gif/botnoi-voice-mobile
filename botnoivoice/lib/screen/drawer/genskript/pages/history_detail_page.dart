import 'package:botnoivoice/screen/drawer/genskript/services/download_service.dart';
import 'package:botnoivoice/screen/drawer/genskript/services/history_service.dart';
import 'package:botnoivoice/screen/drawer/genskript/services/voice_service.dart';
import 'package:botnoivoice/screen/drawer/genskript/widgets/genskript_download_all_dialog.dart';
import 'package:botnoivoice/screen/drawer/genskript/widgets/genskript_download_options_dialog.dart';
import 'package:botnoivoice/screen/drawer/genskript/widgets/genskript_inline_audio_player.dart';
import 'package:botnoivoice/screen/drawer/genskript/widgets/genskript_success_dialog.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/models/mar_ads_speaker_selection_modal.dart';
import 'package:botnoivoice/screen/main/speaker/entities/speaker_entity.dart';
import 'package:botnoivoice/screen/main/speaker/model/speaker_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class HistoryDetailPage extends StatefulWidget {
  final dynamic item;
  final VoidCallback onBack;

  const HistoryDetailPage({
    super.key,
    required this.item,
    required this.onBack,
  });

  @override
  State<HistoryDetailPage> createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  SpeakerEntity? _selectedSpeaker;
  List<dynamic> _localScripts = [];
  final List<TextEditingController> _controllers = [];
  List<bool> _isEditing = [];
  int? _generatingIndex;

  @override
  void initState() {
    super.initState();
    // 1. คัดลอกสคริปต์มาไว้ที่ Local เพื่อให้อัปเดต UI ได้
    _localScripts = List.from(widget.item['scripts'] ?? []);

    // 2. สร้าง Controller สำหรับแต่ละกล่องข้อความ
    for (var script in _localScripts) {
      _controllers.add(TextEditingController(text: script['script'] ?? ""));
    }

    // สร้างตัวแปรเช็คว่ากล่องไหนถูกแก้บ้าง (เริ่มต้นเป็น false ทุกกล่อง)
    _isEditing = List.generate(_localScripts.length, (index) => false);

    // 3. หาข้อมูล Speaker เริ่มต้นจาก ID
    String speakerId = widget.item['speaker']?.toString() ?? "5";
    if (_localScripts.isNotEmpty && _localScripts[0]['speaker'] != null) {
      speakerId = _localScripts[0]['speaker'].toString();
    }

    @override
    void dispose() {
      for (var controller in _controllers) {
        controller.dispose();
      }
      super.dispose();
    }

    try {
      if (SpeakerModel.speakerItem.isNotEmpty) {
        _selectedSpeaker = SpeakerModel.speakerItem.firstWhere(
          (s) => s.speakerId == speakerId,
          orElse: () => SpeakerModel.speakerItem.first,
        );
      }
    } catch (e) {
      debugPrint("Speaker map error: $e");
    }
  }

  // เพิ่มฟังก์ชันสำหรับดาวน์โหลดไฟล์แบบเดียวกับ ResultScreen
  Future<void> _downloadFile(String url, String fileName) async {
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
      // ใช้ HTTP โหลดไฟล์และเขียนลงเครื่องโดยตรง (แก้ปัญหา Plugin Not Initialized)
      // 1. Encode ลิงก์เพื่อป้องกัน S3 เตะออกหากมีช่องว่างหรือตัวอักษรพิเศษ
      final encodedUrl = Uri.parse(url).toString();
      final request = http.Request('GET', Uri.parse(encodedUrl));

      // 2. แนบ Referer และ User-Agent ให้ตรงกับที่ระบบ S3 ของ Botnoi บังคับเป๊ะๆ
      request.headers.addAll({
        'Referer': 'https://voice.botnoi.ai/',
        'User-Agent': 'BotnoiVoiceMobile',
        'Accept': '*/*',
      });
      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        File file = File('${directory.path}/$fileName');
        var fileStream = file.openWrite();

        // ทยอยเขียนไฟล์ลงเครื่อง (รองรับไฟล์ขนาดใหญ่แบบไม่กินแรม)
        await response.stream.pipe(fileStream);
        await fileStream.flush();
        await fileStream.close();

        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => const GenskriptSuccessDialog(
              title: "ดาวน์โหลดสำเร็จ",
              subtitle: "ไฟล์ถูกบันทึกลงในเครื่องของคุณเรียบร้อยแล้ว",
            ),
          );
        }
      } else {
        throw Exception("Download Error Status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Download failed: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("เกิดข้อผิดพลาดในการดาวน์โหลดไฟล์")),
        );
      }
    }
  }

  // ฟังก์ชันเปลี่ยนนักพากย์
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
            // ลบเสียงเดิมของทุกสไลด์เพื่อบังคับให้ผู้ใช้กดสร้างเสียงด้วยนักพากย์ใหม่
            for (var script in _localScripts) {
              script['audio'] = "";
            }
          });
        },
      ),
    );
  }

  // ฟังก์ชันสร้างเสียงเฉพาะจุดที่ขาดไป
  Future<void> _generateAudioForSlide(int index, String scriptText) async {
    setState(() => _generatingIndex = index);

    try {
      // ตรวจสอบภาษา
      String langCode = widget.item['language']?['value'] ?? 'th';
      if (langCode.isEmpty) langCode = 'th';

      String? newAudioUrl = await VoiceService.handleCreateVoice(
        scriptText: scriptText,
        speed: "1x",
        volume: "100%",
        languageValue: langCode,
        speakerId: _selectedSpeaker?.speakerId ?? "5",
      );

      if (newAudioUrl != null && newAudioUrl.isNotEmpty) {
        setState(() {
          _localScripts[index]['audio'] = newAudioUrl;
        });

        // (Optional) อัปเดตข้อมูลกลับไปที่ API ประวัติ เพื่อให้บันทึกถาวร
        Map<String, dynamic> updatedItem = Map.from(widget.item);
        updatedItem['scripts'] = _localScripts;
        String workspaceId =
            widget.item['genskript_id'] ?? widget.item['id'] ?? "";
        if (workspaceId.isNotEmpty) {
          HistoryService.updateWorkspace(workspaceId, updatedItem);
        }
      } else {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("สร้างเสียงไม่สำเร็จ")));
      }
    } catch (e) {
      debugPrint("Generate error: $e");
    } finally {
      if (mounted) setState(() => _generatingIndex = null);
    }
  }

  // ฟังก์ชันวนลูปสร้างเสียงเฉพาะจุดที่ยังไม่มี
  Future<void> _generateMissingAudio() async {
    for (int i = 0; i < _localScripts.length; i++) {
      String audio = _localScripts[i]['audio'] ?? "";
      String scriptText = _localScripts[i]['script'] ?? "";
      // ตรวจสอบว่าช่องไหนไม่มีเสียง และมีข้อความให้สร้าง
      if (audio.isEmpty && scriptText.trim().isNotEmpty) {
        await _generateAudioForSlide(i, scriptText);
      }
    }

    // เช็คว่ามีสไลด์ไหนที่ "มีข้อความ" แต่ "ยังไม่มีเสียง" หลงเหลืออยู่หรือไม่
    bool stillMissing = _localScripts.any((s) =>
        (s['audio'] == null || s['audio'].toString().isEmpty) &&
        (s['script'] != null && s['script'].toString().trim().isNotEmpty));
    if (!stillMissing && mounted) {
      _showDownloadAllDialog(); // ครบแล้วไปหน้าดาวน์โหลดต่อ
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("สร้างเสียงไม่สำเร็จบางรายการ")));
    }
  }

  // ฟังก์ชันแสดงหน้าต่างเลือกสกุลไฟล์ดาวน์โหลด
  void _showDownloadAllDialog() {
    // คำนวณพอยท์ถ้ามีครบแล้วจะเป็น 0 PT
    int totalPoints = 0;
    for (var item in _localScripts) {
      String audio = item['audio']?.toString() ?? "";
      String scriptText = item['script']?.toString() ?? "";
      if (audio.isEmpty && scriptText.trim().isNotEmpty) {
        totalPoints += scriptText.length;
      }
    }

    showDialog(
      context: context,
      builder: (dialogContext) => GenskriptDownloadAllDialog(
        points: totalPoints,
        onConfirm: (extension, mode) async {
          if (!mounted) return;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (loadingContext) => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );

          // ตรวจสอบและสร้างเสียงสำหรับสไลด์ที่ยังไม่มี
          String langCode = widget.item['language']?['value'] ?? 'th';
          if (langCode.isEmpty) langCode = 'th';

          for (int i = 0; i < _localScripts.length; i++) {
            String audio = _localScripts[i]['audio']?.toString() ?? "";
            String scriptText = _localScripts[i]['script']?.toString() ?? "";

            if (audio.isEmpty && scriptText.trim().isNotEmpty) {
              String? newAudioUrl = await VoiceService.handleCreateVoice(
                scriptText: scriptText,
                speed: "1x",
                volume: "100%",
                languageValue: langCode,
                speakerId: _selectedSpeaker?.speakerId ?? "5",
              );

              if (newAudioUrl != null && newAudioUrl.isNotEmpty) {
                setState(() {
                  _localScripts[i]['audio'] = newAudioUrl;
                });
              }
            }
          }

          // ดึง URL เสียงทั้งหมดที่พร้อมใช้งาน
          List<String> validAudioUrls = _localScripts
              .where(
                  (s) => s['audio'] != null && s['audio'].toString().isNotEmpty)
              .map((s) => s['audio'].toString())
              .toList();

          if (mode == DownloadMode.zip) {
            // สร้างไฟล์ Zip ภายในแอป (Local) โดยใช้ Library
            String finalFileName =
                "botnoi_genskript_${DateTime.now().millisecondsSinceEpoch}.zip";
            String? savedPath = await DownloadService.createLocalZip(
              audioUrls: validAudioUrls,
              fileName: finalFileName,
              extension: extension,
            );

            if (mounted) context.pop();

            if (savedPath != null && mounted) {
              showDialog(
                context: context,
                builder: (successContext) => const GenskriptSuccessDialog(
                  title: "ดาวน์โหลดสำเร็จ",
                  subtitle: "ไฟล์ Zip ของคุณถูกบันทึกลงในเครื่องเรียบร้อยแล้ว",
                ),
              );
            } else if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("เกิดข้อผิดพลาดในการสร้างไฟล์ Zip")));
            }
          } else {
            // โหมด Merge รวมไฟล์ผ่าน API
            String workspaceId = widget.item['genskript_id']?.toString() ??
                widget.item['id']?.toString() ??
                "genskript_merge_${DateTime.now().millisecondsSinceEpoch}";

            String? resultUrl = await DownloadService.mergeAudioToSingleFile(
              audioUrls: validAudioUrls,
              extension: extension,
              workspaceId: workspaceId,
            );

            if (mounted) context.pop();

            if (resultUrl != null && mounted) {
              _downloadFile(resultUrl,
                  "botnoi_genskript_${DateTime.now().millisecondsSinceEpoch}.$extension");
            } else if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("เกิดข้อผิดพลาดในการรวมไฟล์ (Merge)")));
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Extract Data
    String? videoUrl =
        widget.item['video_url'] ?? widget.item['final_video_url'];
    // Fallback if video is inside script object
    if (videoUrl == null && _localScripts.isNotEmpty) {
      videoUrl = _localScripts[0]['video_url'];
    }

    // ดึงชื่อภาษาไทยมาแสดงเป็นหลัก ถ้าไม่มีค่อยขยับไปใช้ชื่อภาษาอังกฤษ
    String speakerName = "เลือกนักพากย์";
    if (_selectedSpeaker != null) {
      speakerName = _selectedSpeaker!.thaiName.isNotEmpty
          ? _selectedSpeaker!.thaiName
          : (_selectedSpeaker!.engName.isNotEmpty
              ? _selectedSpeaker!.engName
              : _selectedSpeaker!.speakerName);
    }

    // ใช้ faceImage เพื่อให้รูปหน้าซูมพอดีกับกรอบวงกลม ถ้าไม่มีค่อยใช้ image ปกติ
    String speakerImage = (_selectedSpeaker?.faceImage.isNotEmpty == true)
        ? _selectedSpeaker!.faceImage
        : (_selectedSpeaker?.image ?? "");

    return Column(
      children: [
        // SCROLLABLE CONTENT
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Speaker Header (Top Left)
                InkWell(
                  onTap: _handleSpeakerSelectorTap,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: speakerImage.isNotEmpty
                              ? NetworkImage(speakerImage)
                              : null,
                          child: speakerImage.isEmpty
                              ? const Icon(Icons.person,
                                  size: 18, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(speakerName,
                            style: GoogleFonts.prompt(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87)),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down,
                            color: Colors.black87, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Main Cards (List of Scripts)
                ListView.separated(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(), // ให้ scroll ไปพร้อมกับหน้าหลัก
                  itemCount: _localScripts.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final scriptData = _localScripts[index];
                    final scriptText = scriptData['script'] ?? "";
                    final audioUrl = scriptData['audio'] ?? "";
                    final points = audioUrl.isNotEmpty ? 0 : scriptText.length;

                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card Header: #1 and Copy Icon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("#${index + 1}",
                                  style: GoogleFonts.prompt(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  // แสดงปุ่มแก้ไขเฉพาะตอนที่ยังไม่ได้อยู่ในโหมดแก้ไข
                                  if (!_isEditing[index])
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined,
                                          size: 20, color: Colors.blue),
                                      onPressed: () {
                                        setState(() {
                                          _isEditing[index] =
                                              true; // เปิดโหมดแก้ไข
                                        });
                                      },
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.copy_outlined,
                                        size: 20, color: Colors.grey),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                          text: _controllers[index].text));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text("Copied to clipboard")));
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Editable Script Textbox
                          TextField(
                            controller: _controllers[index],
                            maxLines: null,
                            readOnly: !_isEditing[index],
                            style: GoogleFonts.prompt(
                                fontSize: 14,
                                height: 1.6,
                                color: Colors.black87),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: _isEditing[index]
                                  ? Colors.grey.shade50
                                  : Colors.white,
                              contentPadding: const EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: _isEditing[index]
                                        ? Colors.grey.shade300
                                        : Colors.transparent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: _isEditing[index]
                                        ? Colors.grey.shade400
                                        : Colors.transparent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // ปุ่ม บันทึก / ยกเลิก (แสดงเมื่อกดเข้าโหมดแก้ไข)
                          if (_isEditing[index]) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      // คืนค่าเดิมจาก _localScripts ให้ Textbox
                                      _controllers[index].text =
                                          _localScripts[index]['script'] ?? "";
                                      _isEditing[index] = false; // ปิดโหมดแก้ไข
                                      FocusScope.of(context)
                                          .unfocus(); // ซ่อนคีย์บอร์ด
                                    });
                                  },
                                  child: Text("ยกเลิก",
                                      style: GoogleFonts.prompt(
                                          color: Colors.grey.shade600,
                                          fontSize: 13)),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      // 1. บันทึกข้อความใหม่ทับของเดิม
                                      _localScripts[index]['script'] =
                                          _controllers[index].text.trim();
                                      // 2. ลบเสียงเก่าทิ้งเพื่อให้ปุ่มสร้างเสียงสีฟ้าโผล่มา
                                      _localScripts[index]['audio'] = "";
                                      _isEditing[index] = false; // ปิดโหมดแก้ไข
                                      FocusScope.of(context)
                                          .unfocus(); // ซ่อนคีย์บอร์ด
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                    minimumSize: const Size(
                                        0, 36), // ปรับขนาดปุ่มให้กำลังดี
                                  ),
                                  child: Text("บันทึก",
                                      style: GoogleFonts.prompt(
                                          color: Colors.white, fontSize: 13)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],

                          // เปลี่ยนส่วนล่างสุดให้เหมือน UI ใน ResultScreen
                          if (audioUrl.isNotEmpty) ...[
                            GenskriptInlineAudioPlayer(
                              key: ValueKey(
                                  audioUrl), // บังคับรีโหลดเมื่อ URL เปลี่ยน
                              audioUrl: audioUrl,
                              points: points,
                              onDownload: () {
                                // แสดง Dialog ดาวน์โหลดรายการเดี่ยว
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) =>
                                      GenskriptDownloadOptionsDialog(
                                    points: points,
                                    onConfirm: (extension) {
                                      // สำหรับรายการเดี่ยว โหลดจากลิงก์ S3 ตรงๆ ได้เลย (เพราะฟังก์ชัน _downloadFile เราหลบ 403 ให้แล้ว)
                                      _downloadFile(audioUrl,
                                          "slide_${index + 1}_${DateTime.now().millisecondsSinceEpoch}.$extension");
                                    },
                                  ),
                                );
                              },
                            )
                          ] else ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("$points PT",
                                    style: GoogleFonts.prompt(
                                        color: Colors.grey, fontSize: 12)),
                                const SizedBox(width: 12),
                                SizedBox(
                                  height: 32,
                                  child: ElevatedButton(
                                    onPressed: _generatingIndex != null ||
                                            scriptText.trim().isEmpty
                                        ? null
                                        : () => _generateAudioForSlide(
                                            index, scriptText),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF00BFFF),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      elevation: 0,
                                    ),
                                    child: _generatingIndex == index
                                        ? const SizedBox(
                                            // แสดงหัวหมุนๆ ตอนกำลังสร้างเสียงเฉพาะปุ่มนี้
                                            width: 14,
                                            height: 14,
                                            child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2),
                                          )
                                        : Text("สร้างเสียง",
                                            style: GoogleFonts.prompt(
                                                color: Colors.white,
                                                fontSize: 12)),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // 3. Footer Section (Pinned to bottom)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Download Buttons Row (แบ่งโหลดเสียง กับ โหลดวิดีโอ)
              Row(
                children: [
                  // ปุ่มดาวน์โหลดเสียงทั้งหมด (เรียก Dialog Zip/Merge)
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xFF9340FF), Color(0xFF34BDFA)]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: _showDownloadAllDialog,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: Text("โหลดเสียงทั้งหมด",
                            style: GoogleFonts.prompt(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                  if (videoUrl != null) ...[
                    const SizedBox(width: 12),
                    // ปุ่มดาวน์โหลดวิดีโอ (ถ้ามีวิดีโอ)
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(12)),
                        child: ElevatedButton(
                          onPressed: () {
                            String ext =
                                videoUrl!.split('.').last.split('?').first;
                            if (ext.length > 4 || ext.isEmpty) ext = 'mp4';
                            _downloadFile(videoUrl,
                                "genskript_video_${DateTime.now().millisecondsSinceEpoch}.$ext");
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: Text("ดาวน์โหลดวิดีโอ",
                              style: GoogleFonts.prompt(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),

              // Back Button
              TextButton.icon(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back,
                    size: 18, color: Colors.black54),
                label: Text("กลับไปดูประวัติ",
                    style: GoogleFonts.prompt(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
