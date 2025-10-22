import 'package:flutter/material.dart';
import 'package:botnoivoice/screen/drawer/gensub/models/project_model.dart';
import 'package:botnoivoice/screen/drawer/gensub/result/result_screen.dart';
import 'package:botnoivoice/screen/drawer/gensub/upload/upload_screen_logic.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';

class UploadScreen extends StatefulWidget {
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
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "อัปโหลดไฟล์เสียง",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text("ถอดข้อความจากไฟล์เสียงที่อัปโหลด",
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () async {
                  await controller.pickFile();
                  setState(() {});
                },
                icon: const Icon(Icons.upload_file, color: Colors.blue),
                label:
                    const Text("อัปโหลด", style: TextStyle(color: Colors.blue)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                const Text("ภาษาของไฟล์เสียง"),
                DropdownButton<String>(
                  value: controller.selectedLanguage,
                  items: const [
                    DropdownMenuItem(value: "ไทย", child: Text("ไทย")),
                    DropdownMenuItem(value: "อังกฤษ", child: Text("อังกฤษ")),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => controller.selectedLanguage = val);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("เวลาของไฟล์"),
                Text(
                  controller.audioDuration != null
                      ? "${controller.audioDuration!.inMinutes.toString().padLeft(2, '0')}:${(controller.audioDuration!.inSeconds % 60).toString().padLeft(2, '0')} นาที"
                      : "คำนวณอัตโนมัติเมื่อถอดเสียง",
                ),
              ],
            ),
            const SizedBox(height: 12),
            ExpansionTile(
              title: const Text("ตั้งค่าการตัดข้อความ"),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("ระยะเวลาสูงสุดในการตัด"),
                    DropdownButton<String>(
                      value: controller.maxSegmentDuration,
                      items: const [
                        DropdownMenuItem(
                            value: "1 วินาที", child: Text("1 วินาที")),
                        DropdownMenuItem(
                            value: "2 วินาที", child: Text("2 วินาที")),
                        DropdownMenuItem(
                            value: "5 วินาที", child: Text("5 วินาที")),
                        DropdownMenuItem(
                            value: "10 วินาที", child: Text("10 วินาที")),
                        DropdownMenuItem(
                            value: "15 วินาที", child: Text("15 วินาที")),
                        DropdownMenuItem(
                            value: "20 วินาที", child: Text("20 วินาที")),
                        DropdownMenuItem(
                            value: "25 วินาที", child: Text("25 วินาที")),
                        DropdownMenuItem(
                            value: "30 วินาที", child: Text("30 วินาที")),
                        DropdownMenuItem(
                            value: "ไม่จำกัด", child: Text("ไม่จำกัด")),
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
                    const Text("ช่วงเงียบสูงสุดในการตัด"),
                    DropdownButton<String>(
                      value: controller.maxSilenceDuration,
                      items: const [
                        DropdownMenuItem(
                            value: "0.1 วินาที", child: Text("0.1 วินาที")),
                        DropdownMenuItem(
                            value: "0.3 วินาที", child: Text("0.3 วินาที")),
                        DropdownMenuItem(
                            value: "0.5 วินาที", child: Text("0.5 วินาที")),
                        DropdownMenuItem(
                            value: "0.7 วินาที", child: Text("0.7 วินาที")),
                        DropdownMenuItem(
                            value: "0.9 วินาที", child: Text("0.9 วินาที")),
                        DropdownMenuItem(
                            value: "1.5 วินาที", child: Text("1.5 วินาที")),
                        DropdownMenuItem(
                            value: "ไม่จำกัด", child: Text("ไม่จำกัด")),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => controller.maxSilenceDuration = val);
                        }
                      },
                    ),
                  ],
                ),
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
                      final success = await controller.transcribeFile(context);

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
              label: Text(isLoading ? "กำลังถอด..." : "ถอดไฟล์เสียง"),
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
          child: const Text(
            "Botnoi GenSub project",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent),
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
                  Text("สร้างเมื่อ: ${formatDate(project.createdAt)}"),
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
                          title: const Text("ลบโปรเจกต์"),
                          content:
                              const Text("คุณแน่ใจหรือไม่ที่จะลบโปรเจกต์นี้?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("ยกเลิก"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("ลบ",
                                  style: TextStyle(color: Colors.red)),
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