import 'package:botnoivoice/screen/drawer/gensub/point_calculator.dart';
import 'package:flutter/material.dart';
import 'package:botnoivoice/screen/drawer/gensub/models/project_model.dart';
import 'package:botnoivoice/screen/drawer/gensub/upload/upload_screen_logic.dart';
import 'package:botnoivoice/screen/drawer/gensub/uploadwithrecord/upload_rec_logic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as path;
import 'package:botnoivoice/screen/drawer/gensub/language_selector.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Container(
      color: const Color(0xFFF8F9FD), // พื้นหลังโทนสว่าง
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.filePath == null)
              _buildUploadCard()
            else
              _buildSettingsCard(),
            SizedBox(height: 24.h),
            if (widget.projects.isNotEmpty) _buildProjectList(),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadCard() {
    return Center(
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        // 1. เปลี่ยนจาก Container เป็น Padding และเอา height: 220.h ออก
        // เพื่อให้ Card ยืดตามเนื้อหา ไม่เกิด Overflow
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // ให้ Column ใช้พื้นที่เท่าที่จำเป็น
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cloud_upload_rounded,
                  color: Colors.blue,
                  size: 40.r,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "upload_gensub.title".tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                "upload_gensub.expand_title".tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              SizedBox(
                height: 40.h,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await controller.pickFile();
                    setState(() {});
                  },
                  icon: Icon(Icons.folder_open_rounded, size: 20.r),
                  label: Text(
                    "upload_gensub.upload".tr(),
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                  ),
                ),
              ),
            ],
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
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // File Name Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.audio_file_rounded,
                      color: Colors.blue, size: 24.h),
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
                  icon: Icon(Icons.delete_outline_rounded,
                      color: Colors.red, size: 24.h),
                  onPressed: () {
                    controller.clearFile();
                    setState(() {});
                  },
                ),
              ],
            ),
            Divider(height: 32.h, color: Colors.grey.shade100),

            // Language
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "text_to_gensub.audio_language".tr(),
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
            SizedBox(height: 16.h),

            // Duration
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

            // Expansion Settings
            Theme(
              data: 
                Theme.of(context).copyWith(dividerColor: Colors.transparent),
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
                    value: controller.maxSegmentDuration,
                    items: [
                      "1 ${"units.seconds".tr()}",
                      "2 ${"units.seconds".tr()}",
                      "5 ${"units.seconds".tr()}",
                      "10 ${"units.seconds".tr()}",
                      "15 ${"units.seconds".tr()}",
                      "20 ${"units.seconds".tr()}",
                      "25 ${"units.seconds".tr()}",
                      "30 ${"units.seconds".tr()}",
                      "units.unlimited".tr(),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => controller.maxSegmentDuration = val);
                      }
                    },
                    labelBuilder: (val) =>
                        val, // String already contains format
                  ),
                  SizedBox(height: 12.h),
                  _buildDropdownRow(
                    title: "text_to_gensub.max_silence_duration".tr(),
                    value: controller.maxSilenceDuration,
                    items: [
                      "0.1 ${"units.seconds".tr()}",
                      "0.3 ${"units.seconds".tr()}",
                      "0.5 ${"units.seconds".tr()}",
                      "0.7 ${"units.seconds".tr()}",
                      "0.9 ${"units.seconds".tr()}",
                      "1.5 ${"units.seconds".tr()}",
                      "units.unlimited".tr(),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => controller.maxSilenceDuration = val);
                      }
                    },
                    labelBuilder: (val) => val,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // --- Total Points UI ---
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
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
            // ---------------------

            SizedBox(height: 24.h),

            // Transcribe Button
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
                        context.push(
                          '/gensub/result',
                          extra: {
                            'workspaceId': controller.lastProject!.projectId,
                            'userId': controller.lastProject!.userId,
                            'filePath': controller.lastProject!.filePath,
                            'duration': controller.lastProject!.duration,
                            'projectName': controller.lastProject!.projectName,
                          },
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
                  : Icon(Icons.play_arrow_rounded, size: 24.w),
              label: Text(
                isLoading
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
            if (controller.transcribeStatus != null) ...[
              SizedBox(height: 12.h),
              Center(
                child: Text(
                  controller.transcribeStatus!,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper widget for dropdown rows (Consistent with RecordScreen)
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
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        SizedBox(width: 12.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: items.contains(value) ? value : items.first, // Safe check
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
                  isDescending
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
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
        SizedBox(height: 12.h),
        ...widget.projects.map((project) {
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
                                content: Text(
                                    "dialog.delete_project_content".tr(),
                                    style: TextStyle(fontSize: 14.sp)),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      context.pop(false);
                                    },
                                    child: Text("dialog.cancel".tr()),
                                  ),
                                  TextButton(
                                    onPressed: () {
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
        }),
      ],
    );
  }
}
