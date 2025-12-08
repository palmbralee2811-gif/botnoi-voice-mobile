import 'package:botnoivoice/screen/drawer/gensub/result/result_screen_logic.dart';
import 'package:flutter/material.dart';
import 'package:botnoivoice/screen/drawer/gensub/models/project_model.dart';
import 'package:botnoivoice/screen/drawer/gensub/uploadwithrecord/upload_rec_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';

// ... (ฟังก์ชัน shareTextFile และ shareAudioFile เดิม) ...
Future<void> shareTextFile(BuildContext context, String filePath) async {
  final box = context.findRenderObject() as RenderBox?;
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  final shareResult = await Share.shareXFiles(
    [XFile(filePath)],
    sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    text: "Choose to save or share this file",
  );

  String message;
  switch (shareResult.status) {
    case ShareResultStatus.success:
      message = 'Share Text File Successful';
      break;
    case ShareResultStatus.dismissed:
      message = 'Share Text File Dismissed';
      break;
    default:
      message = 'Share Text File Failed';
      break;
  }

  scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
}

Future<void> shareAudioFile(BuildContext context, String filePath) async {
  final box = context.findRenderObject() as RenderBox?;
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  String mimeType = 'audio/mpeg';
  final lowerPath = filePath.toLowerCase();

  if (lowerPath.endsWith('.wav')) {
    mimeType = 'audio/wav';
  } else if (lowerPath.endsWith('.m4a') || lowerPath.endsWith('.aac')) {
    mimeType = 'audio/mp4';
  } else if (lowerPath.endsWith('.ogg')) {
    mimeType = 'audio/ogg';
  }

  try {
    final shareResult = await Share.shareXFiles(
      [
        XFile(
          filePath,
          mimeType: mimeType,
        )
      ],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      text: "Share Audio File",
    );

    if (shareResult.status == ShareResultStatus.success) {
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Share Audio Successful')));
    }
  } catch (e) {
    scaffoldMessenger
        .showSnackBar(SnackBar(content: Text('Share Error: $e')));
  }
}

class ResultScreen extends ConsumerStatefulWidget {
  final String workspaceId;
  final String userId;
  final String filePath;
  final Duration duration;
  final String projectName;

  const ResultScreen({
    super.key,
    required this.workspaceId,
    required this.userId,
    required this.filePath,
    required this.duration,
    required this.projectName,
  });

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  ResultLogic? controller;
  late Future<ProjectModel?> _futureProject;
  int? editingIndex;
  String tempText = "";

  @override
  void initState() {
    super.initState();
    _futureProject = _fetchAndSetupController();
  }

