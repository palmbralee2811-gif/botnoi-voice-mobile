import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../models/project_model.dart';
import 'package:path/path.dart' as p;
import 'package:botnoivoice/screen/drawer/gensub/service/project_audio_api.dart';
import 'package:botnoivoice/screen/drawer/gensub/service/project_asr_api.dart';
import 'package:botnoivoice/screen/drawer/gensub/service/project_gensub_api.dart';
import 'dart:convert';

class ResultLogic {
  final String userId;
  final String filePath;
  final String workspaceId;
  final Duration duration;
  final String? audioS3Link;
  final String initialProjectName;

  late AudioPlayer audioPlayer;
  StreamSubscription<Duration>? positionSub;
  StreamSubscription<PlayerState>? stateSub; // ✅ เพิ่มตัวดักจับสถานะ Player
  
  // --- State Variables ---
  int? playingIndex;      // สำหรับ UI: บอกว่าบรรทัดไหนกำลังเล่น (เพื่อโชว์ปุ่ม Pause)
  int? _loadedIndex;      // สำหรับ Logic: จำว่าตอนนี้ Player โหลดไฟล์ไหนค้างไว้อยู่

  ResultLogic({
    required this.userId,
    required this.filePath,
    required this.workspaceId,
    required this.duration,
    required this.initialProjectName,
    this.audioS3Link,
  }) {
    audioPlayer = AudioPlayer();
    
    // ✅ ดักจับสถานะ Player โดยตรง (แก้ปัญหาปุ่มหลอน)
    // ถ้าเล่นจบ (completed) ให้รีเซ็ตปุ่ม
    stateSub = audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
         // เล่นจบแล้ว -> รีเซ็ตตำแหน่งไปที่ 0 (แต่ _loadedIndex ยังอยู่)
         audioPlayer.seek(Duration.zero);
         audioPlayer.pause();
         
         // แจ้ง UI ว่าหยุดแล้ว (ผ่าน callback ไม่ได้ตรงนี้ ต้องอาศัยการเช็คใน UI หรือเรียกผ่าน method อื่น)
         // แต่เนื่องจากเราคุม playingIndex เองใน playSegment วิธีนี้จะ safe กว่า
      }
    });
  }

  Future<void> dispose() async {
    try {
      await positionSub?.cancel();
      await stateSub?.cancel(); // อย่าลืม cancel
    } catch (_) {}
    positionSub = null;
    stateSub = null;
    
    try {
      await audioPlayer.stop();
    } catch (_) {}
    try {
      await audioPlayer.dispose();
    } catch (_) {}
  }

  // ... (ส่วน setProjectAudioSource, _guessExtensionFromContentType, fetchWorkspace คงเดิม) ...
  // เพื่อความชัวร์และครบถ้วน ผมใส่ให้ครบครับ
  
  Future<void> setProjectAudioSource(String localPath, String? s3Link) async {
    debugPrint("🔊 setProjectAudioSource localPath = '$localPath'");
    debugPrint("🔊 setProjectAudioSource s3Link = '$s3Link'");

    if (s3Link != null && s3Link.isNotEmpty && s3Link.startsWith('http')) {
      try {
        await audioPlayer.setAudioSource(
          AudioSource.uri(Uri.parse(s3Link), headers: {'Referer': 'https://voice.botnoi.ai/'}),
        );
        return;
      } catch (e) {
        debugPrint("S3 setAudioSource failed: $e");
      }
      try {
        final resp = await http.get(Uri.parse(s3Link), headers: {'Referer': 'https://voice.botnoi.ai/'});
        if (resp.statusCode == 200 && resp.bodyBytes.isNotEmpty) {
          final tmpDir = await getTemporaryDirectory();
          final ext = _guessExtensionFromContentType(resp.headers['content-type']);
          final tmpPath = p.join(tmpDir.path, 'botnoi_${DateTime.now().millisecondsSinceEpoch}$ext');
          final f = File(tmpPath);
          await f.writeAsBytes(resp.bodyBytes);
          await audioPlayer.setFilePath(tmpPath);
          return;
        }
      } catch (e) { debugPrint("Fallback error: $e"); }
    }
    if (localPath.trim().isNotEmpty) {
      final file = File(localPath);
      if (await file.exists()) {
        try {
          await audioPlayer.setFilePath(localPath);
          return;
        } catch (e) {}
      }
    }
  }

  String _guessExtensionFromContentType(String? contentType) {
    if (contentType == null) return '.aac';
    final t = contentType.toLowerCase();
    if (t.contains('mpeg') || t.contains('mp3')) return '.mp3';
    if (t.contains('wav')) return '.wav';
    return '.aac';
  }

  Future<ProjectModel?> fetchWorkspace(WidgetRef ref) async {
    try {
      final projectId = workspaceId;
      final chunksJson = await getAllChunks(ref, projectId: projectId);
      final rawSegments = (chunksJson['data'] as List<dynamic>? ?? []);
      final projectData = rawSegments.isNotEmpty ? rawSegments.first : chunksJson;
      final projectNameFromApi = projectData['project_name'] as String?;

      final segments = rawSegments.map<Map<String, dynamic>>((s) {
        final durationStr = (s['duration'] ?? '') as String;
        final parts = durationStr.split(' - ');
        final start = parts.isNotEmpty ? _parseTime(parts[0]) : 0.0;
        final end = parts.length > 1 ? _parseTime(parts[1]) : duration.inSeconds.toDouble();
        final text = (s['approve_text']?.toString().isNotEmpty == true) ? s['approve_text'] : (s['botnoi_asr_text'] ?? '');
        return {
          "id": s['chunk_id'],
          "start": start,
          "end": end,
          "text": text,
          "approved": s['approve'] ?? false,
          "original_text": null,
          "s3_link": s['s3_link'],
        };
      }).toList();

      if (segments.isNotEmpty) {
        final projectIdFromChunk = rawSegments.first['project_id'] ?? projectId;
        final createAtStr = rawSegments.first['create_at'];
        DateTime createdAt;
        if (createAtStr != null) {
          String cleanStr = createAtStr.toString().replaceAll('Z', '');
          createdAt = DateTime.tryParse(cleanStr) ?? DateTime.now();
        } else {
          createdAt = DateTime.now();
        }
        
        String finalProjectName = initialProjectName;
        if (finalProjectName.isEmpty) {
           if (projectNameFromApi != null && projectNameFromApi.isNotEmpty) {
             finalProjectName = projectNameFromApi;
           } else {
             finalProjectName = projectIdFromChunk;
           }
        }

        // Logic check text... (ละไว้เพื่อความกระชับ ใช้ของเดิมได้)
        // ... (สมมติว่ามี logic check text และ set source)
        
        String? projectLevelS3 = audioS3Link;
        if ((projectLevelS3 == null || projectLevelS3.isEmpty) && segments.isNotEmpty) {
            final seg0 = segments.first;
            final cand = seg0['s3_link'];
            if (cand is String && cand.isNotEmpty) projectLevelS3 = cand;
        }
        await setProjectAudioSource(filePath, projectLevelS3);

        return ProjectModel(
          projectId: projectIdFromChunk,
          projectName: finalProjectName,
          createdAt: createdAt,
          duration: duration,
          filePath: filePath,
          segments: segments,
          userId: userId,
          audioS3Link: projectLevelS3,
        );
      }
    } catch (e) {
      debugPrint("fetchWorkspace error: $e");
    }
    
    // Fallback case
    final text = 'ไม่พบข้อความ';
    final segments = [{"id": "1", "start": 0.0, "end": duration.inSeconds.toDouble(), "text": text, "approved": false, "original_text": null}];
    await setProjectAudioSource(filePath, audioS3Link);
    return ProjectModel(projectId: workspaceId, projectName: initialProjectName, createdAt: DateTime.now(), duration: duration, filePath: filePath, segments: segments, userId: userId, audioS3Link: audioS3Link);
  }

  double _parseTime(String timeStr) {
    try {
      final parts = timeStr.trim().split(':').map((p) => int.tryParse(p) ?? 0).toList();
      if (parts.length == 2) return (parts[0] * 60 + parts[1]).toDouble();
      if (parts.length == 3) return (parts[0] * 3600 + parts[1] * 60 + parts[2]).toDouble();
    } catch (_) {}
    return 0.0;
  }

  // 🔥🔥🔥 ฟังก์ชัน Play ที่แก้ไขใหม่ (Robust & Resume) 🔥🔥🔥
  Future<void> playSegment(
    int index,
    List<Map<String, dynamic>> segments,
    VoidCallback onUpdate, // ไว้เรียก setState
  ) async {
    final segment = segments[index];
    debugPrint('-----------------------------');
    debugPrint('▶ Request Index: $index | Currently Loaded: $_loadedIndex | Playing UI: $playingIndex');

    // 1. ตรวจสอบว่า "กดซ้ำที่เดิม" หรือไม่
    bool isSameAsLoaded = (_loadedIndex == index);

    if (isSameAsLoaded) {
       // --- กรณีไฟล์เดิม (Resume / Pause) ---
       
       if (audioPlayer.playing) {
         // ถ้าเล่นอยู่ -> ให้หยุด (Pause)
         debugPrint("Action: PAUSE");
         await audioPlayer.pause();
         
         playingIndex = null; // อัปเดต UI เป็น Play icon
         onUpdate();
       } else {
         // ถ้าหยุดอยู่ -> ให้เล่นต่อ (Resume)
         debugPrint("Action: RESUME");
         // ถ้าเล่นจบไปแล้ว ให้ seek กลับมาเริ่มใหม่
         if (audioPlayer.processingState == ProcessingState.completed) {
             final startSec = (segment['start'] is num) ? (segment['start'] as num).toDouble() : 0.0;
             await audioPlayer.seek(Duration(milliseconds: (startSec * 1000).round()));
         }
         
         playingIndex = index; // อัปเดต UI เป็น Stop icon
         onUpdate();
         await audioPlayer.play();
       }
       return;
    }

    // 2. --- กรณีไฟล์ใหม่ (New Load) ---
    debugPrint("Action: LOAD NEW");
    
    // Reset UI ทันที (Optimistic)
    playingIndex = index;
    _loadedIndex = index;
    onUpdate();

    // หยุดตัวเก่า
    try { await audioPlayer.stop(); } catch (_) {}
    
    // ตั้งค่าช่วงเวลา (Clip)
    final startSec = (segment['start'] is num) ? (segment['start'] as num).toDouble() : 0.0;
    final endSec = (segment['end'] is num) ? (segment['end'] as num).toDouble() : duration.inSeconds.toDouble();
    final start = Duration(milliseconds: (startSec * 1000).round());
    final end = Duration(milliseconds: (endSec * 1000).round());

    // Source Selection (Logic เดิม)
    bool newSourceSet = false;
    final segS3 = (segment['s3_link'] is String) ? segment['s3_link'] as String : null;

    if (segS3 != null && segS3.isNotEmpty && segS3.startsWith('http')) {
      try {
        await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(segS3), headers: {'Referer': 'https://voice.botnoi.ai/'}));
        newSourceSet = true;
      } catch (_) {}
    }
    if (!newSourceSet && audioS3Link != null && audioS3Link!.isNotEmpty) {
      try {
        await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(audioS3Link!), headers: {'Referer': 'https://voice.botnoi.ai/'}));
        newSourceSet = true;
      } catch (_) {}
    }
    if (!newSourceSet && filePath.trim().isNotEmpty) {
      try {
        await audioPlayer.setFilePath(filePath);
        newSourceSet = true;
      } catch (_) {}
    }

    if (!newSourceSet) {
      debugPrint('ERROR: No source found');
      playingIndex = null;
      _loadedIndex = null;
      onUpdate();
      return;
    }

    try {
      // ตั้งค่า Clip แล้วเล่น
      await audioPlayer.setClip(start: start, end: end);
      await audioPlayer.play();
    } catch (e) {
      debugPrint("Play Error: $e");
      playingIndex = null;
      _loadedIndex = null;
      onUpdate();
    }

    // Listener สำหรับจบ Segment นี้ (เฉพาะกรณีนี้)
    positionSub?.cancel();
    positionSub = audioPlayer.positionStream.listen((pos) async {
      // ตรวจสอบว่าเล่นเกิน end หรือยัง (เผื่อ clip หลุด)
      if (pos >= end) {
        try {
            await audioPlayer.pause();
            await audioPlayer.seek(start); // รีเซ็ตไปจุดเริ่ม
        } catch (_) {}
        
        // ถ้าเล่นจบแล้ว ให้เปลี่ยน UI กลับเป็น Play
        if (playingIndex == index) {
            playingIndex = null;
            onUpdate();
        }
      }
    });
  }

  // ... (ฟังก์ชันอื่นๆ: deleteSegment, saveEdits, exportTxt ฯลฯ ใช้โค้ดเดิมต่อได้เลยครับ) ...
  // (เพื่อให้โค้ดสั้นลง ผมละส่วนที่ไม่เกี่ยวข้องไว้ แต่คุณสามารถใช้ของเดิมได้เลย)
  
  Future<void> deleteSegment(WidgetRef ref, int index, List<Map<String, dynamic>> segments, ProjectModel project) async {
    final segment = segments[index];
    await deleteChunk(ref, segment['id']);
    segments.removeAt(index);
  }

  Future<void> saveEdits(WidgetRef ref, ProjectModel project, List<Map<String, dynamic>> segments) async {
    for (var s in segments) {
      await updateAudioApproveSegment(ref, chunkId: s['id'], userId: userId, approveText: s['text']);
    }
  }

  Future<dynamic> updateAudioApproveSegment(WidgetRef ref, {required String chunkId, required String userId, required String approveText}) async {
    return await updateAudioApprove(ref, chunkId: chunkId, userId: userId, approveText: approveText);
  }

  Future<void> finalizeProjectApprove(WidgetRef ref, ProjectModel project) async {
    try {
      final durationStr = _formatDuration(project.duration);
      await updateAsrApprove(ref: ref, projectId: project.projectId, userId: project.userId, cer: 0.0, duration: durationStr);
    } catch (e) { debugPrint("finalizeProjectApprove error: $e"); }
  }

  Future<File> exportTxt(BuildContext context, ProjectModel project) async {
    final buffer = StringBuffer();
    for (var s in project.segments) {
      final start = Duration(milliseconds: (s['start'] * 1000).round());
      final end = Duration(milliseconds: (s['end'] * 1000).round());
      buffer.writeln("${_formatDuration(start)} - ${_formatDuration(end)}");
      buffer.writeln(s['text']);
    }
    final dir = await getApplicationDocumentsDirectory();
    final cleanName = p.basenameWithoutExtension(project.projectName);
    final file = File("${dir.path}/$cleanName.txt");
    await file.writeAsString('\uFEFF${buffer.toString()}', encoding: utf8);
    return file;
  }

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
    final cleanName = p.basenameWithoutExtension(project.projectName);
    final file = File("${dir.path}/$cleanName.srt");
    await file.writeAsString('\uFEFF${buffer.toString()}', encoding: utf8);
    return file;
  }

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