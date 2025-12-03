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
import 'dart:convert'; // จำเป็นสำหรับ encoding: utf8

class ResultLogic {
  final String userId;
  final String filePath;
  final String workspaceId;
  final Duration duration;
  final String? audioS3Link; // รับค่า s3Link เข้ามา (project-level)
  final String initialProjectName; // 🚩 NEW: ต้องรับเข้ามา

  late AudioPlayer audioPlayer;
  StreamSubscription<Duration>? positionSub;
  int? playingIndex;

  ResultLogic({
    required this.userId,
    required this.filePath,
    required this.workspaceId,
    required this.duration,
    required this.initialProjectName,
    this.audioS3Link,
  }) {
    audioPlayer = AudioPlayer();
    // โค้ดถูกย้ายไปที่ fetchWorkspace เพื่อให้แน่ใจว่าได้ชื่อโปรเจกต์ที่ถูกต้อง
  }

  /// Caller should await this when disposing if possible.
  Future<void> dispose() async {
    try {
      await positionSub?.cancel();
    } catch (_) {}
    positionSub = null;
    try {
      await audioPlayer.stop();
    } catch (_) {}
    try {
      await audioPlayer.dispose();
    } catch (_) {}
  }

  /// Set audio source with Referer header support for S3 (hotlink protection).
  Future<void> setProjectAudioSource(String localPath, String? s3Link) async {
    debugPrint("🔊 setProjectAudioSource localPath = '$localPath'");
    debugPrint("🔊 setProjectAudioSource s3Link = '$s3Link'");

    // 1) If explicit s3Link provided, try it first (with Referer)
    if (s3Link != null && s3Link.isNotEmpty && s3Link.startsWith('http')) {
      try {
        await audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(s3Link),
            headers: {
              'Referer': 'https://voice.botnoi.ai/',
            },
          ),
        );
        debugPrint("Audio Source: Set using S3 Stream URL with Referer header");
        return;
      } catch (e) {
        debugPrint("Audio Source: S3 setAudioSource failed: $e");
        // fallthrough to try download fallback or local
      }

