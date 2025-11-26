// record_screen_logic.dart

import 'dart:io';
import 'package:botnoivoice/screen/drawer/gensub/permission/permission_gensub.dart';
import 'package:botnoivoice/shared/dialog/open_app_settings/open_app_settings_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart'; // เพิ่ม import นี้เพื่อใช้ BuildContext
import 'package:botnoivoice/screen/drawer/gensub/models/project_model.dart';
import 'package:botnoivoice/screen/main/home/function/random_string.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

// Import Standalone API Functions ใหม่ที่คุณสร้าง
import 'package:botnoivoice/screen/drawer/gensub/service/project_audio_api.dart';
import 'package:botnoivoice/screen/drawer/gensub/service/project_asr_api.dart';
import 'package:botnoivoice/screen/drawer/gensub/service/project_gensub_api.dart';

class RecordLogic {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  // final ProjectApiService api; // <<< ลบออก
  final String currentUserId;

  bool isRecorderReady = false;
  bool isRecording = false;
  bool isPlaying = false;
  String selectedLanguage = "TH";
  String selectedLanguageName = "select_languages.thai".tr();
  String selectedLanguageImage = 'assets/images/national_flag/thai.png';
  String? recordedFilePath;
  Duration? audioDuration;

  // RecordLogic({required this.api, required this.currentUserId}); // <<< แก้ Constructor
  RecordLogic({required this.currentUserId});

  Future<void> initRecorder() async {
    await _recorder.openRecorder();
    isRecorderReady = true;
  }

  Future<void> initPlayer() async {
    await _player.openPlayer();
  }

  // เปลี่ยนไปส่งค่า boolean กลับมา
  Future<bool> _checkAndroidRequestPermissions(BuildContext context) async {
    bool hasPermission = await GenSubPermission().requestPermissionGenSub();

    // หากไม่ได้รับอนุญาต ให้แสดง Dialog
    if (!hasPermission) {
      OpenAppSettingsDialog(
              context: context, text: 'audio_player.permission_denied'.tr())
          .showPermissionDeniedDialog();
    }
    // ส่งสถานะการอนุญาตกลับไป
    return hasPermission;
  }

  Future<void> toggleRecording(
      BuildContext context, Function(void Function()) setState) async {
    bool hasPermission = await _checkAndroidRequestPermissions(context);
    if (!hasPermission) return;

    // ถ้ายังไม่ได้ initRecorder ให้ init ก่อน
    if (!isRecorderReady) {
      await initRecorder();
    }

    if (isRecording) {
      // 🟥 หยุดการอัด
      final path = await _recorder.stopRecorder();

      // 🧠 ปิดและเปิด recorder ใหม่เพื่อ reset state
      await _recorder.closeRecorder();
      await _recorder.openRecorder();

      // ✅ รอไฟล์ถูกเขียนเสร็จ
      final file = File(path!);
      for (int i = 0; i < 5; i++) {
        if (await file.exists()) break;
        await Future.delayed(const Duration(milliseconds: 200));
      }

      // ✅ ตรวจไฟล์ก่อนเล่น
      if (await file.exists()) {
        final player = AudioPlayer();
        try {
          await player.setFilePath(file.path);
          final d = player.duration ?? Duration.zero;
          await player.dispose();
          setState(() {
            recordedFilePath = file.path;
            audioDuration = d;
            isRecording = false;
          });
        } catch (e) {
          debugPrint("⚠️ Failed to load file: $e");
        }
      }
    } else {
      // 🟩 เริ่มอัดเสียงใหม่
      final dir = await getTemporaryDirectory();
      final randomCode = randomStringOfCapitals(5);
      final path = '${dir.path}/recording_$randomCode.aac';

      // ปิด recorder เก่าถ้ามันยังเปิดอยู่ (กัน state ซ้ำ)
      if (_recorder.isStopped == false) {
        await _recorder.stopRecorder();
      }

      await _recorder.startRecorder(toFile: path);
      setState(() {
        isRecording = true;
      });
    }
  }

