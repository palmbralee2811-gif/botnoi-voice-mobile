// result_screen_logic.dart

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart'; // ต้อง import เพื่อใช้ BuildContext
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
// ต้องเปิดใช้ import สำหรับ ProjectModel
import '../models/project_model.dart';
import 'package:path/path.dart' as p;
// Import Standalone API Functions ใหม่ที่คุณสร้าง
import 'package:botnoivoice/screen/drawer/gensub/service/project_audio_api.dart'; 
import 'package:botnoivoice/screen/drawer/gensub/service/project_asr_api.dart'; 
import 'package:botnoivoice/screen/drawer/gensub/service/project_gensub_api.dart'; 

class ResultLogic {
  final String userId;
  final String filePath;
  final String workspaceId;
  final Duration duration;
  // final ProjectApiService apiService; // <<< ลบออก

  late AudioPlayer audioPlayer;
  StreamSubscription<Duration>? positionSub;
  int? playingIndex;

  ResultLogic({
    required this.userId,
    required this.filePath,
    required this.workspaceId,
    required this.duration,
    // required this.apiService, // <<< ลบออก
  }) {
    audioPlayer = AudioPlayer();
    audioPlayer.setFilePath(filePath);
  }

  void dispose() {
    positionSub?.cancel();
    audioPlayer.dispose();
  }

  // 1. โหลด workspace พร้อม segment (เพิ่ม BuildContext)
  Future<ProjectModel?> fetchWorkspace(BuildContext context) async {
    try {
      final projectId = workspaceId;

      // 1) ดึง chunks ทั้งหมด (เรียกใช้ฟังก์ชันใหม่ พร้อมส่ง context)
      final chunksJson = await getAllChunks(context, projectId: projectId);
      final rawSegments = (chunksJson['data'] as List<dynamic>? ?? []);

      final segments = rawSegments.map<Map<String, dynamic>>((s) {
        final durationStr = (s['duration'] ?? '') as String;
        final parts = durationStr.split(' - ');
        final start = parts.isNotEmpty ? _parseTime(parts[0]) : 0.0;
        final end = parts.length > 1
            ? _parseTime(parts[1])
            : duration.inSeconds.toDouble();

        // ใช้ approve_text ก่อน ถ้าไม่มีค่อย fallback ไป botnoi_asr_text
        final text = (s['approve_text']?.toString().isNotEmpty == true)
            ? s['approve_text']
            : (s['botnoi_asr_text'] ?? '');

        return {
          "id": s['chunk_id'],
          "start": start,
          "end": end,
          "text": text,
        };
      }).toList();
      if (segments.isNotEmpty) {
        final projectIdFromChunk = rawSegments.first['project_id'] ?? projectId;

        // If all segment texts are empty, try to fall back to a direct transcription
        final hasAnyText = segments.any((s) =>
            (s['text'] != null && s['text'].toString().trim().isNotEmpty));

        List<Map<String, dynamic>> finalSegments = segments;

        if (!hasAnyText) {
          try {
            final transcription = await transcribeAudioFile(context, file: File(filePath));
            final fallbackText = transcription['text'] ?? '';
            if (fallbackText.isNotEmpty) {
              // Populate each segment's text with fallbackText when original text empty
              finalSegments = segments.map((s) {
                final currentText = s['text']?.toString() ?? '';
                return {
                  ...s,
                  'text': currentText.trim().isNotEmpty ? currentText : fallbackText,
                };
              }).toList();
            }
          } catch (e) {
            debugPrint('Fallback transcription failed: $e');
          }
        }

        return ProjectModel(
          projectId: projectIdFromChunk,
          projectName: filePath.split('/').last,
          createdAt: DateTime.now(),
          duration: duration,
          filePath: filePath,
          segments: finalSegments,
          userId: userId,
        );
      }
    } catch (e) {
      debugPrint("fetchWorkspace error: $e");
    }

    // 2) ถ้าไม่มีข้อมูล segment → ถอดเสียงใหม่จากไฟล์ (เรียกใช้ฟังก์ชันใหม่ พร้อมส่ง context)
    final transcription =
        await transcribeAudioFile(context, file: File(filePath));
    final text = transcription['text'] ?? 'ไม่พบข้อความถอดเสียงในผลลัพธ์';

    final segments = [
      {
        "id": "1",
        "start": 0.0,
        "end": duration.inSeconds.toDouble(),
        "text": text,
      }
    ];

    return ProjectModel(
      projectId: workspaceId,
      projectName: filePath.split('/').last,
      createdAt: DateTime.now(),
      duration: duration,
      filePath: filePath,
      segments: segments,
      userId: userId,
    );
  }

  /// Helper แปลง "mm:ss" → double seconds
  double _parseTime(String timeStr) {
    try {
      final parts = timeStr
          .trim()
          .split(':')
          .map((p) => int.tryParse(p) ?? 0)
          .toList();
      if (parts.length == 2) {
        return (parts[0] * 60 + parts[1]).toDouble();
      } else if (parts.length == 3) {
        return (parts[0] * 3600 + parts[1] * 60 + parts[2]).toDouble();
      }
    } catch (_) {}
    return 0.0;
  }

