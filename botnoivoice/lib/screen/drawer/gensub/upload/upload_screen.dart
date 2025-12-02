import 'package:flutter/material.dart';
import 'package:botnoivoice/screen/drawer/gensub/models/project_model.dart';
import 'package:botnoivoice/screen/drawer/gensub/result/result_screen.dart';
import 'package:botnoivoice/screen/drawer/gensub/upload/upload_screen_logic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:botnoivoice/screen/drawer/gensub/language_selector.dart';

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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.filePath == null)
            _buildUploadCard()
          else
            _buildSettingsCard(),
          const SizedBox(height: 20),
          if (widget.projects.isNotEmpty) _buildProjectList(),
        ],
      ),
    );
  }

  Widget _buildUploadCard() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: SizedBox(
          height: 200, // ✅ เพิ่มความสูงให้มีพื้นที่วางตรงกลาง
          width: double.infinity,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "upload_gensub.title".tr(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center, // ✅ จัดให้กลางแนวนอน
                ),
                const SizedBox(height: 6),
                Text(
                  "upload_gensub.expand_title".tr(),
                  style: const TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center, // ✅ จัดให้กลางแนวนอน
                ),
                const SizedBox(height: 20),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
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

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.mic, color: Colors.blue),
                const SizedBox(width: 8),
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("text_to_gensub.audio_language".tr()),
                LanguageSelector(
                  selectedLanguage:
                      controller.selectedLanguageName, // <-- ใช้ชื่อแทน
                  selectedLanguageImage: controller.selectedLanguageImage,
                  onSelected: (lang) {
                    setState(() {
                      controller.selectedLanguage = lang['code'];
                      controller.selectedLanguageImage = lang['image'];

                      // แสดงชื่อให้ตรงกับภาษาของแอป
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

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("text_to_gensub.audio_time".tr()),
                Text(
                  controller.audioDuration != null
                      ? "${controller.audioDuration!.inMinutes.toString().padLeft(2, '0')}:${(controller.audioDuration!.inSeconds % 60).toString().padLeft(2, '0')} ${'units.minutes'.tr()}"
                      : "text_to_gensub.duration_auto_calculate".tr(),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 16),

            // ปุ่มถอดเสียงพร้อม loading ข้างใน
            ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() => isLoading = true);

                      // ✅ แก้ไข: ส่ง context เข้าไปใน transcribeFile
                      final success =
                          await controller.transcribeFile(ref, context);

                      if (mounted) {
                        setState(() => isLoading = false);
                      }

                      if (success &&
                          mounted &&
                          controller.lastProject != null) {
                        widget.onProjectCreated(controller.lastProject!);
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
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
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
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            if (controller.transcribeStatus != null) ...[
              const SizedBox(height: 12),
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

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
          child: Text(
            "text_to_gensub.project".tr(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ...widget.projects.map((project) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: ListTile(
              leading:
                  const Icon(Icons.audiotrack, color: Colors.blue, size: 36),
              title: Text(project.projectName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${"text_to_gensub.create_at".tr()} ${formatDate(project.createdAt)}',
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(formatDuration(project.duration)),
                      const SizedBox(width: 12),
                      const Icon(Icons.text_snippet,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("${project.segments.length}"),
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
                                style: const TextStyle(
                                    color: Colors
                                        .red), // <--- **ใส่ 'const' ที่นี่**
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
                  const Icon(Icons.arrow_forward_ios, size: 16),
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
