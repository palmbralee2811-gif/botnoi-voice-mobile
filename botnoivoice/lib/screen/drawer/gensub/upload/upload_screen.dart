import 'package:botnoivoice/screen/drawer/gensub/point_calculator.dart';
import 'package:flutter/material.dart';
import 'package:botnoivoice/screen/drawer/gensub/models/project_model.dart';
import 'package:botnoivoice/screen/drawer/gensub/result/result_screen.dart';
import 'package:botnoivoice/screen/drawer/gensub/upload/upload_screen_logic.dart';
import 'package:botnoivoice/screen/drawer/gensub/uploadwithrecord/upload_rec_logic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:botnoivoice/screen/drawer/gensub/language_selector.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 1. เพิ่ม Import ScreenUtil

class UploadScreen extends ConsumerStatefulWidget {
  final List<ProjectModel> projects;
  final Function(ProjectModel) onProjectCreated;
  final Function(ProjectModel) onProjectDeleted;

  const UploadScreen({
    super.key,
    required this.projects,
    required this.onProjectCreated,
    required this.onProjectDeleted,
  });

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  late UploadLogic controller;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controller = UploadLogic(
      onProjectCreated: widget.onProjectCreated,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ใช้ .w, .h สำหรับ padding
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.filePath == null)
            _buildUploadCard()
          else
            _buildSettingsCard(),
          SizedBox(height: 20.h),
          if (widget.projects.isNotEmpty) _buildProjectList(),
        ],
      ),
    );
  }

  Widget _buildUploadCard() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r)), // .r สำหรับ radius
        elevation: 3,
        child: SizedBox(
          height: 200.h, // .h สำหรับ height
          width: double.infinity,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "upload_gensub.title".tr(),
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold), // .sp สำหรับ font
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 6.h),
                Text(
                  "upload_gensub.expand_title".tr(),
                  style: const TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                OutlinedButton.icon(
                  onPressed: () async {
                    await controller.pickFile();
                    setState(() {});
                  },
                  icon: const Icon(Icons.upload_file, color: Colors.blue),
                  label: Text(
                    "upload_gensub.upload".tr(),
                    style: const TextStyle(color: Colors.blue),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                    padding: EdgeInsets.symmetric(
                        horizontal: 24.w, vertical: 12.h), // ปรับ padding ปุ่ม
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard() {
    final fileName =
        controller.filePath != null ? path.basename(controller.filePath!) : "";

    int totalPoints =
        PointCalculator.calculateTotalPoints(controller.audioDuration);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(24.w), // ปรับ padding ใน card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.mic, color: Colors.blue),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(fileName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    controller.clearFile();
                    setState(() {});
                  },
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "text_to_gensub.audio_language".tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                          controller.selectedLanguageName =
                              lang['indonesianName'];
                          break;
                        default:
                          controller.selectedLanguageName = lang['englishName'];
                      }
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("text_to_gensub.file_duration".tr()),
                Text(
                  controller.audioDuration != null
                      ? "${controller.audioDuration!.inMinutes.toString().padLeft(2, '0')}:${(controller.audioDuration!.inSeconds % 60).toString().padLeft(2, '0')} ${'units.minutes'.tr()}"
                      : "text_to_gensub.duration_auto_calculate".tr(),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            ExpansionTile(
              title: Text("text_to_gensub.segmentation_settings".tr()),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("text_to_gensub.max_segment_duration".tr()),
                    DropdownButton<String>(
                      value: [
                        "1 ${"units.seconds".tr()}",
                        "2 ${"units.seconds".tr()}",
                        "5 ${"units.seconds".tr()}",
                        "10 ${"units.seconds".tr()}",
                        "15 ${"units.seconds".tr()}",
                        "20 ${"units.seconds".tr()}",
                        "25 ${"units.seconds".tr()}",
                        "30 ${"units.seconds".tr()}",
                        "units.unlimited".tr(),
                      ].contains(controller.maxSegmentDuration)
                          ? controller.maxSegmentDuration
                          : "10 ${"units.seconds".tr()}",
                      items: [
                        for (var sec in [1, 2, 5, 10, 15, 20, 25, 30])
                          DropdownMenuItem(
                            value: "$sec ${"units.seconds".tr()}",
                            child: Text("$sec ${"units.seconds".tr()}"),
                          ),
                        DropdownMenuItem(
                          value: "units.unlimited".tr(),
                          child: Text("units.unlimited".tr()),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => controller.maxSegmentDuration = val);
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("text_to_gensub.max_silence_duration".tr()),
                    DropdownButton<String>(
                      value: [
                        "0.1 ${"units.seconds".tr()}",
                        "0.3 ${"units.seconds".tr()}",
                        "0.5 ${"units.seconds".tr()}",
                        "0.7 ${"units.seconds".tr()}",
                        "0.9 ${"units.seconds".tr()}",
                        "1.5 ${"units.seconds".tr()}",
                        "units.unlimited".tr(),
                      ].contains(controller.maxSilenceDuration)
                          ? controller.maxSilenceDuration
                          : "0.3 ${"units.seconds".tr()}",
                      items: [
                        for (var sec in [
                          "0.1",
                          "0.3",
                          "0.5",
                          "0.7",
                          "0.9",
                          "1.5"
                        ])
                          DropdownMenuItem(
                            value: "$sec ${"units.seconds".tr()}",
                            child: Text("$sec ${"units.seconds".tr()}"),
                          ),
                        DropdownMenuItem(
                          value: "units.unlimited".tr(),
                          child: Text("units.unlimited".tr()),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => controller.maxSilenceDuration = val);
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 16.h),

            // --- UI แสดงผล Total Points (Responsive) ---
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.cyan, width: 1.5.w),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total points",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
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
            // -----------------------------

            SizedBox(height: 16.h),
            ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() => isLoading = true);

                      final success =
                          await controller.transcribeFile(ref, context);

                      if (mounted) {
                        setState(() => isLoading = false);
                      }

                      if (success &&
                          mounted &&
                          controller.lastProject != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ResultScreen(
                              workspaceId: controller.lastProject!.projectId,
                              userId: controller.lastProject!.userId,
                              filePath: controller.lastProject!.filePath,
                              duration: controller.lastProject!.duration,
                              projectName: controller.lastProject!.projectName,
                            ),
                          ),
                        );
                      }
                    },
              icon: isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(isLoading
                  ? "text_to_gensub.transcribing".tr()
                  : "text_to_gensub.transcribe_status".tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: Size.fromHeight(50.h), // ปุ่มสูง 50.h
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            if (controller.transcribeStatus != null) ...[
              SizedBox(height: 12.h),
              Text(
                controller.transcribeStatus!,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProjectList() {
    String formatDate(DateTime dt) {
      return DateFormat('dd/MM/yyyy, HH:mm').format(dt);
    }

    String formatDuration(Duration d) {
      final m = d.inMinutes.toString().padLeft(2, '0');
      final s = (d.inSeconds % 60).toString().padLeft(2, '0');
      return "$m:$s";
    }

    final isDescending = ref.watch(uploadRecordProvider).isDescending;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
              color: Colors.blue[50], borderRadius: BorderRadius.circular(8.r)),
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
                icon: Icon(
                  isDescending ? Icons.arrow_downward : Icons.arrow_upward,
                  color: Colors.blueAccent,
                  size: 20.r,
                ),
                tooltip: isDescending ? "Newest First" : "Oldest First",
                onPressed: () {
                  ref.read(uploadRecordProvider.notifier).toggleSort();
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        ...widget.projects.map((project) {
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r)),
            elevation: 2,
            child: ListTile(
              leading: Icon(Icons.audiotrack, color: Colors.blue, size: 36.r),
              title: Text(project.projectName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${"text_to_gensub.create_at".tr()} ${formatDate(project.createdAt)}',
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 14.r, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Text(formatDuration(project.duration)),
                      if (project.segments.isNotEmpty) ...[
                        SizedBox(width: 12.w),
                        Icon(Icons.text_snippet,
                            size: 14.r, color: Colors.grey),
                        SizedBox(width: 4.w),
                        Text("${project.segments.length}"),
                      ],
                    ],
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text("dialog.delete_project_title".tr()),
                          content: Text("dialog.delete_project_content".tr()),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text("dialog.cancel".tr()),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
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
                  Icon(Icons.arrow_forward_ios, size: 16.r),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResultScreen(
                      workspaceId: project.projectId,
                      userId: project.userId,
                      filePath: project.filePath,
                      duration: project.duration,
                      projectName: project.projectName,
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
