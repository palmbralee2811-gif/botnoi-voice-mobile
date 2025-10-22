import 'package:botnoivoice/screen/drawer/gensub/models/project_model.dart';
import 'package:botnoivoice/screen/drawer/gensub/result/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:botnoivoice/screen/drawer/gensub/record/record_screen_logic.dart';

// Import Standalone API Functions ที่ใช้โดยตรงใน Widget (สำหรับ _loadProjects)
import 'package:botnoivoice/screen/drawer/gensub/service/project_asr_api.dart';

class RecordScreen extends StatefulWidget {
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
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  late RecordLogic controller;
  bool _confirmed = false;
  bool _loading = false;
  
  // Note: ลบ bool _isLoading ออก เพราะไม่ได้ใช้
  // bool _isLoading = false; 
  
  List<ProjectModel> _projects = [];

  // UI controls
  String _selectedLanguage = "ไทย";
  String _maxSegmentDuration = "10 วินาที";
  String _maxSilenceDuration = "0.3 วินาที";

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
      currentUserId: "USER_ID_PLACEHOLDER", // <<< ใช้ค่า placeholder หรือดึงจาก Provider อื่น
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
      final res = await getAllWorkspaces(context); 
      
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
                const Text("อัดเสียงถอดข้อความ",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text("ถอดข้อความจากไฟล์เสียงที่อัด",
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => controller.toggleRecording(_safeSetState),
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
          child: const Text(
            "Botnoi GenSub project",
            style: TextStyle(
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
                            content: const Text(
                                "คุณแน่ใจหรือไม่ที่จะลบโปรเจกต์นี้?"),
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
                          // ✅ แก้ไข: ส่ง context เข้าไปใน deleteProject
                          await controller.deleteProject(context, project.projectId);
                          
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
          const Text("อัดเสียงถอดข้อความ",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("ถอดข้อความจากไฟล์เสียงที่อัด",
              style: TextStyle(fontSize: 16, color: Colors.grey)),
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
          const Text("กด ✓ เพื่อส่งข้อมูล",
              style: TextStyle(fontSize: 16, color: Colors.grey)),
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------------- ไฟล์เสียง ----------------
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

                  // ---------------- เลือกภาษา ----------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("ภาษาของไฟล์เสียง"),
                      DropdownButton<String>(
                        value: _selectedLanguage,
                        items: const [
                          DropdownMenuItem(value: "ไทย", child: Text("ไทย")),
                          DropdownMenuItem(value: "อังกฤษ", child: Text("อังกฤษ")),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            _safeSetState(() => _selectedLanguage = val);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ---------------- เวลา ----------------
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

                  // ---------------- ตั้งค่าตัดข้อความ ----------------
                  ExpansionTile(
                    title: const Text("ตั้งค่าการตัดข้อความ"),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("ระยะเวลาสูงสุดในการตัด"),
                          DropdownButton<String>(
                            value: _maxSegmentDuration,
                            items: const [
                              DropdownMenuItem(value: "1 วินาที", child: Text("1 วินาที")),
                              DropdownMenuItem(value: "5 วินาที", child: Text("5 วินาที")),
                              DropdownMenuItem(value: "10 วินาที", child: Text("10 วินาที")),
                              DropdownMenuItem(value: "15 วินาที", child: Text("15 วินาที")),
                              DropdownMenuItem(value: "30 วินาที", child: Text("30 วินาที")),
                              DropdownMenuItem(value: "ไม่จำกัด", child: Text("ไม่จำกัด")),
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
                          const Text("ช่วงเงียบสูงสุดในการตัด"),
                          DropdownButton<String>(
                            value: _maxSilenceDuration,
                            items: const [
                              DropdownMenuItem(value: "0.1 วินาที", child: Text("0.1 วินาที")),
                              DropdownMenuItem(value: "0.3 วินาที", child: Text("0.3 วินาที")),
                              DropdownMenuItem(value: "0.5 วินาที", child: Text("0.5 วินาที")),
                              DropdownMenuItem(value: "0.7 วินาที", child: Text("0.7 วินาที")),
                              DropdownMenuItem(value: "1.0 วินาที", child: Text("1.0 วินาที")),
                              DropdownMenuItem(value: "ไม่จำกัด", child: Text("ไม่จำกัด")),
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

                  // ---------------- ปุ่มถอดเสียง ----------------
                  ElevatedButton.icon(
                    onPressed: _loading
                        ? null
                        : () async {
                              _safeSetState(() => _loading = true);

                              // ✅ แก้ไข: ส่ง context เข้าไปใน handleTranscribe
                              final project = await controller.handleTranscribe(
                                context,
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
                                // ✅ โหลด projects ใหม่หลังจากสร้างสำเร็จ (เรียก _loadProjects ที่ถูกแก้ไขแล้ว)
                                await _loadProjects();
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
                    label: Text(_loading ? "กำลังถอด..." : "ถอดไฟล์เสียง"),
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