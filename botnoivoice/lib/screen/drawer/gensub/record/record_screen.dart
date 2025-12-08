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
  bool _isDescending = true;

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

    controller = RecordLogic(
      currentUserId: "USER_ID_PLACEHOLDER",
    );

    controller.initRecorder();
    controller.initPlayer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProjects();
    });
  }

  DateTime _parseDate(dynamic dateStr) {
    if (dateStr == null || dateStr.toString().isEmpty) return DateTime.now();
    try {
      String cleanStr = dateStr.toString().replaceAll('Z', '');
      return DateTime.tryParse(cleanStr) ?? DateTime.now();
    } catch (e) {
      return DateTime.now();
    }
  }

  Future<void> _loadProjects() async {
    _safeSetState(() => _loading = true);
    try {
      final res = await getAllWorkspaces(ref);

      if (res != null && res['data'] != null) {
        _projects = (res['data'] as List).map((json) {
          final rawDuration = json['duration']?.toString();
          Duration parsedDuration = Duration.zero;
          
          if (rawDuration != null && rawDuration.isNotEmpty) {
             if (rawDuration.contains(":")) {
                final parts = rawDuration.split(":");
                if (parts.length == 2) {
                  final minutes = int.tryParse(parts[0]) ?? 0;
                  final seconds = int.tryParse(parts[1]) ?? 0;
                  parsedDuration = Duration(minutes: minutes, seconds: seconds);
                }
              } else {
                final seconds = int.tryParse(rawDuration) ?? 0;
                parsedDuration = Duration(seconds: seconds);
              }
          }

          return ProjectModel(
            projectId: json['project_id'] ?? '',
            projectName: json['project_name'] ?? '',
            createdAt: _parseDate(json['create_at']),
            duration: parsedDuration,
            filePath: json['file_path'] ?? '',
            segments: json['segments'] != null
                ? List<Map<String, dynamic>>.from(json['segments'])
                : [],
            userId: json['user_id'] ?? '',
            audioS3Link: null,
          );
        }).toList();

        _sortProjects();
      }
    } catch (e) {
      debugPrint("Failed to load projects: $e");
    }
    _safeSetState(() => _loading = false);
  }

  void _sortProjects() {
    _projects.sort((a, b) => _isDescending
        ? b.createdAt.compareTo(a.createdAt)
        : a.createdAt.compareTo(b.createdAt));
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

  Widget _buildInitialUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SizedBox( // ✅ เพิ่ม SizedBox เพื่อขยายความกว้างเต็มจอ
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // ✅ จัด Column หลักให้อยู่ตรงกลาง
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // ✅ จัด Column ย่อยให้อยู่ตรงกลาง
                children: [
                  Text(
                    "record_gensub.title".tr(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center, // ✅ จัดข้อความให้อยู่ตรงกลาง
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "record_gensub.expand_title".tr(),
                    style: const TextStyle(color: Colors.black54),
                    textAlign: TextAlign.center, // ✅ จัดข้อความให้อยู่ตรงกลาง
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
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
                  Text(
                    "record_gensub.press_to".tr(),
                    style: const TextStyle(color: Colors.black54),
                    textAlign: TextAlign.center, // ✅ จัดข้อความให้อยู่ตรงกลาง
                  ),
                ],
              ),
            ),
            if (_projects.isNotEmpty) _buildProjectList(),
          ],
        ),
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "text_to_gensub.project".tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              IconButton(
                icon: Icon(
                  _isDescending ? Icons.arrow_downward : Icons.arrow_upward,
                  color: Colors.blueAccent,
                  size: 20,
                ),
                onPressed: () {
                  _safeSetState(() {
                    _isDescending = !_isDescending;
                    _sortProjects();
                  });
                },
              ),
            ],
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
                        
                        if (project.segments.isNotEmpty) ...[
                          const SizedBox(width: 12),
                          const Icon(Icons.text_snippet,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
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
                          await controller.deleteProject(
                            ref,
                            project.projectId,
                          );

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
                        projectName: project.projectName
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

  Widget _buildConfirmUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SizedBox( // ✅ เพิ่ม SizedBox เพื่อขยายเต็มจอสำหรับหน้านี้ด้วย
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "record_gensub.title".tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // ✅ จัดกลาง
            ),
            const SizedBox(height: 8),
            Text("record_gensub.expand_title".tr(),
                style: const TextStyle(color: Colors.black54),
                textAlign: TextAlign.center, // ✅ จัดกลาง
            ),
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
      ),
    );
  }

  Widget _buildSettingsUI() {
    final fileName = controller.recordedFilePath != null
        ? controller.recordedFilePath!.split('/').last
        : "";

    return SingleChildScrollView(
      child: Column(
        children: [
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

                  ElevatedButton.icon(
                    onPressed: _loading
                        ? null
                        : () async {
                            _safeSetState(() => _loading = true);
                            
                            // 🔥🔥🔥 แก้ไขตรงนี้: ส่ง context เข้าไปในฟังก์ชัน handleTranscribe
                            final project = await controller.handleTranscribe(
                              ref,
                              context, // <--- เพิ่ม context เพื่อให้ Logic แสดง SnackBar ได้
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
                                    projectName: project.projectName
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
          const SizedBox(height: 20),
          if (_projects.isNotEmpty) _buildProjectList(),
        ],
      ),
    );
  }
}