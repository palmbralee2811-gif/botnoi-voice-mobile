// record_screen_logic.dart

import 'dart:io';
import 'package:botnoivoice/screen/drawer/gensub/permission/permission_gensub.dart';
import 'package:botnoivoice/shared/dialog/open_app_settings/open_app_settings_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart'; // เพิ่ม import นี้เพื่อใช้ BuildContext
import 'package:botnoivoice/screen/drawer/gensub/models/project_model.dart';
import 'package:botnoivoice/screen/main/home/function/random_string.dart';
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
              context: context,
              text: 'audio_player.permission_denied'.tr())
          .showPermissionDeniedDialog();
    }
    // ส่งสถานะการอนุญาตกลับไป
    return hasPermission; 
  }

  Future<void> toggleRecording(BuildContext context, Function(void Function()) setState) async {
    
    // 1. ตรวจสอบสิทธิ์และรอผลลัพธ์
    bool hasPermission = await _checkAndroidRequestPermissions(context);

    // 2. ออกจากฟังก์ชันหากไม่มีสิทธิ์หรือ Recorder ไม่พร้อม
    if (!hasPermission || !isRecorderReady) return; 

    if (isRecording) {
      //  Logic: หยุดการบันทึก (Stop Recording)
      final path = await _recorder.stopRecorder();
      
      // คำนวณความยาวของเสียงที่บันทึก
      final player = AudioPlayer();
      await player.setFilePath(path!);
      final d = player.duration ?? Duration.zero;
      await player.dispose();

      setState(() {
        isRecording = false;
        recordedFilePath = path;
        audioDuration = d;
      });
      
    } else {
      //  Logic: เริ่มการบันทึก (Start Recording)
      
      // 3. กำหนด Path สำหรับไฟล์เสียง (ใช้ App-Specific Storage)
      final dir = await getTemporaryDirectory();
      final randomCode = randomStringOfCapitals(5); // สุ่มรหัสยาว 5 ตัว
      // Path สำหรับไฟล์เสียงที่บันทึก
      final path = '${dir.path}/recording_$randomCode'; // 💡 แนะนำให้ระบุนามสกุลไฟล์ด้วย เช่น .aac หรือ .mp4
      
      // 4. เริ่มบันทึกเสียง
      await _recorder.startRecorder(toFile: path); // ⚠️ บรรทัดนี้จะไม่เกิด PlatformException แล้ว เพราะมีการตรวจสอบสิทธิ์ด้านบน

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
    BuildContext context, // รับ BuildContext
    {
      String maxSegmentDuration = "10 วินาที",
      String maxSilenceDuration = "0.3 วินาที",
    }
  ) async {
    if (recordedFilePath == null) return null;

    try {
      final file = File(recordedFilePath!);

      // 1) upload (เรียกใช้ฟังก์ชันใหม่ พร้อมส่ง context)
      final uploadResult = await uploadAudioToGensub(
        context, 
        file: file,
      );
      debugPrint("Upload result: $uploadResult");

      // 2) insert workspace (เรียกใช้ฟังก์ชันใหม่ พร้อมส่ง context)
      final projectName = file.path.split('/').last;
      final insertResult = await insertAsrWorkspace(
        context, 
        projectName: projectName,
        cer: 0.0,
        pointAdd: 0,
        totalPoint: 0,
        duration: _formatDuration(audioDuration ?? Duration.zero),
      );
      debugPrint("Insert workspace result: $insertResult");

      // ดึง project_id และ user_id จาก backend
      final projectId = insertResult["data"]?["project_id"] ?? randomStringOfCapitals(8);
      final realUserId = insertResult["data"]?["user_id"] ?? currentUserId;

      // 3) cut audio (เรียกใช้ฟังก์ชันใหม่ พร้อมส่ง context)
      final cutResult = await cutAudio(
  context, 
  filePath: recordedFilePath!,
  projectId: projectId,
  projectName: projectName,
  cutType: "sec", 
  chunk: _extractSeconds(maxSegmentDuration, fallback: audioDuration),
  durations: (audioDuration?.inSeconds ?? 0).toString(),

  maxDuration: _extractSeconds(maxSegmentDuration, fallback: audioDuration),
  maxSilence: _extractSeconds(maxSilenceDuration, fallback: const Duration(seconds: 1)),
  language: "th",
);


      debugPrint("Cut audio result: $cutResult");

      // 4) get all chunks (เรียกใช้ฟังก์ชันใหม่ พร้อมส่ง context)
      final chunksRes = await getAllChunks(context, projectId: projectId); 
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


  String _extractSeconds(String input, {Duration? fallback}) {
  if (input.contains("ไม่จำกัด")) {
    return fallback != null ? fallback.inSeconds.toString() : "3600";
  }

  // ✅ ใช้ regex แบบใหม่ ดึงตัวเลขที่มีทศนิยมได้
  final match = RegExp(r'[\d.]+').firstMatch(input);
  final number = match?.group(0);

  return number ?? (fallback != null ? fallback.inSeconds.toString() : "10");
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
  Future<void> deleteProject(BuildContext context, String projectId) async {
    try {
      await deleteAsrWorkspace(context, projectId, currentUserId); // เรียกใช้ฟังก์ชันใหม่ พร้อมส่ง context
    } catch (e) {
      debugPrint("Failed to delete project: $e");
    }
  }

  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
  }
}