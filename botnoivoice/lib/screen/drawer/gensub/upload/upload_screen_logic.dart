import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:botnoivoice/screen/drawer/gensub/models/project_model.dart';

// Import Standalone API Functions ใหม่ที่คุณสร้าง
import 'package:botnoivoice/screen/drawer/gensub/service/project_audio_api.dart';
import 'package:botnoivoice/screen/drawer/gensub/service/project_asr_api.dart';
import 'package:botnoivoice/screen/drawer/gensub/service/project_gensub_api.dart';

String _extractSeconds(String input, {Duration? fallback}) {
  if (input.contains("ไม่จำกัด")) {
    return fallback != null ? fallback.inSeconds.toString() : "3600";
  }
  final number = RegExp(r'[\d.]+').firstMatch(input)?.group(0);
  return number ?? (fallback != null ? fallback.inSeconds.toString() : "10");
}

/// Controller จัดการเลือกไฟล์, คำนวณความยาวไฟล์, และอัปโหลด/สร้าง workspace
class UploadLogic {
  // final String apiToken; // <<< ลบออก

  final Function(ProjectModel) onProjectCreated;
  final String currentUserId;

  String? filePath;
  Duration? audioDuration;
  String? transcribeStatus;

  String selectedLanguage = "TH";
  String selectedLanguageName = "select_languages.thai".tr();
  String selectedLanguageImage = 'assets/images/national_flag/thai.png';
  String maxSegmentDuration = "10 วินาที";
  String maxSilenceDuration = "0.3 วินาที";

  bool _isPicking = false;

  ProjectModel? lastProject;

  UploadLogic({
    // required this.apiToken, // <<< ลบออก
    required this.onProjectCreated,
    this.currentUserId = "YOUR_USER_ID",
  });

