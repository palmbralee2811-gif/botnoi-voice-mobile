import 'package:botnoivoice/screen/drawer/gensub/result/result_screen_logic.dart';
import 'package:flutter/material.dart';
import 'package:botnoivoice/screen/drawer/gensub/models/project_model.dart';
import 'package:botnoivoice/screen/drawer/gensub/upload_rec_screen.dart';
import 'package:intl/intl.dart';

// Note: ต้องมั่นใจว่า ResultLogic ถูกปรับให้ Constructor ไม่รับ apiService
// และ methods ที่เรียก API รับ BuildContext เป็น argument แรกแล้ว

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
  late Future<ProjectModel?> _futureProject; // preload future

  int? editingIndex;
  String tempText = "";

  @override
  void initState() {
    super.initState();

    //  ลบการใช้ dotenv และ ProjectApiService
    controller = ResultLogic(
      userId: widget.userId,
      filePath: widget.filePath,
      workspaceId: widget.workspaceId,
      duration: widget.duration,
      //  ไม่ต้องส่ง apiService แล้ว
    );

    //  ส่ง context เข้าไปใน fetchWorkspace
    _futureProject = controller.fetchWorkspace(context); // preload
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
        title: const Text("Botnoi GenSub",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const UploadRecScreen()),
              );
            },
            icon: const Icon(Icons.upload_file, color: Colors.purple),
            label: const Text("อัปโหลดไฟล์ใหม่",
                style: TextStyle(color: Colors.purple)),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () async {
              final project = await _futureProject;
              if (project != null) {
                //  ส่ง context เข้าไปใน Logic methods
                await controller.saveEdits(context, project, project.segments);
                await controller.finalizeProjectApprove(context, project);

                if (!mounted) return;

                String selectedFormat = "txt"; // ค่า default

                showDialog(
                  context: context,
                  builder: (_) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: const Text("ดาวน์โหลดข้อความ"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("นามสกุลไฟล์ text :"),
                              const SizedBox(height: 8),
                              DropdownButton<String>(
                                value: selectedFormat,
                                items: const [
                                  DropdownMenuItem(
                                    value: "txt",
                                    child: Text(".txt"),
                                  ),
                                  DropdownMenuItem(
                                    value: "srt",
                                    child: Text(".srt"),
                                  ),
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
                                if (selectedFormat == "txt") {
                                  //  ส่ง context เข้าไป
                                  final file = await controller.exportTxt(context, project);
                                  _showSnack("บันทึกไฟล์ TXT เรียบร้อย: ${file.path}");
                                } else {
                                  //  ส่ง context เข้าไป
                                  final file = await controller.exportSrt(context, project);
                                  _showSnack("บันทึกไฟล์ SRT เรียบร้อย: ${file.path}");
                                }
                              },
                              child: const Text("ยืนยัน"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("ยกเลิก"),
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
            label: const Text("บันทึก", style: TextStyle(color: Colors.green)),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: FutureBuilder<ProjectModel?>(
        future: _futureProject, // ใช้ future ที่ preload
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("เกิดข้อผิดพลาด: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("ไม่พบ workspace"));
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
                            Text(project.projectName,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                                DateFormat('dd/MM/yyyy HH:mm')
                                    .format(project.createdAt.toLocal()),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black54)),
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
                          "ยืนยันข้อความแล้ว $approvedCount/${segments.length}",
                          style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                      const Spacer(),
                    ],
                  ),
                ),

                /// Segments
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
                          /// Text หรือ TextField
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
                                    // ปุ่มยกเลิก
                                    TextButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          tempText = segment['text'] ?? '';
                                          editingIndex = null;
                                        });
                                      },
                                      icon: const Icon(Icons.close,
                                          color: Colors.red),
                                      label: const Text("ยกเลิก",
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                    const SizedBox(width: 8),
                                    // ปุ่มบันทึกเฉพาะ segment
                                    TextButton.icon(
                                      onPressed: () async {
                                        final approveText = tempText;
                                        try {
                                          //  แก้ไข: เรียก updateAudioApprove บน controller โดยส่ง context
                                          final res = await controller
                                              .updateAudioApprove(
                                                context, // ส่ง context
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
                                            _showSnack("บันทึกสำเร็จ ");
                                          } else {
                                            _showSnack("บันทึกไม่สำเร็จ ลองอีกครั้ง");
                                          }
                                        } catch (e) {
                                          _showSnack("เกิดข้อผิดพลาด: $e");
                                        }
                                      },
                                      icon: const Icon(Icons.check,
                                          color: Colors.blue),
                                      label: const Text("บันทึก",
                                          style: TextStyle(color: Colors.blue)),
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
                              // ปุ่มเล่น/หยุดเสียง
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
                                // ปุ่มดู History
                                IconButton(
                                  icon: const Icon(Icons.history,
                                      color: Colors.grey),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text("History"),
                                        content: Text(
                                            "ข้อความก่อนแก้ไข:\n${segment['original_text'] ?? '-'}"),
                                        actions: [
                                          TextButton(
                                            child: const Text("ปิด"),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ] else ...[
                                // ยังไม่อนุมัติ → ปุ่มติ๊กถูกกับลบ
                                IconButton(
                                  icon: const Icon(Icons.check,
                                      color: Colors.blue),
                                  onPressed: () async {
                                    try {
                                      //  เรียกใช้ method บน controller โดยส่ง context
                                      final res = await controller.updateAudioApprove(
                                          context, // ส่ง context
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
                                        _showSnack("อนุมัติเรียบร้อย ");
                                      } else {
                                        _showSnack("อนุมัติไม่สำเร็จ ลองอีกครั้ง");
                                      }
                                    } catch (e) {
                                      _showSnack("เกิดข้อผิดพลาด: $e");
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    try {
                                      //  เรียกใช้ method บน controller โดยส่ง context
                                      await controller.deleteSegment(context, index, segments, project); 
                                      setState(() {});
                                      _showSnack("ลบเรียบร้อย");

                                      //  ถ้า segment หมด → กลับไปหน้า Upload
                                      if (segments.isEmpty && mounted) {
                                        Future.delayed(const Duration(milliseconds: 400), () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (_) => const UploadRecScreen()),
                                          );
                                        });
                                      }
                                    } catch (e) {
                                      _showSnack("ลบไม่สำเร็จ: $e");
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