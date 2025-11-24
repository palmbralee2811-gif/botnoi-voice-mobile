import 'package:botnoivoice/screen/drawer/gensub/result/result_screen_logic.dart';
import 'package:flutter/material.dart';
import 'package:botnoivoice/screen/drawer/gensub/models/project_model.dart';
import 'package:botnoivoice/screen/drawer/gensub/uploadwithrecord/upload_rec_screen.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';

Future<void> shareTextFile(BuildContext context, String filePath) async {
  final box = context.findRenderObject() as RenderBox?;
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  final shareResult = await Share.shareXFiles(
    [XFile(filePath)],
    sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    // text: "เลือกว่าจะบันทึกหรือแชร์ไฟล์นี้",
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

class ResultScreen extends StatefulWidget {
  final String workspaceId;
  final String userId;
  final String filePath;
  final Duration duration;

  const ResultScreen({
    super.key,
    required this.workspaceId,
    required this.userId,
    required this.filePath,
    required this.duration,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ResultLogic controller;
  late Future<ProjectModel?> _futureProject;

  int? editingIndex;
  String tempText = "";

  @override
  void initState() {
    super.initState();
    controller = ResultLogic(
      userId: widget.userId,
      filePath: widget.filePath,
      workspaceId: widget.workspaceId,
      duration: widget.duration,
    );
    _futureProject = controller.fetchWorkspace(context);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("result_gensub.title".tr(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black87)),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const UploadRecScreen()),
              );
            },
            icon: const Icon(Icons.upload_file, color: Colors.purple),
            label: Text("result_gensub.upload".tr(),
                style: const TextStyle(color: Colors.purple)),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () async {
              final project = await _futureProject;
              if (project != null) {
                await controller.saveEdits(context, project, project.segments);
                await controller.finalizeProjectApprove(context, project);

                if (!mounted) return;

                String selectedFormat = "txt";

                showDialog(
                  context: context,
                  builder: (_) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: Text("result_gensub.download".tr()),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("result_gensub.text_format".tr()),
                              const SizedBox(height: 8),
                              DropdownButton<String>(
                                value: selectedFormat,
                                items: const [
                                  DropdownMenuItem(
                                      value: "txt", child: Text(".txt")),
                                  DropdownMenuItem(
                                      value: "srt", child: Text(".srt")),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => selectedFormat = val);
                                  }
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                try {
                                  File file;

                                  if (selectedFormat == "txt") {
                                    file = await controller.exportTxt(
                                        context, project);
                                    _showSnack(
                                        "${"result_gensub.saved_txt".tr()} ${file.path}");
                                  } else {
                                    file = await controller.exportSrt(
                                        context, project);
                                    _showSnack(
                                        "${"result_gensub.saved_srt".tr()} ${file.path}");
                                  }

                                  // 🟣 เรียกแชร์ไฟล์ต่อทันที
                                  await shareTextFile(context, file.path);
                                } catch (e) {
                                  _showSnack(
                                      "${"result_gensub.error".tr()} $e");
                                }
                              },
                              child: Text("result_gensub.confirm".tr()),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("result_gensub.cancel".tr()),
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
          if (snapshot.connectionState == ConnectionState.waiting) {
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
                /// Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(13),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
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
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('dd/MM/yyyy HH:mm')
                                  .format(project.createdAt.toLocal()),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      Text(controller.formatTime(project.duration),
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87)),
                    ],
                  ),
                ),

                /// Status
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
                              fontWeight: FontWeight.w500)),
                      const Spacer(),
                    ],
                  ),
                ),

                /// Segments list
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
                    final end = Duration(milliseconds: (endSec * 1000).round());
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
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isEditing)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    isDense: true,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          tempText = segment['text'] ?? '';
                                          editingIndex = null;
                                        });
                                      },
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
                                          final res = await controller
                                              .updateAudioApproveSegment(
                                            context,
                                            chunkId: segment['id'],
                                            userId: widget.userId,
                                            approveText: approveText,
                                          );

                                          if (res != null &&
                                              res['data'] != null) {
                                            setState(() {
                                              if (segment['original_text'] ==
                                                  null) {
                                                segment['original_text'] =
                                                    segment['text'];
                                              }
                                              segment['text'] = res['data']
                                                      ['approve_text'] ??
                                                  approveText;
                                              segment['approved'] = res['data']
                                                      ['approve'] ??
                                                  true;
                                              editingIndex = null;
                                            });
                                            _showSnack(
                                                "result_gensub.save_success"
                                                    .tr());
                                          } else {
                                            _showSnack(
                                                "result_gensub.save_fail".tr());
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
                              child: Text(
                                segment['text'] ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          const SizedBox(height: 6),
                          Text(
                            "${controller.formatTime(start)} - ${controller.formatTime(end)}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(
                                  controller.playingIndex == index &&
                                          controller.audioPlayer.playing
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_fill,
                                  color: Colors.purple,
                                  size: 28,
                                ),
                                onPressed: () async {
                                  await controller.playSegment(
                                    index,
                                    segments,
                                    () {
                                      if (mounted) setState(() {});
                                    },
                                  );
                                  if (mounted) setState(() {});
                                },
                              ),
                              const SizedBox(width: 8),
                              if (segment['approved'] == true) ...[
                                IconButton(
                                  icon: const Icon(Icons.history,
                                      color: Colors.grey),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title:
                                            Text("result_gensub.history".tr()),
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
                                ),
                              ] else ...[
                                IconButton(
                                  icon: const Icon(Icons.check,
                                      color: Colors.blue),
                                  onPressed: () async {
                                    try {
                                      final res = await controller
                                          .updateAudioApproveSegment(
                                        context,
                                        chunkId: segment['id'],
                                        userId: widget.userId,
                                        approveText: segment['text'],
                                      );

                                      if (res != null && res['data'] != null) {
                                        setState(() {
                                          segment['original_text'] =
                                              segment['text'];
                                          segment['text'] = res['data']
                                                  ['approve_text'] ??
                                              segment['text'];
                                          segment['approved'] =
                                              res['data']['approve'] ?? true;
                                        });
                                        _showSnack(
                                            "result_gensub.approve_success"
                                                .tr());
                                      } else {
                                        _showSnack(
                                            "result_gensub.approve_fail".tr());
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
                                      await controller.deleteSegment(
                                          context, index, segments, project);
                                      setState(() {});
                                      _showSnack(
                                          "result_gensub.delete_success".tr());
                                      if (segments.isEmpty && mounted) {
                                        Future.delayed(
                                            const Duration(milliseconds: 400),
                                            () {
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
