import 'package:botnoivoice/screen/drawer/gensub/result/result_screen_logic.dart';
import 'package:botnoivoice/screen/drawer/gensub/result/result_sharefile_function.dart';
import 'package:flutter/material.dart';
import 'package:botnoivoice/screen/drawer/gensub/models/project_model.dart';
import 'package:botnoivoice/screen/drawer/gensub/uploadwithrecord/upload_rec_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil

final _logger = Logger();

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

    try {
      final ProjectModel? project = await tempController.fetchWorkspace(ref);

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
    } catch (e) {
      _logger.e('Error fetching workspace: $e');
      if (mounted) {
        _showSnack("${"result_gensub.error".tr()} $e");
      }
      return null;
    }
  }

  @override
  void dispose() {
    controller?.dispose();
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 24.r),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "result_gensub.title".tr(),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 14.sp),
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              final project = await _futureProject;
              if (project != null && controller != null) {
                await controller!.saveEdits(ref, project, project.segments);
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
                              borderRadius: BorderRadius.circular(16.r)),
                          title: Text("result_gensub.download".tr(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Select Format:",
                                  style: TextStyle(fontSize: 14.sp)),
                              SizedBox(height: 12.h),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedFormat,
                                    isExpanded: true,
                                    items: [
                                      DropdownMenuItem(
                                          value: "txt",
                                          child: Text("Text file (.txt)",
                                              style: TextStyle(
                                                  fontSize: 14.sp))),
                                      DropdownMenuItem(
                                          value: "srt",
                                          child: Text("Subtitle (.srt)",
                                              style: TextStyle(
                                                  fontSize: 14.sp))),
                                    ],
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(() => selectedFormat = val);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actionsPadding:
                              EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                          actions: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: TextButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.h),
                                      foregroundColor: Colors.grey[600],
                                    ),
                                    child: Text("result_gensub.cancel".tr(),
                                        style: TextStyle(fontSize: 14.sp)),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      try {
                                        File file;
                                        if (selectedFormat == "txt") {
                                          file = await controller!
                                              .exportTxt(context, project);
                                          _showSnack(
                                              "result_gensub.saved_txt".tr());
                                          _logger.d(
                                              "GenSub Save Text File Path: ${file.path}");
                                        } else {
                                          file = await controller!
                                              .exportSrt(context, project);
                                          _showSnack(
                                              "result_gensub.saved_srt".tr());
                                          _logger.d(
                                              "GenSub Save Srt File Path: ${file.path}");
                                        }
                                        await genSubShareTextFile(
                                            context, file.path);
                                      } catch (e) {
                                        _showSnack(
                                            "${"result_gensub.error".tr()} $e");
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.h),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r)),
                                      elevation: 0,
                                    ),
                                    child: Text("result_gensub.confirm".tr(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp)),
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
            icon: Icon(Icons.save, color: Colors.green, size: 24.r),
            label: Text("result_gensub.save".tr(),
                style: TextStyle(color: Colors.green, fontSize: 12.sp)),
          ),
          SizedBox(width: 12.w),
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

          // --- คำนวณค่า CER ---
          double totalCer = 0.0;
          int cerCount = 0;
          for (var s in segments) {
            if (s['cer'] != null && s['cer'] is num) {
              totalCer += (s['cer'] as num).toDouble();
              cerCount++;
            }
          }
          String cerPercent = "0.00%";
          if (cerCount > 0) {
            double avgCer = (totalCer / cerCount) * 100;
            cerPercent = "${avgCer.toStringAsFixed(2)}%";
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- ส่วนแสดงข้อมูลโปรเจกต์ (Project Info) ---
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withAlpha(13),
                          blurRadius: 6,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.mic, color: Colors.purple, size: 32.r),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.basenameWithoutExtension(project.projectName),
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              DateFormat('dd/MM/yyyy HH:mm')
                                  .format(project.createdAt),
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        controller!.formatTime(project.duration),
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12.h),

                // --- ส่วนแสดงสถานะ "ยืนยันข้อความ" (แยกออกมา) ---
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check, color: Colors.blue, size: 20.r),
                      SizedBox(width: 6.w),
                      Text(
                        "${"result_gensub.comfirm".tr()} $approvedCount/${segments.length}",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 8.h), // ระยะห่างระหว่าง 2 แถว

                // --- ส่วนแสดงสถานะ "CER / แก้ไขส่วนที่ผิด" (แยกออกมาเป็น Row ใหม่) ---
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined,
                          color: Colors.black54, size: 18.r),
                      SizedBox(width: 6.w),
                      Text(
                        "${"result_gensub.cer".tr()} $cerPercent",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

                // --- รายการ Segments ---
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
                      margin: EdgeInsets.symmetric(vertical: 6.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
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
                                  style: TextStyle(fontSize: 14.sp),
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true),
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () => setState(() {
                                        tempText = segment['text'] ?? '';
                                        editingIndex = null;
                                      }),
                                      icon: Icon(Icons.close,
                                          color: Colors.red, size: 20.r),
                                      label: Text("result_gensub.cancel".tr(),
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 14.sp)),
                                    ),
                                    SizedBox(width: 8.w),
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
                                      icon: Icon(Icons.check,
                                          color: Colors.blue, size: 20.r),
                                      label: Text("result_gensub.save".tr(),
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 14.sp)),
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
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500)),
                            ),
                          SizedBox(height: 6.h),
                          Text(
                            "${controller!.formatTime(start)} - ${controller!.formatTime(end)}",
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.black54),
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(
                                  controller!.playingIndex == index
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_fill,
                                  color: Colors.purple,
                                  size: 28.r,
                                ),
                                onPressed: () async {
                                  await controller!.playSegment(
                                    index,
                                    segments,
                                    () {
                                      if (mounted) setState(() {});
                                    },
                                  );
                                },
                              ),
                              SizedBox(width: 8.w),
                              if (segment['approved'] == true)
                                IconButton(
                                  icon: Icon(Icons.history,
                                      color: Colors.grey, size: 24.r),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.r)),
                                        title: Text(
                                            "result_gensub.history".tr(),
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold)),
                                        content: Text(
                                            "${"result_gensub.history_text".tr()} \n${segment['original_text'] ?? '-'}",
                                            style: TextStyle(fontSize: 14.sp)),
                                        actions: [
                                          TextButton(
                                            child: Text(
                                                "result_gensub.close".tr(),
                                                style: TextStyle(
                                                    fontSize: 14.sp)),
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
                                      icon: Icon(Icons.check,
                                          color: Colors.blue, size: 24.r),
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
                                              segment['approved'] = res['data']
                                                      ['approve'] ??
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
                                      icon: Icon(Icons.delete,
                                          color: Colors.red, size: 24.r),
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