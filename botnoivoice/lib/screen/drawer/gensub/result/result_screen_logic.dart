// result_screen_logic.dart

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
  StreamSubscription<PlayerState>? stateSub;
  
  // --- State Variables ---
  int? playingIndex;      
  int? _loadedIndex;      

  ResultLogic({
    required this.userId,
    required this.filePath,
    required this.workspaceId,
    required this.duration,
    required this.initialProjectName,
    this.audioS3Link,
  }) {
    audioPlayer = AudioPlayer();
    
    stateSub = audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
         audioPlayer.seek(Duration.zero);
         audioPlayer.pause();
      }
    });
  }

  Future<void> dispose() async {
    try {
      await positionSub?.cancel();
      await stateSub?.cancel();
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
  
  Future<void> setProjectAudioSource(String localPath, String? s3Link) async {
    // ... (โค้ดเดิม) ...
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

  // ✅ แก้ไข: รับ context เพิ่มเข้ามาเพื่อแสดง SnackBar
  Future<ProjectModel?> fetchWorkspace(WidgetRef ref, BuildContext context) async {
    try {
      final projectId = workspaceId;
      final chunksJson = await getAllChunks(ref, projectId: projectId);

      // 🔥🔥🔥 6. ตรวจสอบ Data Null และแสดง SnackBar 🔥🔥🔥
      if (chunksJson['data'] == null) {
        debugPrint("ResultLogic: Data is null");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Error: Data is null"), // ข้อความแจ้งเตือน
              backgroundColor: Colors.red,          // สีแดง
              duration: Duration(seconds: 5),       // แสดง 5 วินาที
            ),
          );
        }
        // คืนค่า null เพื่อให้ UI จัดการต่อ (เช่น แสดงหน้าว่าง หรือ loading หายไป)
        // หรือถ้าอยากให้แสดงข้อมูล Fallback ก็ลบ return null ออก แล้วปล่อยให้ข้างล่างจัดการเป็น []
        return null; 
      }
      // 🔥🔥🔥 สิ้นสุดส่วนที่เพิ่ม 🔥🔥🔥

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
        
        String? projectLevelS3 = audioS3Link;
        if ((projectLevelS3 == null || projectLevelS3.isEmpty) && segments.isNotEmpty) {
            final seg0 = segments.first;
            // final cand = seg0['s3_link']; // ไม่ต้องใช้
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

  // 🔥🔥🔥 ฟังก์ชัน Play (โค้ดที่แก้แล้วจากรอบที่แล้ว) 🔥🔥🔥
  Future<void> playSegment(
    int index,
    List<Map<String, dynamic>> segments,
    VoidCallback onUpdate, 
  ) async {
    final segment = segments[index];
    debugPrint('-----------------------------');
    debugPrint('▶ Request Index: $index | Currently Loaded: $_loadedIndex | Playing UI: $playingIndex');

    bool isSameAsLoaded = (_loadedIndex == index);

    if (isSameAsLoaded) {
       if (audioPlayer.playing) {
         debugPrint("Action: PAUSE");
         await audioPlayer.pause();
         playingIndex = null;
         onUpdate();
       } else {
         debugPrint("Action: RESUME");
         if (audioPlayer.processingState == ProcessingState.completed) {
             await audioPlayer.seek(Duration.zero); 
         }
         playingIndex = index;
         onUpdate();
         await audioPlayer.play();
       }
       return;
    }

    debugPrint("Action: LOAD NEW");
    
    playingIndex = index;
    _loadedIndex = index;
    onUpdate();

    try { await audioPlayer.stop(); } catch (_) {}
    
    final startSec = (segment['start'] is num) ? (segment['start'] as num).toDouble() : 0.0;
    final endSec = (segment['end'] is num) ? (segment['end'] as num).toDouble() : duration.inSeconds.toDouble();
    final timelineStart = Duration(milliseconds: (startSec * 1000).round());
    final timelineEnd = Duration(milliseconds: (endSec * 1000).round());

    bool newSourceSet = false;
    bool isChunkSource = false; 

    final segS3 = (segment['s3_link'] is String) ? segment['s3_link'] as String : null;

    if (segS3 != null && segS3.isNotEmpty && segS3.startsWith('http')) {
      try {
        debugPrint("Attempting to load CHUNK source: $segS3");
        await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(segS3), headers: {'Referer': 'https://voice.botnoi.ai/'}));
        newSourceSet = true;
        isChunkSource = true; 
      } catch (e) {
        debugPrint("Failed to load chunk source: $e");
      }
    }

    if (!newSourceSet && audioS3Link != null && audioS3Link!.isNotEmpty) {
      try {
        debugPrint("Attempting to load FULL S3 source: $audioS3Link");
        await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(audioS3Link!), headers: {'Referer': 'https://voice.botnoi.ai/'}));
        newSourceSet = true;
        isChunkSource = false; 
      } catch (e) {
        debugPrint("Failed to load full S3 source: $e");
      }
    }

    if (!newSourceSet && filePath.trim().isNotEmpty) {
      try {
        debugPrint("Attempting to load LOCAL source: $filePath");
        await audioPlayer.setFilePath(filePath);
        newSourceSet = true;
        isChunkSource = false; 
      } catch (e) {
         debugPrint("Failed to load local source: $e");
      }
    }

    if (!newSourceSet) {
      debugPrint('ERROR: No source found');
      playingIndex = null;
      _loadedIndex = null;
      onUpdate();
      return;
    }

    try {
      if (isChunkSource) {
        debugPrint("Playing CHUNK mode (Start: 0, End: null)");
        await audioPlayer.setClip(start: Duration.zero, end: null);
      } else {
        debugPrint("Playing FULL FILE mode (Start: $timelineStart, End: $timelineEnd)");
        await audioPlayer.setClip(start: timelineStart, end: timelineEnd);
      }
      
      await audioPlayer.play();
    } catch (e) {
      debugPrint("Play Error: $e");
      playingIndex = null;
      _loadedIndex = null;
      onUpdate();
    }

    positionSub?.cancel();
    positionSub = audioPlayer.positionStream.listen((pos) async {
      if (!isChunkSource) {
        if (pos >= timelineEnd) {
          try {
              await audioPlayer.pause();
              await audioPlayer.seek(timelineStart); 
          } catch (_) {}
          
          if (playingIndex == index) {
              playingIndex = null;
              onUpdate();
          }
        }
      }
    });
  }

  // ... (ฟังก์ชันอื่นๆ: deleteSegment, saveEdits, exportTxt, exportSrt ฯลฯ ใช้โค้ดเดิม) ...
  
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