  Future<void> togglePlay(Function(void Function()) setState) async {
    if (recordedFilePath == null) return;

    if (isPlaying) {
      await _player.stopPlayer();
      setState(() {
        isPlaying = false;
      });
    } else {
      await _player.startPlayer(
        fromURI: recordedFilePath,
        whenFinished: () {
          setState(() {
            isPlaying = false;
          });
        },
      );
      setState(() {
        isPlaying = true;
      });
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // <<< Method ที่รับ BuildContext เพื่อเรียก API >>>
  Future<ProjectModel?> handleTranscribe(
    WidgetRef ref, // รับ BuildContext
    {
    int maxSegmentDuration = 10,
    double maxSilenceDuration = 0.3,
  }) async {
    if (recordedFilePath == null) return null;

    try {
      final file = File(recordedFilePath!);

      // 1) upload (เรียกใช้ฟังก์ชันใหม่ พร้อมส่ง context)
      final uploadResult = await uploadAudioToGensub(
        ref,
        file: file,
      );
      debugPrint("Upload result: $uploadResult");

      // 2) insert workspace (เรียกใช้ฟังก์ชันใหม่ พร้อมส่ง context)
      final projectName = file.path.split('/').last;
      final insertResult = await insertAsrWorkspace(
        ref: ref,
        projectName: projectName,
        cer: 0.0,
        pointAdd: 0,
        totalPoint: 0,
        duration: _formatDuration(audioDuration ?? Duration.zero),
      );
      debugPrint("Insert workspace result: $insertResult");

      // ดึง project_id และ user_id จาก backend
      final projectId =
          insertResult["data"]?["project_id"] ?? randomStringOfCapitals(8);
      final realUserId = insertResult["data"]?["user_id"] ?? currentUserId;

      // 3) cut audio (เรียกใช้ฟังก์ชันใหม่ พร้อมส่ง context)
      final cutResult = await cutAudio(
        ref,
        filePath: recordedFilePath!,
        projectId: projectId,
        projectName: projectName,
        cutType: "sec",
        chunk: maxSegmentDuration.toString(),
        durations: (audioDuration?.inSeconds ?? 0).toString(),
        maxDuration: maxSegmentDuration.toString(),
        maxSilence: maxSilenceDuration.toString(),
        language: selectedLanguage.toLowerCase(),
      );

      debugPrint("Cut audio result: $cutResult");

      // 4) get all chunks (เรียกใช้ฟังก์ชันใหม่ พร้อมส่ง context)
      final chunksRes = await getAllChunks(ref, projectId: projectId);
      final rawSegments = (chunksRes['data'] as List<dynamic>? ?? []);

      final segments = rawSegments.map<Map<String, dynamic>>((s) {
        final durationStr = (s['duration'] ?? '') as String;
        final parts = durationStr.split(' - ');

        final start = parts.isNotEmpty ? _parseTime(parts[0]) : 0.0;
        final end = parts.length > 1
            ? _parseTime(parts[1])
            : audioDuration?.inSeconds.toDouble() ?? 0.0;

        return {
          "id": s['chunk_id'],
          "start": start,
          "end": end,
          "text": s['botnoi_asr_text'] ?? '',
        };
      }).toList();

      // 5) return ProjectModel
      return ProjectModel(
        projectId: projectId,
        projectName: projectName,
        createdAt: DateTime.now(),
        duration: audioDuration ?? Duration.zero,
        filePath: recordedFilePath!,
        segments: segments,
        userId: realUserId,
      );
    } catch (e, st) {
      debugPrint("Transcribe failed: $e");
      debugPrint(st.toString());
      return null;
    }
  }

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

  // <<< Method ที่รับ BuildContext เพื่อเรียก API >>>
  Future<void> deleteProject(WidgetRef ref, String projectId) async {
    try {
      await deleteAsrWorkspace(
        ref,
        projectId,
        currentUserId,
      ); // เรียกใช้ฟังก์ชันใหม่ พร้อมส่ง context
    } catch (e) {
      debugPrint("Failed to delete project: $e");
    }
  }

  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
  }
}
