// record_screen_logic.dart

import 'dart:io';
import 'package:botnoivoice/screen/drawer/gensub/permission/permission_gensub.dart';
import 'package:botnoivoice/shared/dialog/open_app_settings/open_app_settings_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:botnoivoice/screen/drawer/gensub/models/project_model.dart';
import 'package:botnoivoice/screen/main/home/function/random_string.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import 'package:botnoivoice/screen/drawer/gensub/service/project_audio_api.dart';
import 'package:botnoivoice/screen/drawer/gensub/service/project_asr_api.dart';
import 'package:botnoivoice/screen/drawer/gensub/service/project_gensub_api.dart';

final _logger = Logger();

class RecordLogic {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  final String currentUserId;

  bool isRecorderReady = false;
  bool isRecording = false;
  bool isPlaying = false;
  String selectedLanguage = "TH";
  String selectedLanguageName = "select_languages.thai".tr();
  String selectedLanguageImage = 'assets/images/national_flag/thai.png';
  String? recordedFilePath;
  Duration? audioDuration;

  RecordLogic({required this.currentUserId});

  Future<void> initRecorder() async {
    await _recorder.openRecorder();
    isRecorderReady = true;
  }

  Future<void> initPlayer() async {
    await _player.openPlayer();
  }

  Future<bool> _checkRequestPermissions(BuildContext context) async {
    bool hasPermission = await GenSubPermission().requestPermissionGenSub();
    if (!hasPermission) {
      OpenAppSettingsDialog(
        context: context,
        text: 'audio_player.permission_denied'.tr(),
      ).showPermissionDeniedDialog();
    }
    return hasPermission;
  }

  Future<void> toggleRecording(
    BuildContext context,
    Function(void Function()) setState,
  ) async {
    bool hasPermission = await _checkRequestPermissions(context);
    if (!hasPermission) return;

    if (!isRecorderReady) {
      await initRecorder();
    }

    if (isRecording) {
      final path = await _recorder.stopRecorder();
      await _recorder.closeRecorder();
      await _recorder.openRecorder();

      final file = File(path!);
      for (int i = 0; i < 5; i++) {
        if (await file.exists()) break;
        await Future.delayed(const Duration(milliseconds: 200));
      }

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
        } catch (e, st) {
          _logger.e(
            "⚠️ Failed to load file: $e",
            stackTrace: st,
          );
        }
      }
    } else {
      final dir = await getTemporaryDirectory();
      final randomCode = randomStringOfCapitals(5);
      final path = '${dir.path}/recording_$randomCode.aac';

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

  Future<ProjectModel?> handleTranscribe(
    WidgetRef ref,
    BuildContext context, {
    int maxSegmentDuration = 10,
    double maxSilenceDuration = 0.3,
  }) async {
    if (recordedFilePath == null) return null;

    // ตัวแปรสำหรับจำ ID โปรเจค
    String? createdProjectId;
    String? createdUserId;

    try {
      final file = File(recordedFilePath!);

      // 1) upload
      final uploadResult = await uploadAudioToGensub(
        ref,
        file: file,
      );
      _logger.d("Upload result: $uploadResult");

      // 2) insert workspace
      final projectName = file.path.split('/').last;
      final insertResult = await insertAsrWorkspace(
        ref: ref,
        projectName: projectName,
        cer: 0.0,
        pointAdd: 0,
        totalPoint: 0,
        duration: _formatDuration(audioDuration ?? Duration.zero),
      );
      _logger.d("Insert workspace result: $insertResult");

      // เก็บ ID ไว้ลบถ้า Error
      createdProjectId = insertResult["data"]?["project_id"];
      createdUserId = insertResult["data"]?["user_id"];

      final projectId = createdProjectId ?? randomStringOfCapitals(8);
      final realUserId = createdUserId ?? currentUserId;

      // 3) cut audio (จุดที่มัก Error)
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

      _logger.d("Cut audio result: $cutResult");

      // 4) get all chunks
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

      return ProjectModel(
        projectId: projectId,
        projectName: projectName,
        createdAt: DateTime.now(),
        duration: audioDuration ?? Duration.zero,
        filePath: recordedFilePath!,
        segments: segments,
        userId: realUserId,
        audioS3Link: null,
      );
    } catch (e, st) {
      _logger.e(
        "Transcribe failed: $e",
        stackTrace: st,
      );

      // Rollback: ลบโปรเจคทิ้งถ้าเกิด Error
      if (createdProjectId != null) {
        _logger.e("Rolling back: Deleting invalid project $createdProjectId");
        try {
          await deleteAsrWorkspace(
              ref, createdProjectId, createdUserId ?? currentUserId,);
        } catch (delErr, st) {
          _logger.e(
            "Rollback failed: $delErr",
            stackTrace: st,
          );
        }
      }

      if (context.mounted) {
        String msg = "เกิดข้อผิดพลาด: $e";
        if (e.toString().contains("VAD script")) {
          msg = "ไม่พบเสียงพูดในไฟล์ หรือไฟล์สั้นเกินไป (ไม่มีการสร้างโปรเจค)";
        } else if (e.toString().contains("500")) {
          msg = "Server Error: ไม่สามารถประมวลผลได้";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg, style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'ปิด',
              textColor: Colors.white,
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            ),
          ),
        );
      }

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

  Future<void> deleteProject(
    WidgetRef ref,
    String projectId,
  ) async {
    try {
      await deleteAsrWorkspace(
        ref,
        projectId,
        currentUserId,
      );
    } catch (e, st) {
      _logger.e(
        "Failed to delete project: $e",
        stackTrace: st,
      );
    }
  }

  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
  }
}
