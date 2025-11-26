import 'package:botnoivoice/screen/drawer/gensub/models/project_model.dart';
import 'package:botnoivoice/screen/drawer/gensub/result/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:botnoivoice/screen/drawer/gensub/record/record_screen_logic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:botnoivoice/screen/drawer/gensub/language_selector.dart';
import 'package:botnoivoice/screen/drawer/gensub/service/project_asr_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  // Note: ลบ bool _isLoading ออก เพราะไม่ได้ใช้
  // bool _isLoading = false;

  List<ProjectModel> _projects = [];

  // UI controls
  int _maxSegmentDuration = 10;
  double _maxSilenceDuration = 0.3;

  void _safeSetState(void Function() fn) {
    if (!mounted) return;
    setState(fn);
  }

  @override
  void initState() {
    super.initState();

    // ❌ ลบการใช้ dotenv และ ProjectApiService
    // final apiToken = dotenv.env['API_TOKEN'] ?? '';
    // final currentUserId = dotenv.env['USER_ID'] ?? '';

    // ✅ แก้ไข: สร้าง RecordLogic โดยไม่ต้องส่ง API Class/Token เข้าไป
    controller = RecordLogic(
      // api: ProjectApiService(apiToken), // <<< ลบออก
      currentUserId:
          "USER_ID_PLACEHOLDER", // <<< ใช้ค่า placeholder หรือดึงจาก Provider อื่น
    );

    controller.initRecorder();
    controller.initPlayer();

    // ✅ เรียก loadProjects หลังจาก widget build ครั้งแรก (เพื่อให้ context พร้อม)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProjects();
    });
  }

  // ✅ แก้ไข: _loadProjects ต้องรับ context เพื่อดึง Token
  Future<void> _loadProjects() async {
    _safeSetState(() => _loading = true);
    try {
      // ✅ เรียกใช้ Standalone API Function และส่ง context
      final res = await getAllWorkspaces(ref);

      if (res != null && res['data'] != null) {
        _projects = (res['data'] as List)
            .map((json) => ProjectModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint("Failed to load projects: $e");
    }
    _safeSetState(() => _loading = false);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.recordedFilePath == null) {
      return _buildInitialUI();
    } else if (!_confirmed) {
      return _buildConfirmUI();
    } else {
      return _buildSettingsUI();
    }
  }

  // ---------------- UI: ยังไม่ได้อัด ----------------
  Widget _buildInitialUI() {
    // ... (โค้ด UI เดิม)
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Text(
                  "record_gensub.title".tr(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("record_gensub.expand_title".tr(),
                    style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 20),
                GestureDetector(
                  //  แก้ไขตรงนี้: เพิ่ม context เข้าไปใน toggleRecording
                  onTap: () =>
                      controller.toggleRecording(context, _safeSetState),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: controller.isRecording
                        ? Colors.red
                        : Colors.lightBlueAccent,
                    child: Icon(
                      controller.isRecording ? Icons.stop : Icons.mic,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text("record_gensub.press_to".tr(),
                    style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          if (_projects.isNotEmpty) _buildProjectList(),
        ],
      ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
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
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _projects.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final project = _projects[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: ListTile(
                leading:
                    const Icon(Icons.audiotrack, color: Colors.blue, size: 36),
                title: Text(
                  project.projectName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
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
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          // ✅ แก้ไข: ส่ง context เข้าไปใน deleteProject
                          await controller.deleteProject(
                            ref,
                            project.projectId,
                          );

                          // ลบออกจาก UI และเรียก Callback
                          widget.onProjectDeleted(project);
                          _safeSetState(() {
                            _projects.removeWhere(
                                (p) => p.projectId == project.projectId);
                          });
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
          },
        ),
      ],
    );
  }

  /// ---------------- UI: อัดเสร็จ รอ confirm ----------------
  Widget _buildConfirmUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "record_gensub.title".tr(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text("record_gensub.expand_title".tr(),
              style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 64,
                onPressed: () {
                  _safeSetState(() {
                    controller.recordedFilePath = null;
                    controller.audioDuration = null;
                    _confirmed = false;
                  });
                },
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
              const SizedBox(width: 40),
              IconButton(
                iconSize: 64,
                onPressed: () => controller.togglePlay(_safeSetState),
                icon: Icon(
                  controller.isPlaying ? Icons.stop_circle : Icons.play_circle,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 40),
              IconButton(
                iconSize: 64,
                onPressed: () => _safeSetState(() => _confirmed = true),
                icon: const Icon(Icons.check_circle, color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text("record_gensub.press_correct".tr(),
              style: const TextStyle(color: Colors.black54)),
          if (_projects.isNotEmpty) _buildProjectList(),
        ],
      ),
    );
  }

  /// ---------------- UI: Confirm แล้ว (ตั้งค่า + ถอดเสียง) ----------------
  Widget _buildSettingsUI() {
    final fileName = controller.recordedFilePath != null
        ? controller.recordedFilePath!.split('/').last
        : "";

    return SingleChildScrollView(
      child: Column(
        children: [
          // ---------------- การ์ดหลัก ----------------
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- ชื่อไฟล์ ----------
                  Row(
                    children: [
                      const Icon(Icons.mic, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          fileName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _safeSetState(() {
                            controller.recordedFilePath = null;
                            controller.audioDuration = null;
                            _confirmed = false;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ---------- ภาษา ----------
                  // ---------- ภาษา ----------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("text_to_gensub.audio_language".tr()),
                      LanguageSelector(
                        selectedLanguage: controller.selectedLanguageName,
                        selectedLanguageImage: controller.selectedLanguageImage,
                        onSelected: (lang) {
                          setState(() {
                            controller.selectedLanguage = lang['code'];
                            controller.selectedLanguageImage = lang['image'];

                            // ✅ ตั้งชื่อภาษาให้ตรงกับ locale ปัจจุบัน
                            final locale = context.locale.languageCode;
                            switch (locale) {
                              case 'th':
                                controller.selectedLanguageName =
                                    lang['thaiName'];
                                break;
                              case 'id':
                                controller.selectedLanguageName =
                                    lang['indonesianName'];
                                break;
                              default:
                                controller.selectedLanguageName =
                                    lang['englishName'];
                            }
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ---------- เวลา ----------
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

                  // ---------- ตั้งค่าการตัด ----------
                  ExpansionTile(
                    title: Text("text_to_gensub.segmentation_settings".tr()),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("text_to_gensub.max_segment_duration".tr()),
                          DropdownButton<int>(
                            value: _maxSegmentDuration,
                            items: [
                              for (var sec in [1, 2, 5, 10, 15, 20, 25, 30])
                                DropdownMenuItem(
                                  value: sec,
                                  child: Text("$sec ${'units.seconds'.tr()}"),
                                ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                _safeSetState(() => _maxSegmentDuration = val);
                              }
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("text_to_gensub.max_silence_duration".tr()),
                          DropdownButton<double>(
                            value: _maxSilenceDuration,
                            items: [
                              for (var sec in [0.1, 0.3, 0.5, 0.7, 0.9, 1.5])
                                DropdownMenuItem(
                                  value: sec,
                                  child: Text("$sec ${'units.seconds'.tr()}"),
                                ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                _safeSetState(() => _maxSilenceDuration = val);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ---------- ปุ่มถอดเสียง ----------
                  ElevatedButton.icon(
                    onPressed: _loading
                        ? null
                        : () async {
                            _safeSetState(() => _loading = true);
                            final project = await controller.handleTranscribe(
                              ref,
                              maxSegmentDuration: _maxSegmentDuration,
                              maxSilenceDuration: _maxSilenceDuration,
                            );
                            _safeSetState(() => _loading = false);

                            if (project != null && mounted) {
                              widget.onProjectCreated(project);
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
                            }
                          },
                    icon: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.play_arrow),
                    label: Text(
                      _loading
                          ? "text_to_gensub.transcribing".tr()
                          : "text_to_gensub.transcribe_status".tr(),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---------- ส่วนโปรเจคของฉัน ----------
          const SizedBox(height: 20),
          if (_projects.isNotEmpty) _buildProjectList(),
        ],
      ),
    );
  }
}
