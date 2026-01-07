import 'package:botnoivoice/screen/drawer/gensub/result/result_screen_logic.dart';
import 'package:botnoivoice/screen/drawer/gensub/result/result_sharefile_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:botnoivoice/screen/drawer/gensub/models/project_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // พื้นหลังสีขาวนวล Clean
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20.r),
          onPressed: () {
            // Navigator.pop(context);
            context.pop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0.5, // เงาบางๆ
        centerTitle: true,
        title: Text(
          "result_gensub.title".tr(),
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: 16.sp),
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
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r)),
                          title: Text("result_gensub.download".tr(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Select Format:",
                                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700])),
                              SizedBox(height: 12.h),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedFormat,
                                    isExpanded: true,
                                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                                    style: TextStyle(color: Colors.black87, fontSize: 14.sp),
                                    items: const [
                                      DropdownMenuItem(
                                        value: "txt",
                                        child: Text("Text file (.txt)"),
                                      ),
                                      DropdownMenuItem(
                                        value: "srt",
                                        child: Text("Subtitle (.srt)"),
                                      ),
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
                              EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                          actions: [
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      // Navigator.pop(context);
                                      context.pop();
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(vertical: 12.h),
                                      side: BorderSide(color: Colors.grey.shade300),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                                      foregroundColor: Colors.grey[700],
                                    ),
                                    child: Text("result_gensub.cancel".tr(),
                                        style: TextStyle(fontSize: 14.sp)),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      // Navigator.pop(context);
                                      context.pop();

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
                                      backgroundColor: const Color(0xFF4CAF50), // Green 500
                                      foregroundColor: Colors.white,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.h),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.r)),
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
            icon: Icon(Icons.save_alt_rounded, color: const Color(0xFF4CAF50), size: 24.r),
            label: Text("result_gensub.save".tr(),
                style: TextStyle(color: const Color(0xFF4CAF50), fontSize: 14.sp, fontWeight: FontWeight.w600)),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: FutureBuilder<ProjectModel?>(
        future: _futureProject,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              controller == null) {
            return const Center(child: CircularProgressIndicator(strokeWidth: 2));
          } else if (snapshot.hasError) {
            return Center(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Text(
                      "${"result_gensub.error".tr()} ${snapshot.error.toString()}",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red[400])),
                ));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                "result_gensub.no_workspace".tr(),
                style: const TextStyle(color: Colors.grey),
              ),
            );
          }

          final project = snapshot.data!;
          final segments = project.segments;
          final approvedCount =
              segments.where((s) => s['approved'] == true).length;

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
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Project Info Card ---
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E5F5), // Light Purple
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(Icons.mic_rounded, color: const Color(0xFF9C27B0), size: 28.r),
                      ),
                      SizedBox(width: 16.w),
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              DateFormat('dd/MM/yyyy • HH:mm')
                                  .format(project.createdAt),
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8.r)
                        ),
                        child: Text(
                          controller!.formatTime(project.duration),
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // --- Status Row (Confirmed) ---
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey.shade100)
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded, color: const Color(0xFF2196F3), size: 20.r), // Blue
                      SizedBox(width: 8.w),
                      Text(
                        "${"result_gensub.comfirm".tr()} $approvedCount/${segments.length}",
                        style: TextStyle(
                            color: const Color(0xFF2196F3),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 8.h),

                // --- Status Row (CER) ---
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey.shade100)
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.edit_note_rounded,
                          color: Colors.grey[700], size: 22.r),
                      SizedBox(width: 8.w),
                      Text(
                        "${"result_gensub.cer".tr()} $cerPercent",
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),

                // --- Segments List ---
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
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 8,
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
                                  style: TextStyle(fontSize: 16.sp, height: 1.5),
                                  maxLines: null,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                        borderSide: const BorderSide(
                                          color: Colors.blue,
                                          width: 1.5,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.all(12.w),
                                      isDense: true),
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () => setState(() {
                                        tempText = segment['text'] ?? '';
                                        editingIndex = null;
                                      }),
                                      child: Text("result_gensub.cancel".tr(),
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14.sp)),
                                    ),
                                    SizedBox(width: 8.w),
                                    ElevatedButton.icon(
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
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h)
                                      ),
                                      icon: Icon(Icons.check, size: 18.r),
                                      label: Text("result_gensub.save".tr(), style: TextStyle(fontSize: 14.sp)),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          else
                            InkWell(
                              onTap: () {
                                setState(() {
                                  editingIndex = index;
                                  tempText = segment['text'] ?? '';
                                });
                              },
                              child: Text(segment['text'] ?? '',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      height: 1.5,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.normal)),
                            ),
                          SizedBox(height: 8.h),
                          Divider(color: Colors.grey[100]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${controller!.formatTime(start)} - ${controller!.formatTime(end)}",
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.grey[500], fontWeight: FontWeight.w500),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      controller!.playingIndex == index
                                          ? Icons.pause_circle_filled_rounded
                                          : Icons.play_circle_fill_rounded,
                                      color: const Color(0xFF9C27B0), // Purple
                                      size: 32.r,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
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
                                  SizedBox(width: 12.w),
                                  if (segment['approved'] == true)
                                    // --- History Button (with Copy) ---
                                    InkWell(
                                      onTap: () {
                                        final originalText = segment['original_text'] ?? '-';
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20.r)),
                                            title: Row(
                                              children: [
                                                Icon(Icons.history_rounded, color: Colors.grey[700]),
                                                SizedBox(width: 8.w),
                                                Text(
                                                    "result_gensub.history".tr(),
                                                    style: TextStyle(
                                                        fontSize: 18.sp,
                                                        fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "result_gensub.history_text".tr(), // "Original text:"
                                                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                                                ),
                                                SizedBox(height: 8.h),
                                                Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.all(12.w),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[50],
                                                    borderRadius: BorderRadius.circular(12.r),
                                                    border: Border.all(color: Colors.grey.shade200),
                                                  ),
                                                  child: SelectableText(
                                                    originalText,
                                                    style: TextStyle(fontSize: 14.sp, height: 1.5),
                                                  ),
                                                ),
                                                SizedBox(height: 12.h),
                                                Align(
                                                  alignment: Alignment.centerRight,
                                                  child: TextButton.icon(
                                                    onPressed: () {
                                                      Clipboard.setData(ClipboardData(text: originalText));
                                                      _showSnack("Copied to clipboard");

                                                      // Navigator.pop(context);
                                                      context.pop();
                                                    },
                                                    icon: Icon(Icons.copy_rounded, size: 16.r),
                                                    label: Text("Copy", style: TextStyle(fontSize: 12.sp)),
                                                    style: TextButton.styleFrom(
                                                      foregroundColor: Colors.blue,
                                                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                                      backgroundColor: Colors.blue.withOpacity(0.1),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text(
                                                    "result_gensub.close".tr(),
                                                    style: TextStyle(
                                                        fontSize: 14.sp, color: Colors.grey[600])),
                                                onPressed: () {
                                                  // Navigator.pop(context);
                                                  context.pop();
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(6.r),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          shape: BoxShape.circle
                                        ),
                                        child: Icon(Icons.history_rounded, color: Colors.grey[600], size: 20.r)
                                      ),
                                    )
                                  else
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
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
                                          child: Container(
                                            padding: EdgeInsets.all(6.r),
                                            decoration: BoxDecoration(
                                              color: Colors.blue[50],
                                              shape: BoxShape.circle
                                            ),
                                            child: Icon(Icons.check_rounded, color: Colors.blue, size: 20.r),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        InkWell(
                                          onTap: () async {
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
                                                    milliseconds: 400,
                                                  ),
                                                  () {
                                                    // Navigator.pushReplacement(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (_) =>
                                                    //         const UploadRecScreen(),
                                                    //   ),
                                                    // );

                                                    context.go('/gensub');
                                                  },
                                                );
                                              }
                                            } catch (e) {
                                              _showSnack(
                                                  "${"result_gensub.delete_fail".tr()} $e");
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(6.r),
                                            decoration: BoxDecoration(
                                              color: Colors.red[50],
                                              shape: BoxShape.circle
                                            ),
                                            child: Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20.r),
                                          ),
                                        ),
                                      ],
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