  /// เลือกไฟล์เสียงผ่าน FilePicker และอ่านความยาวไฟล์ด้วย just_audio (ไม่มี API call)
  Future<void> pickFile() async {
    if (_isPicking) return; // กันการกดซ้ำ
    _isPicking = true;

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'm4a', 'aac'],
      );

      if (result != null && result.files.single.path != null) {
        final selectedPath = result.files.single.path!;
        final player = AudioPlayer();
        await player.setFilePath(selectedPath);
        final d = player.duration ?? Duration.zero;

        filePath = selectedPath;
        audioDuration = d;
        transcribeStatus = null;

        await player.dispose();
      }
    } catch (e) {
      debugPrint("pickFile error: $e");
    } finally {
      _isPicking = false;
    }
  }

  /// ล้างไฟล์ที่เลือก (ไม่มี API call)
  void clearFile() {
    filePath = null;
    audioDuration = null;
    transcribeStatus = null;
  }

  /// อัปโหลดไฟล์และถอดเสียง (return true ถ้าสำเร็จ)
  Future<bool> transcribeFile(
    WidgetRef ref,
    BuildContext context,
  ) async {
    // <<< ใช้ BuildContext
    if (filePath == null) return false;

    transcribeStatus = "text_to_gensub.transcribe_status".tr();

    try {
      // 1) upload audio → gensub (เรียกใช้ฟังก์ชันใหม่ พร้อมส่ง context)
      final uploadResult = await uploadAudioToGensub(
        ref,
        file: File(filePath!),
      );
      debugPrint(" upload result = $uploadResult");

      // 2) insert workspace → สร้าง project_id (เรียกใช้ฟังก์ชันใหม่ พร้อมส่ง context)
      final projectName =
          filePath!.split(Platform.pathSeparator).last.split('.').first;
      final durationStr =
          _formatDuration(audioDuration ?? Duration.zero); // MM:SS
      final insertResult = await insertAsrWorkspace(
        ref: ref, // ส่ง context
        projectName: projectName,
        cer: 0.0,
        pointAdd: 0,
        totalPoint: 0,
        duration: durationStr, // ส่ง MM:SS
      );
      debugPrint(" insert workspace result = $insertResult");

      final projectId = insertResult["data"]?["project_id"];
      final realUserId = insertResult["data"]?["user_id"];

      // 3) cut audio → chunk อัตโนมัติ (เรียกใช้ฟังก์ชันใหม่ พร้อมส่ง context)
      final cutResult = await cutAudio(
        ref,
        filePath: filePath!,
        projectId: projectId,
        projectName: projectName,
        cutType: "sec",
        chunk: _extractSeconds(maxSegmentDuration, fallback: audioDuration),
        durations: (audioDuration?.inSeconds ?? 0)
            .toString(), // ✅ ใช้ความยาวจริงของไฟล์
        maxDuration:
            _extractSeconds(maxSegmentDuration, fallback: audioDuration),
        maxSilence: _extractSeconds(maxSilenceDuration,
            fallback: const Duration(seconds: 1)),
        language: "th",
      );
      debugPrint(" cut audio result = $cutResult");

      // 4) get all chunks → ได้ segments (เรียกใช้ฟังก์ชันใหม่ พร้อมส่ง context)
      final chunksRes = await getAllChunks(
        ref,
        projectId: projectId,
      );
      final rawSegments = (chunksRes['data'] as List<dynamic>? ?? []);

      // Try to extract immediate transcription from uploadResult so UI can show text right away
      String? uploadText;
      try {
        final bodyStr = uploadResult['body'];
        if (bodyStr != null && bodyStr.isNotEmpty) {
          final parsed = json.decode(bodyStr);
          uploadText = parsed['data']?['text']?.toString();
        }
      } catch (_) {
        uploadText = null;
      }

      final segments = rawSegments.map<Map<String, dynamic>>((s) {
        final durationStr = (s['duration'] ?? '') as String;
        final parts = durationStr.split(' - ');
        final start = parts.isNotEmpty ? _parseTime(parts[0]) : 0.0;
        final end = parts.length > 1
            ? _parseTime(parts[1])
            : audioDuration?.inSeconds.toDouble() ?? 0.0;

        // If backend chunk text is empty, try to use uploadText (gensub immediate response)
        final chunkText = (s['botnoi_asr_text'] != null &&
                s['botnoi_asr_text'].toString().trim().isNotEmpty)
            ? s['botnoi_asr_text']
            : (uploadText ?? '');

        return {
          "id": s['chunk_id'],
          "start": start,
          "end": end,
          "text": chunkText,
        };
      }).toList();

      // 5) สร้าง ProjectModel พร้อม segments
      final project = ProjectModel(
        projectId: projectId,
        projectName: projectName,
        createdAt: DateTime.now(),
        duration: audioDuration ?? Duration.zero,
        filePath: filePath!,
        segments: segments,
        userId: realUserId, // ใช้ userId จริงจาก backend
      );

      debugPrint('transcribeFile: uploadText=$uploadText');
      if (project.segments.isNotEmpty) {
        debugPrint(
            'transcribeFile: sample segment text=${project.segments.first['text']}');
      } else {
        debugPrint('transcribeFile: no segments returned from chunks');
      }

      lastProject = project;
      onProjectCreated(project);

      transcribeStatus = " ถอดเสียงสำเร็จ";
      return true;
    } catch (e, st) {
      debugPrint(" Error while uploading/transcribing: $e");
      debugPrint(st.toString());
      transcribeStatus = " ถอดเสียงไม่สำเร็จ: $e";

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("ถอดเสียงไม่สำเร็จ: $e")),
        );
      }
      return false;
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// helper แปลง time string → double (วินาที)
  double _parseTime(String t) {
    final parts = t.split(':').map((e) => double.tryParse(e) ?? 0).toList();
    if (parts.length == 3) {
      return parts[0] * 3600 + parts[1] * 60 + parts[2];
    } else if (parts.length == 2) {
      return parts[0] * 60 + parts[1];
    } else {
      return parts[0];
    }
  }
}
