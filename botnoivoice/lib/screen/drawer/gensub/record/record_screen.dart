import 'dart:async';
import 'dart:ui'; // เพิ่ม import นี้สำหรับ FontFeature

import 'package:botnoivoice/screen/drawer/gensub/models/project_model.dart';
import 'package:botnoivoice/screen/drawer/gensub/result/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:botnoivoice/screen/drawer/gensub/record/record_screen_logic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:botnoivoice/screen/drawer/gensub/language_selector.dart';
import 'package:botnoivoice/screen/drawer/gensub/uploadwithrecord/upload_rec_logic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:botnoivoice/screen/drawer/gensub/point_calculator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart'; 

class RecordScreen extends ConsumerStatefulWidget {
  final List<ProjectModel> projects;
  final Function(ProjectModel) onProjectCreated;
  final Function(ProjectModel) onProjectDeleted;

  const RecordScreen({
    super.key,
    required this.projects,
    required this.onProjectCreated,
    required this.onProjectDeleted,
  });

  @override
  ConsumerState<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends ConsumerState<RecordScreen> {
  late RecordLogic controller;
  bool _confirmed = false;
  bool _loading = false;

  Timer? _timer;
  int _recordSeconds = 0;

  int _maxSegmentDuration = 10;
  double _maxSilenceDuration = 0.3;

  void _safeSetState(void Function() fn) {
    if (!mounted) return;
    setState(fn);
  }

  @override
  void initState() {
    super.initState();
    controller = RecordLogic(
      currentUserId: "USER_ID_PLACEHOLDER",
    );
    controller.initRecorder();
    controller.initPlayer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  String get _formattedTimer {
    final minutes = (_recordSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_recordSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void _handleRecordingToggle() {
    controller.toggleRecording(context, (fn) {
      _safeSetState(fn);
      if (controller.isRecording) {
        _recordSeconds = 0;
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordSeconds++;
          });
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FD), 
      child: controller.recordedFilePath == null
          ? _buildInitialUI()
          : (!_confirmed ? _buildConfirmUI() : _buildSettingsUI()),
    );
  }

  Widget _buildInitialUI() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20.h),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
              child: Column(
                children: [
                  Text(
                    "record_gensub.title".tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "record_gensub.expand_title".tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40.h),
                  
                  // --- Record Button ---
                  GestureDetector(
                    onTap: _handleRecordingToggle,
                    child: Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: controller.isRecording
                            ? Colors.red.shade50
                            : Colors.blue.shade50,
                        border: Border.all(
                          color: controller.isRecording
                              ? Colors.red.withOpacity(0.2)
                              : Colors.blue.withOpacity(0.2),
                          width: 8.w,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 70.w,
                          height: 70.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.isRecording
                                ? Colors.red
                                : Colors.blue,
                            boxShadow: [
                              BoxShadow(
                                color: (controller.isRecording
                                        ? Colors.red
                                        : Colors.blue)
                                    .withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              )
                            ],
                          ),
                          child: Icon(
                            controller.isRecording
                                ? Icons.stop_rounded
                                : Icons.mic_rounded,
                            size: 32.r,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ---------------------

                  SizedBox(height: 24.h),
                  if (controller.isRecording)
                    Text(
                      _formattedTimer,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    )
                  else
                    Text(
                      "record_gensub.press_to".tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          if (widget.projects.isNotEmpty) _buildProjectList(),
        ],
      ),
    );
  }

  Widget _buildConfirmUI() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
              child: Column(
                children: [
                  Text(
                    "record_gensub.title".tr(),
                    style: TextStyle(
                        fontSize: 18.sp, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40.h),
                  
                  // --- Action Buttons Row (แก้ไข Overflow) ---
                  Row(
                    // ใช้ spaceEvenly เพื่อกระจายปุ่มให้เท่ากันโดยอัตโนมัติ ไม่ต้องกำหนด SizedBox ตายตัว
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                    children: [
                      // Delete
                      _buildCircleActionButton(
                        icon: Icons.delete_outline_rounded,
                        color: Colors.red,
                        onTap: () {
                          _safeSetState(() {
                            controller.recordedFilePath = null;
                            controller.audioDuration = null;
                            _confirmed = false;
                            _recordSeconds = 0;
                            _timer?.cancel();
                          });
                        },
                      ),
                      // ลบ SizedBox(width: 32.w) ออกเพื่อแก้ Overflow
                      
                      // Play/Pause
                      _buildCircleActionButton(
                        icon: controller.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.blue,
                        size: 80.w, 
                        iconSize: 40.r,
                        onTap: () => controller.togglePlay(_safeSetState),
                      ),
                      
                      // ลบ SizedBox(width: 32.w) ออกเพื่อแก้ Overflow
                      
                      // Confirm
                      _buildCircleActionButton(
                        icon: Icons.check_rounded,
                        color: Colors.green,
                        onTap: () => _safeSetState(() => _confirmed = true),
                      ),
                    ],
                  ),
                  // --------------------------

                  SizedBox(height: 32.h),
                  Text(
                    "record_gensub.press_correct".tr(),
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          if (widget.projects.isNotEmpty) _buildProjectList(),
        ],
      ),
    );
  }

  Widget _buildCircleActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    double? size,
    double? iconSize,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size ?? 60.w,
        height: size ?? 60.w,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color,
          size: iconSize ?? 30.r,
        ),
      ),
    );
  }

  Widget _buildSettingsUI() {
    final fileName = controller.recordedFilePath != null
        ? controller.recordedFilePath!.split('/').last
        : "";

    int totalPoints =
        PointCalculator.calculateTotalPoints(controller.audioDuration);

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            elevation: 3, 
            shadowColor: Colors.black.withOpacity(0.2),
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // File Name Row
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(Icons.mic_rounded, color: Colors.blue, size: 24.h),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          fileName,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline_rounded, color: Colors.red, size: 24.h),
                        onPressed: () {
                          _safeSetState(() {
                            controller.recordedFilePath = null;
                            controller.audioDuration = null;
                            _confirmed = false;
                            _recordSeconds = 0;
                            _timer?.cancel();
                          });
                        },
                      ),
                    ],
                  ),
                  
                  Divider(height: 32.h, color: Colors.grey.shade100),

                  // Language Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "text_to_gensub.audio_language".tr(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                        ),
                      ),
                      LanguageSelector(
                        selectedLanguage: controller.selectedLanguageName,
                        selectedLanguageImage: controller.selectedLanguageImage,
                        onSelected: (lang) {
                          setState(() {
                            controller.selectedLanguage = lang['code'];
                            controller.selectedLanguageImage = lang['image'];
                            final locale = context.locale.languageCode;
                            switch (locale) {
                              case 'th':
                                controller.selectedLanguageName = lang['thaiName'];
                                break;
                              case 'id':
                                controller.selectedLanguageName = lang['indonesianName'];
                                break;
                              default:
                                controller.selectedLanguageName = lang['englishName'];
                            }
                          });
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // File Duration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "text_to_gensub.file_duration".tr(),
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                      ),
                      Text(
                        controller.audioDuration != null
                            ? "${controller.audioDuration!.inMinutes.toString().padLeft(2, '0')}:${(controller.audioDuration!.inSeconds % 60).toString().padLeft(2, '0')} ${'units.minutes'.tr()}"
                            : "text_to_gensub.duration_auto_calculate".tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Expansion Settings (Styled)
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: Text(
                        "text_to_gensub.segmentation_settings".tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      children: [
                        SizedBox(height: 8.h),
                        _buildDropdownRow(
                          title: "text_to_gensub.max_segment_duration".tr(),
                          value: _maxSegmentDuration,
                          items: [1, 2, 5, 10, 15, 20, 25, 30],
                          onChanged: (val) {
                            if (val != null) {
                              _safeSetState(() => _maxSegmentDuration = val);
                            }
                          },
                          labelBuilder: (val) => "$val ${'units.seconds'.tr()}",
                        ),
                        SizedBox(height: 12.h),
                        _buildDropdownRow(
                          title: "text_to_gensub.max_silence_duration".tr(),
                          value: _maxSilenceDuration,
                          items: [0.1, 0.3, 0.5, 0.7, 0.9, 1.5],
                          onChanged: (val) {
                            if (val != null) {
                              _safeSetState(() => _maxSilenceDuration = val);
                            }
                          },
                          labelBuilder: (val) => "$val ${'units.seconds'.tr()}",
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // --- Total Points (Matching Upload Screen) ---
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 16.h, horizontal: 20.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.cyan, width: 1.5.w),
                      borderRadius: BorderRadius.circular(16.r),
                      color: Colors.cyan.withOpacity(0.03), 
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total points",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/logo/credit-icon.svg',
                              width: 20.w,
                              height: 20.h,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "$totalPoints",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyan,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // -------------------------------------------

                  SizedBox(height: 24.h),

                  // Start Button
                  ElevatedButton.icon(
                    onPressed: _loading
                        ? null
                        : () async {
                            _safeSetState(() => _loading = true);
                            final project = await controller.handleTranscribe(
                              ref,
                              context,
                              maxSegmentDuration: _maxSegmentDuration,
                              maxSilenceDuration: _maxSilenceDuration,
                            );
                            _safeSetState(() => _loading = false);

                            if (project != null && mounted) {
                              widget.onProjectCreated(project);
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (_) => ResultScreen(
                              //         workspaceId: project.projectId,
                              //         userId: project.userId,
                              //         filePath: project.filePath,
                              //         duration: project.duration,
                              //         projectName: project.projectName),
                              //   ),
                              // );

                              // ใช้ context.push เพื่อเปิดหน้า Result แบบมีปุ่มย้อนกลับ
                              context.push(
                                '/gensub/result',
                                extra: {
                                  'workspaceId': project.projectId,
                                  'userId': project.userId,
                                  'filePath': project.filePath,
                                  'duration': project.duration,
                                  'projectName': project.projectName,
                                },
                              );
                            }
                          },
                    icon: _loading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(Icons.play_arrow_rounded, size: 24.w),
                    label: Text(
                      _loading
                          ? "text_to_gensub.transcribing".tr()
                          : "text_to_gensub.transcribe_status".tr(),
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: Size.fromHeight(50.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          if (widget.projects.isNotEmpty) _buildProjectList(),
        ],
      ),
    );
  }

  // Helper widget for cleaner dropdown rows
  Widget _buildDropdownRow<T>({
    required String title,
    required T value,
    required List<T> items,
    required Function(T?) onChanged,
    required String Function(T) labelBuilder,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 1. ใช้ Expanded หุ้ม Text เพื่อให้ Text ยืดหยุ่นและไม่ดัน Dropdown ตกขอบ
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis, // เพิ่มการตัดคำกรณีพื้นที่ไม่พอจริงๆ
            maxLines: 1, 
          ),
        ),
        SizedBox(width: 12.w), // เพิ่มระยะห่างระหว่าง Text กับ Dropdown
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isDense: true,
              icon: Icon(Icons.keyboard_arrow_down,
                  size: 20.w, color: Colors.grey),
              style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              items: items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(labelBuilder(item)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectList() {
    String formatDate(DateTime dt) =>
        DateFormat('dd/MM/yyyy, HH:mm').format(dt);

    String formatDuration(Duration d) {
      final m = d.inMinutes.toString().padLeft(2, '0');
      final s = (d.inSeconds % 60).toString().padLeft(2, '0');
      return "$m:$s";
    }

    final isDescending = ref.watch(uploadRecordProvider).isDescending;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "text_to_gensub.project".tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  isDescending ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                  color: Colors.blueAccent,
                  size: 20.r,
                ),
                onPressed: () {
                  ref.read(uploadRecordProvider.notifier).toggleSort();
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.projects.length,
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            final project = widget.projects[index];
            return Card(
              color: Colors.white,
              shadowColor: Colors.black.withOpacity(0.05),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16.r),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => ResultScreen(
                  //         workspaceId: project.projectId,
                  //         userId: project.userId,
                  //         filePath: project.filePath,
                  //         duration: project.duration,
                  //         projectName: project.projectName),
                  //   ),
                  // );

                  // ใช้ context.push เพื่อเปิดหน้า Result แบบมีปุ่มย้อนกลับ
                  context.push(
                    '/gensub/result',
                    extra: {
                      'workspaceId': project.projectId,
                      'userId': project.userId,
                      'filePath': project.filePath,
                      'duration': project.duration,
                      'projectName': project.projectName,
                    },
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(Icons.audiotrack_rounded,
                            color: Colors.blue, size: 28.r),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.projectName,
                              style: TextStyle(
                                  fontSize: 14.sp, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${"text_to_gensub.create_at".tr()} ${formatDate(project.createdAt)}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              children: [
                                Icon(Icons.timer_outlined,
                                    size: 14.r, color: Colors.grey),
                                SizedBox(width: 4.w),
                                Text(
                                  formatDuration(project.duration),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (project.segments.isNotEmpty) ...[
                                  SizedBox(width: 12.w),
                                  Icon(Icons.text_snippet_outlined,
                                      size: 14.r, color: Colors.grey),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "${project.segments.length}",
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete_outline_rounded,
                                color: Colors.red.shade300, size: 20.r),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text("dialog.delete_project_title".tr(),
                                      style: TextStyle(fontSize: 16.sp)),
                                  content: Text("dialog.delete_project_content".tr(),
                                      style: TextStyle(fontSize: 14.sp)),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // Navigator.pop(context, false);
                                        context.pop(false);
                                      },
                                      child: Text("dialog.cancel".tr()),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Navigator.pop(context, true);
                                        context.pop(true);
                                      },
                                      child: Text(
                                        "dialog.delete".tr(),
                                        style: const TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                widget.onProjectDeleted(project);
                              }
                            },
                          ),
                          Icon(Icons.arrow_forward_ios_rounded,
                              size: 14.r, color: Colors.grey[400]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}