      // Download fallback
      try {
        debugPrint("Audio Source: Attempting to download S3 file as fallback...");
        final resp = await http.get(
          Uri.parse(s3Link),
          headers: {'Referer': 'https://voice.botnoi.ai/'},
        );

        if (resp.statusCode == 200 && resp.bodyBytes.isNotEmpty) {
          final tmpDir = await getTemporaryDirectory();
          final ext = _guessExtensionFromContentType(resp.headers['content-type']);
          final tmpPath = p.join(
              tmpDir.path, 'botnoi_${DateTime.now().millisecondsSinceEpoch}$ext');
          final f = File(tmpPath);
          await f.writeAsBytes(resp.bodyBytes);
          await audioPlayer.setFilePath(tmpPath);
          debugPrint("Audio Source: Set using downloaded temp file: $tmpPath");
          return;
        } else {
          debugPrint(
              "Audio Source: Download fallback failed: status=${resp.statusCode}");
        }
      } catch (e) {
        debugPrint("Audio Source: Download fallback error: $e");
      }
    }

    // 2) Fallback to provided local file path
    if (localPath.trim().isNotEmpty) {
      final file = File(localPath);
      if (await file.exists()) {
        try {
          await audioPlayer.setFilePath(localPath);
          debugPrint("Audio Source: Set using Local File Path");
          return;
        } catch (e) {
          debugPrint("Audio Source: setFilePath failed: $e");
        }
      } else {
        debugPrint(
            "Audio Source: localPath provided but file not found: $localPath");
      }
    }

    debugPrint("Audio Source: ERROR - Local file missing and no S3 link provided.");
  }

  String _guessExtensionFromContentType(String? contentType) {
    if (contentType == null) return '.aac';
    final t = contentType.toLowerCase();
    if (t.contains('mpeg') || t.contains('mp3')) return '.mp3';
    if (t.contains('wav')) return '.wav';
    if (t.contains('ogg')) return '.ogg';
    if (t.contains('aac')) return '.aac';
    if (t.contains('x-flac') || t.contains('flac')) return '.flac';
    return '.aac';
  }

  // 1. โหลด workspace พร้อม segment
  Future<ProjectModel?> fetchWorkspace(WidgetRef ref) async {
    try {
      final projectId = workspaceId;

      final chunksJson = await getAllChunks(
        ref,
        projectId: projectId,
      );
      final rawSegments = (chunksJson['data'] as List<dynamic>? ?? []);

      // ดึง project_name จาก JSON ตรงๆ
      final projectData = rawSegments.isNotEmpty ? rawSegments.first : chunksJson;
      final projectNameFromApi = projectData['project_name'] as String?;

      debugPrint('RAW project json: ${projectData.toString()}');

      final segments = rawSegments.map<Map<String, dynamic>>((s) {
        final durationStr = (s['duration'] ?? '') as String;
        final parts = durationStr.split(' - ');
        final start = parts.isNotEmpty ? _parseTime(parts[0]) : 0.0;
        final end = parts.length > 1
            ? _parseTime(parts[1])
            : duration.inSeconds.toDouble();

        final text = (s['approve_text']?.toString().isNotEmpty == true)
            ? s['approve_text']
            : (s['botnoi_asr_text'] ?? '');

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

        // 🚩 FIX 1: ดึงวันที่สร้างและแปลงเป็น Local Time
        final createAtStr = rawSegments.first['create_at'];
        final createdAt = (createAtStr != null)
            ? DateTime.tryParse(createAtStr)?.toLocal() ?? DateTime.now().toLocal()
            : DateTime.now().toLocal();

        // 🚩 FIX 2: กำหนดชื่อโปรเจกต์อย่างถูกต้อง
        String finalProjectName;

        if (initialProjectName.isNotEmpty) {
          finalProjectName = initialProjectName;
        } else if (filePath.trim().isNotEmpty &&
            p.basenameWithoutExtension(filePath).length > 2) {
          finalProjectName = p.basenameWithoutExtension(filePath);
        } else if (projectNameFromApi != null && projectNameFromApi.isNotEmpty) {
          finalProjectName = projectNameFromApi;
        } else {
          finalProjectName = projectIdFromChunk;
        }

        final hasAnyText = segments.any((s) =>
            (s['text'] != null && s['text'].toString().trim().isNotEmpty));

        List<Map<String, dynamic>> finalSegments = segments;

        if (!hasAnyText) {
          try {
            final transcription =
                await transcribeAudioFile(ref, file: File(filePath));
            final fallbackText = transcription['text'] ?? '';
            if (fallbackText.isNotEmpty) {
              finalSegments = segments.map((s) {
                final currentText = s['text']?.toString() ?? '';
                return {
                  ...s,
                  'text': currentText.trim().isNotEmpty
                      ? currentText
                      : fallbackText,
                };
              }).toList();
            }
          } catch (e) {
            debugPrint('Fallback transcription failed: $e');
          }
        }

        String? projectLevelS3 = audioS3Link;
        if ((projectLevelS3 == null || projectLevelS3.isEmpty) &&
            finalSegments.isNotEmpty) {
          final seg0 = finalSegments.first;
          final cand = seg0['s3_link'];
          if (cand is String && cand.isNotEmpty) {
            projectLevelS3 = cand;
          }
        }

        // 🚩 FIX 3: ตั้งค่า Audio Source หลัก
        await setProjectAudioSource(filePath, projectLevelS3);

        return ProjectModel(
          projectId: projectIdFromChunk,
          projectName: finalProjectName,
          createdAt: createdAt,
          duration: duration,
          filePath: filePath,
          segments: finalSegments,
          userId: userId,
          audioS3Link: projectLevelS3,
        );
      }
    } catch (e) {
      debugPrint("fetchWorkspace error: $e");
    }

    final transcription = await transcribeAudioFile(
      ref,
      file: File(filePath),
    );

    final text = transcription['text'] ?? 'ไม่พบข้อความถอดเสียงในผลลัพธ์';

    final segments = [
      {
        "id": "1",
        "start": 0.0,
        "end": duration.inSeconds.toDouble(),
        "text": text,
        "approved": false,
        "original_text": null,
      }
    ];

    await setProjectAudioSource(filePath, audioS3Link);

    return ProjectModel(
      projectId: workspaceId,
      projectName: filePath.split('/').last,
      createdAt: DateTime.now(),
      duration: duration,
      filePath: filePath,
      segments: segments,
      userId: userId,
      audioS3Link: audioS3Link,
    );
  }

  double _parseTime(String timeStr) {
    try {
      final parts =
          timeStr.trim().split(':').map((p) => int.tryParse(p) ?? 0).toList();
      if (parts.length == 2) {
        return (parts[0] * 60 + parts[1]).toDouble();
      } else if (parts.length == 3) {
        return (parts[0] * 3600 + parts[1] * 60 + parts[2]).toDouble();
      }
    } catch (_) {}
    return 0.0;
  }

  /// Play a single segment.
  Future<void> playSegment(
    int index,
    List<Map<String, dynamic>> segments,
    VoidCallback onStop,
  ) async {
    final segment = segments[index];
    debugPrint('-----------------------------');
    debugPrint('▶ PLAY SEGMENT index = $index');
    debugPrint('▶ segment id = ${segment['id']}');

    final startSec =
        (segment['start'] is num) ? (segment['start'] as num).toDouble() : 0.0;
    final endSec = (segment['end'] is num)
        ? (segment['end'] as num).toDouble()
        : duration.inSeconds.toDouble();

    final start = Duration(milliseconds: (startSec * 1000).round());
    final end = Duration(milliseconds: (endSec * 1000).round());

    await positionSub?.cancel();
    positionSub = null;

    if (playingIndex == index && audioPlayer.playing) {
      await audioPlayer.pause();
      playingIndex = null;
      return;
    }

    await audioPlayer.stop();

    bool newSourceSet = false;

    // 1. If segment provides its own s3_link
    final segS3 =
        (segment['s3_link'] is String) ? segment['s3_link'] as String : null;
    if (segS3 != null && segS3.isNotEmpty && segS3.startsWith('http')) {
      try {
        await audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(segS3),
            headers: {
              'Referer': 'https://voice.botnoi.ai/',
            },
          ),
        );
        debugPrint('Set audio source from segment s3_link with Referer');
        newSourceSet = true;
      } catch (e) {
        debugPrint('Failed to set segment s3_link source: $e');
        try {
          final resp = await http.get(Uri.parse(segS3),
              headers: {'Referer': 'https://voice.botnoi.ai/'});
          if (resp.statusCode == 200 && resp.bodyBytes.isNotEmpty) {
            final tmpDir = await getTemporaryDirectory();
            final ext =
                _guessExtensionFromContentType(resp.headers['content-type']);
            final tmpPath = p.join(tmpDir.path,
                'botnoi_seg_${DateTime.now().millisecondsSinceEpoch}$ext');
            final f = File(tmpPath);
            await f.writeAsBytes(resp.bodyBytes);
            await audioPlayer.setFilePath(tmpPath);
            debugPrint('Set audio source from downloaded segment file: $tmpPath');
            newSourceSet = true;
          }
        } catch (e2) {
          debugPrint('Segment download fallback failed: $e2');
        }
      }
    }

    // 2. Fallback to Project-level S3 link
    if (!newSourceSet &&
        audioS3Link != null &&
        audioS3Link!.isNotEmpty &&
        audioS3Link!.startsWith('http')) {
      try {
        await audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(audioS3Link!),
            headers: {'Referer': 'https://voice.botnoi.ai/'},
          ),
        );
        debugPrint(
            'Set audio source from project-level audioS3Link with Referer');
        newSourceSet = true;
      } catch (e) {
        debugPrint('Failed to set project-level s3 source: $e');
      }
    }

    // 3. Final Fallback to Local File Path
    if (!newSourceSet && filePath.trim().isNotEmpty) {
      final file = File(filePath);
      if (await file.exists()) {
        try {
          await audioPlayer.setFilePath(filePath);
          debugPrint(
              'Set audio source from Local File Path as final fallback');
          newSourceSet = true;
        } catch (e) {
          debugPrint('Final setFilePath failed: $e');
        }
      }
    }

    if (!newSourceSet) {
      debugPrint('ERROR: Could not set any audio source for segment playback.');
      return;
    }

    await Future.delayed(const Duration(milliseconds: 200));

    try {
      await audioPlayer.setClip(start: start, end: end);
    } catch (e) {
      debugPrint('setClip failed: $e');
      return;
    }

    try {
      await audioPlayer.play();
      playingIndex = index;
    } catch (e) {
      debugPrint('play failed: $e');
    }

    positionSub = audioPlayer.positionStream.listen((pos) async {
      if (pos >= end) {
        try {
          await audioPlayer.pause();
          await audioPlayer.seek(end);
        } catch (_) {}
        playingIndex = null;
        onStop();
      }
    });
  }

  Future<void> deleteSegment(
    WidgetRef ref,
    int index,
    List<Map<String, dynamic>> segments,
    ProjectModel project,
  ) async {
    final segment = segments[index];
    await deleteChunk(ref, segment['id']);
    segments.removeAt(index);
  }

  Future<void> saveEdits(WidgetRef ref, ProjectModel project,
      List<Map<String, dynamic>> segments) async {
    for (var s in segments) {
      await updateAudioApproveSegment(
        ref,
        chunkId: s['id'],
        userId: userId,
        approveText: s['text'],
      );
    }
  }

  Future<dynamic> updateAudioApproveSegment(
    WidgetRef ref, {
    required String chunkId,
    required String userId,
    required String approveText,
  }) async {
    return await updateAudioApprove(
      ref,
      chunkId: chunkId,
      userId: userId,
      approveText: approveText,
    );
  }

  Future<void> finalizeProjectApprove(
    WidgetRef ref,
    ProjectModel project,
  ) async {
    try {
      final durationStr = _formatDuration(project.duration);

      debugPrint(
        "finalizeProjectApprove → projectId=${project.projectId}, userId=${project.userId}, duration=$durationStr",
      );

      final res = await updateAsrApprove(
        ref: ref,
        projectId: project.projectId,
        userId: project.userId,
        cer: 0.0,
        duration: durationStr,
      );

      debugPrint("updateAsrApprove response = $res");
    } catch (e) {
      debugPrint("finalizeProjectApprove error: $e");
    }
  }

  // 🔥 UPDATE: เพิ่มการแสดงช่วงเวลา และแก้ Encoding
  Future<File> exportTxt(BuildContext context, ProjectModel project) async {
    final buffer = StringBuffer();
    for (var s in project.segments) {
      // คำนวณเวลา Start - End
      final start = Duration(milliseconds: (s['start'] * 1000).round());
      final end = Duration(milliseconds: (s['end'] * 1000).round());
      
      final startText = _formatDuration(start);
      final endText = _formatDuration(end);

      // เขียนรูปแบบตามที่ต้องการ:
      // 00:00 - 00:02
      // ข้อความ...
      buffer.writeln("$startText - $endText");
      buffer.writeln(s['text']);
    }

    final dir = await getApplicationDocumentsDirectory();
    final cleanName = p.basenameWithoutExtension(project.projectName);
    final file = File("${dir.path}/$cleanName.txt");

    // ใช้ \uFEFF และ utf8 เพื่อแก้ภาษาต่างดาว
    await file.writeAsString('\uFEFF${buffer.toString()}', encoding: utf8);
    
    debugPrint("TXT saved at: ${file.path}");
    return file;
  }

  Future<File> exportSrt(BuildContext context, ProjectModel project) async {
    final buffer = StringBuffer();
    int index = 1;
    for (var s in project.segments) {
      final start =
          srtTime(Duration(milliseconds: (s['start'] * 1000).round()));
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

    // ใช้ \uFEFF และ utf8 เช่นกัน
    await file.writeAsString('\uFEFF${buffer.toString()}', encoding: utf8);
    
    debugPrint("SRT saved at: ${file.path}");
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