  ///  เล่นเฉพาะช่วง segment (ไม่มีการเรียก API ไม่ต้องแก้ไข)
  Future<void> playSegment(
    int index,
    List<Map<String, dynamic>> segments,
    VoidCallback onStop,
  ) async {
    final segment = segments[index];
    // ... โค้ดเดิมทั้งหมด ...
    final startSec = (segment['start'] is num)
        ? (segment['start'] as num).toDouble()
        : 0.0;
    final endSec = (segment['end'] is num)
        ? (segment['end'] as num).toDouble()
        : duration.inSeconds.toDouble();

    final start = Duration(milliseconds: (startSec * 1000).round());
    final end = Duration(milliseconds: (endSec * 1000).round());

    await positionSub?.cancel();
    positionSub = null;

    // ถ้าเล่น segment เดิม → กดอีกทีให้หยุด
    if (playingIndex == index && audioPlayer.playing) {
      await audioPlayer.pause();
      playingIndex = null;
      return;
    }

    //  ต้อง stop ก่อน setClip ทุกครั้ง
    await audioPlayer.stop();

    //  setClip เพื่อจำกัดช่วงเล่น
    await audioPlayer.setClip(start: start, end: end);

    // เริ่มเล่น segment นี้
    await audioPlayer.play();
    playingIndex = index;

    // หยุดเมื่อเล่นถึง end
    positionSub = audioPlayer.positionStream.listen((pos) async {
      if (pos >= end) {
        await audioPlayer.pause();
        await audioPlayer.seek(end);
        playingIndex = null;
        onStop();
      }
    });
  }

  // 2. ลบ segment (เพิ่ม BuildContext)
  Future<void> deleteSegment(
    BuildContext context, // เพิ่ม BuildContext
    int index,
    List<Map<String, dynamic>> segments,
    ProjectModel project,
  ) async {
    final segment = segments[index];
    // เรียกใช้ฟังก์ชันใหม่ พร้อมส่ง context
    await deleteChunk(context, segment['id']); 
    segments.removeAt(index);
  }

  // 3. บันทึกการแก้ไข (saveEdits - เพิ่ม BuildContext)
  Future<void> saveEdits(
      BuildContext context, // เพิ่ม BuildContext
      ProjectModel project, 
      List<Map<String, dynamic>> segments) async {
    for (var s in segments) {
      // เรียกใช้ฟังก์ชันใหม่ พร้อมส่ง context
      await updateAudioApproveSegment(
        context,
        chunkId: s['id'],
        userId: userId,
        approveText: s['text'],
      );
    }
  }

  // 4. Approve segment เดียว (updateAudioApprove - เดิมใช้ apiService โดยตรงใน UI, ตอนนี้ย้าย Logic มา Controller และใช้ BuildContext)
  Future<dynamic> updateAudioApproveSegment(
    BuildContext context, // เพิ่ม BuildContext
    {required String chunkId, required String userId, required String approveText}
  ) async {
    // ต้องเรียกใช้ฟังก์ชัน Standalone API โดยตรง
    return await updateAudioApprove(
      context,
      chunkId: chunkId,
      userId: userId,
      approveText: approveText,
    );
  }

  // 5. Finalize Project (finalizeProjectApprove - เพิ่ม BuildContext)
  Future<void> finalizeProjectApprove(BuildContext context, ProjectModel project) async {
    try {
      final durationStr = _formatDuration(project.duration);

      debugPrint(
          "finalizeProjectApprove → projectId=${project.projectId}, userId=${project.userId}, duration=$durationStr",
      );

      // เรียกใช้ฟังก์ชันใหม่ พร้อมส่ง context
      final res = await updateAsrApprove(
        context,
        projectId: project.projectId,
        userId: project.userId,
        cer: 0.0,
        duration: durationStr, // ต้องส่ง string MM:SS
      );

      debugPrint("updateAsrApprove response = $res");
    } catch (e) {
      debugPrint("finalizeProjectApprove error: $e");
    }
  }

  // 6. Export .txt (exportTxt - เพิ่ม BuildContext)
  // แม้ว่า Logic การ Export จะไม่มีการเรียก API แต่เราแก้ไข UI ให้ส่ง context มาแล้ว จึงต้องรับไว้
  Future<File> exportTxt(BuildContext context, ProjectModel project) async {
  final buffer = StringBuffer();
  for (var s in project.segments) {
    buffer.writeln(s['text']);
  }

  final dir = await getApplicationDocumentsDirectory();

  // ✅ ตัดนามสกุลเก่าทิ้ง เช่น .mp3 → เหลือชื่อไฟล์เปล่า
  final cleanName = p.basenameWithoutExtension(project.projectName);
  final file = File("${dir.path}/$cleanName.txt");

  await file.writeAsString(buffer.toString());
  debugPrint("TXT saved at: ${file.path}");
  return file;
}

  // 7. Export .srt (exportSrt - เพิ่ม BuildContext)
  // แม้ว่า Logic การ Export จะไม่มีการเรียก API แต่เราแก้ไข UI ให้ส่ง context มาแล้ว จึงต้องรับไว้
  Future<File> exportSrt(BuildContext context, ProjectModel project) async {
  final buffer = StringBuffer();
  int index = 1;
  for (var s in project.segments) {
    final start = srtTime(Duration(milliseconds: (s['start'] * 1000).round()));
    final end = srtTime(Duration(milliseconds: (s['end'] * 1000).round()));
    buffer.writeln("$index");
    buffer.writeln("$start --> $end");
    buffer.writeln(s['text']);
    buffer.writeln();
    index++;
  }

  final dir = await getApplicationDocumentsDirectory();

  // ✅ ตัดนามสกุลเก่าทิ้ง เช่น .mp3 → เหลือชื่อไฟล์เปล่า
  final cleanName = p.basenameWithoutExtension(project.projectName);
  final file = File("${dir.path}/$cleanName.srt");

  await file.writeAsString(buffer.toString());
  debugPrint("SRT saved at: ${file.path}");
  return file;
}

  /// Helper
  String formatTime(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String srtTime(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final ms = (d.inMilliseconds % 1000).toString().padLeft(3, '0');
    return "$h:$m:$s,$ms";
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}