  Future<ProjectModel?> _fetchAndSetupController() async {
    final tempController = ResultLogic(
      userId: widget.userId,
      filePath: widget.filePath,
      workspaceId: widget.workspaceId,
      duration: widget.duration,
      audioS3Link: null,
      initialProjectName: widget.projectName,
    );

    // 🔥 แก้ไขตรงนี้: ส่ง context เพิ่มเข้าไปตามที่แก้ใน Logic ก่อนหน้า
    final ProjectModel? project = await tempController.fetchWorkspace(ref, context);

    if (project != null && mounted) {
      final String? firstS3Link = project.segments.isNotEmpty
          ? project.segments.first['s3_link'] as String?
          : null;

      final safeFilePath = widget.filePath;

      controller = ResultLogic(
        userId: widget.userId,
        filePath: safeFilePath,
        workspaceId: widget.workspaceId,
        duration: widget.duration,
        audioS3Link: firstS3Link,
        initialProjectName: project.projectName,
      );
    }
    return project;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FB),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "result_gensub.title".tr(),
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              final project = await _futureProject;
              if (project != null && controller != null) {
                await controller!
                    .saveEdits(ref, project, project.segments);
                await controller!.finalizeProjectApprove(ref, project);

                if (!mounted) return;
                String selectedFormat = "txt";

                showDialog(
                  context: context,
                  builder: (_) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          title: Text("result_gensub.download".tr(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Select Format:"),
                              const SizedBox(height: 12),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedFormat,
                                    isExpanded: true,
                                    items: const [
                                      DropdownMenuItem(
                                          value: "txt",
                                          child: Text("Text file (.txt)")),
                                      DropdownMenuItem(
                                          value: "srt",
                                          child: Text("Subtitle (.srt)")),
                                      DropdownMenuItem(
                                          value: "audio",
                                          child: Text("Audio File (Source)")),
                                    ],
                                    onChanged: (val) {
                                      if (val != null)
                                        setState(() => selectedFormat = val);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actionsPadding:
                              const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          actions: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      foregroundColor: Colors.grey[600],
                                    ),
                                    child: Text("result_gensub.cancel".tr()),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      try {
                                        if (selectedFormat == "audio") {
                                          await shareAudioFile(
                                              context, project.filePath);
                                        } else {
                                          File file;
                                          if (selectedFormat == "txt") {
                                            file = await controller!
                                                .exportTxt(context, project);
                                            _showSnack(
                                                "${"result_gensub.saved_txt".tr()} ${file.path}");
                                          } else {
                                            file = await controller!
                                                .exportSrt(context, project);
                                            _showSnack(
                                                "${"result_gensub.saved_srt".tr()} ${file.path}");
                                          }
                                          await shareTextFile(
                                              context, file.path);
                                        }
                                      } catch (e) {
                                        _showSnack(
                                            "${"result_gensub.error".tr()} $e");
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      elevation: 0,
                                    ),
                                    child: Text("result_gensub.confirm".tr(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              }
            },
            icon: const Icon(Icons.save, color: Colors.green),
            label: Text("result_gensub.save".tr(),
                style: const TextStyle(color: Colors.green)),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: FutureBuilder<ProjectModel?>(
        future: _futureProject,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              controller == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    "${"result_gensub.error".tr()} ${snapshot.error.toString()}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("result_gensub.no_workspace".tr()));
          }

          final project = snapshot.data!;
          final segments = project.segments;
          final approvedCount =
              segments.where((s) => s['approved'] == true).length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withAlpha(13),
                          blurRadius: 6,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.mic, color: Colors.purple, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.basenameWithoutExtension(project.projectName),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('dd/MM/yyyy HH:mm')
                                  .format(project.createdAt),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        controller!.formatTime(project.duration),
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                ),

                // Status Bar
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.orange, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        "${"result_gensub.comfirm".tr()} $approvedCount/${segments.length}",
                        style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),

                // Segments List
                Column(
                  children: List.generate(segments.length, (index) {
                    final segment = segments[index];
                    final startSec = (segment['start'] is num)
                        ? (segment['start'] as num).toDouble()
                        : 0.0;
                    final endSec = (segment['end'] is num)
                        ? (segment['end'] as num).toDouble()
                        : widget.duration.inSeconds.toDouble();
                    final start =
                        Duration(milliseconds: (startSec * 1000).round());
                    final end =
                        Duration(milliseconds: (endSec * 1000).round());
                    final isEditing = editingIndex == index;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withAlpha(13),
                              blurRadius: 4,
                              offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isEditing)
                            Column(
                              children: [
                                TextField(
                                  autofocus: true,
                                  controller:
                                      TextEditingController(text: tempText)
                                        ..selection = TextSelection.collapsed(
                                            offset: tempText.length),
                                  onChanged: (val) => tempText = val,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () => setState(() {
                                        tempText = segment['text'] ?? '';
                                        editingIndex = null;
                                      }),
                                      icon: const Icon(Icons.close,
                                          color: Colors.red),
                                      label: Text("result_gensub.cancel".tr(),
                                          style: const TextStyle(
                                              color: Colors.red)),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton.icon(
                                      onPressed: () async {
                                        final approveText = tempText;
                                        try {
                                          final res = await controller!
                                              .updateAudioApproveSegment(
                                            ref,
                                            chunkId: segment['id'],
                                            userId: widget.userId,
                                            approveText: approveText,
                                          );
                                          if (res != null &&
                                              res['data'] != null) {
                                            setState(() {
                                              if (segment['original_text'] ==
                                                  null)
                                                segment['original_text'] =
                                                    segment['text'];
                                              segment['text'] =
                                                  res['data']['approve_text'] ??
                                                      approveText;
                                              segment['approved'] =
                                                  res['data']['approve'] ??
                                                      true;
                                              editingIndex = null;
                                            });
                                            _showSnack(
                                                "result_gensub.save_success"
                                                    .tr());
                                          } else {
                                            _showSnack(
                                                "result_gensub.save_fail"
                                                    .tr());
                                          }
                                        } catch (e) {
                                          _showSnack(
                                              "${"result_gensub.error".tr()} $e");
                                        }
                                      },
                                      icon: const Icon(Icons.check,
                                          color: Colors.blue),
                                      label: Text("result_gensub.save".tr(),
                                          style: const TextStyle(
                                              color: Colors.blue)),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          else
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  editingIndex = index;
                                  tempText = segment['text'] ?? '';
                                });
                              },
                              child: Text(segment['text'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            ),
                          const SizedBox(height: 6),
                          Text(
                            "${controller!.formatTime(start)} - ${controller!.formatTime(end)}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // 🔥🔥🔥 ปุ่ม Play/Stop 🔥🔥🔥
                              IconButton(
                                icon: Icon(
                                  // ถ้า index นี้กำลังเล่น ให้แสดงปุ่ม Pause
                                  controller!.playingIndex == index
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_fill,
                                  color: Colors.purple,
                                  size: 28,
                                ),
                                onPressed: () async {
                                  await controller!.playSegment(
                                    index,
                                    segments,
                                    () {
                                      // เมื่อสถานะเปลี่ยน (เล่น/หยุด) ให้รีเฟรชหน้าจอทันที
                                      if (mounted) setState(() {});
                                    },
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              if (segment['approved'] == true)
                                IconButton(
                                  icon: const Icon(Icons.history,
                                      color: Colors.grey),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text(
                                            "result_gensub.history".tr()),
                                        content: Text(
                                            "${"result_gensub.history_text".tr()} \n${segment['original_text'] ?? '-'}"),
                                        actions: [
                                          TextButton(
                                            child: Text(
                                                "result_gensub.close".tr()),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                )
                              else
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.check,
                                          color: Colors.blue),
                                      onPressed: () async {
                                        try {
                                          final res = await controller!
                                              .updateAudioApproveSegment(
                                            ref,
                                            chunkId: segment['id'],
                                            userId: widget.userId,
                                            approveText: segment['text'],
                                          );
                                          if (res != null &&
                                              res['data'] != null) {
                                            setState(() {
                                              segment['original_text'] =
                                                  segment['text'];
                                              segment['text'] = res['data']
                                                      ['approve_text'] ??
                                                  segment['text'];
                                              segment['approved'] =
                                                  res['data']['approve'] ??
                                                      true;
                                            });
                                            _showSnack(
                                                "result_gensub.approve_success"
                                                    .tr());
                                          } else {
                                            _showSnack(
                                                "result_gensub.approve_fail"
                                                    .tr());
                                          }
                                        } catch (e) {
                                          _showSnack(
                                              "${"result_gensub.error".tr()} $e");
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () async {
                                        try {
                                          await controller!.deleteSegment(
                                              ref, index, segments, project);
                                          setState(() {});
                                          _showSnack(
                                              "result_gensub.delete_success"
                                                  .tr());
                                          if (segments.isEmpty && mounted) {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 400), () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const UploadRecScreen()),
                                              );
                                            });
                                          }
                                        } catch (e) {
                                          _showSnack(
                                              "${"result_gensub.delete_fail".tr()} $e");
                                        }
                                      },
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}