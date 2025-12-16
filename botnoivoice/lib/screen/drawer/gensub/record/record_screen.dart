import 'dart:async';

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

  // --- 2. ตัวแปรสำหรับจับเวลา ---
  Timer? _timer;
  int _recordSeconds = 0;

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
  }

  @override
  void dispose() {
    // --- 3. ยกเลิก Timer เมื่อปิดหน้าจอ ---
    _timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  // --- 4. ฟังก์ชันจัดรูปแบบเวลา (แปลงวินาที เป็น 00:00) ---
  String get _formattedTimer {
    final minutes = (_recordSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_recordSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  // --- 5. ฟังก์ชันจัดการการกดปุ่ม (เริ่ม/หยุด Timer + Logic เดิม) ---
  void _handleRecordingToggle() {
    // เรียก logic เดิมของ controller
    controller.toggleRecording(context, (fn) {
      _safeSetState(fn); // เรียก setState ของ logic เดิม

      // เพิ่ม logic จับเวลา
      if (controller.isRecording) {
        // ถ้าสถานะเป็น Recording (เริ่มอัด) -> เริ่มนับเวลา
        _recordSeconds = 0;
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordSeconds++;
          });
        });
      } else {
        // ถ้าหยุดอัด -> หยุดนับเวลา
        _timer?.cancel();
      }
    });
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
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "record_gensub.title".tr(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "record_gensub.expand_title".tr(),
                    style: const TextStyle(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    // --- 6. แก้ไข onTap ให้เรียกฟังก์ชันใหม่ ---
                    onTap: _handleRecordingToggle,
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
                  
                  // --- 7. แสดงเวลา หรือ ข้อความกดเพื่ออัด ---
                  if (controller.isRecording)
                    Text(
                      _formattedTimer, // แสดงเวลา 00:05
                      style: const TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold,
                        color: Colors.black87, // หรือ Colors.white ถ้าพื้นหลังดำ
                      ),
                    )
                  else
                    Text(
                      "record_gensub.press_to".tr(),
                      style: const TextStyle(color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
            if (widget.projects.isNotEmpty) _buildProjectList(),
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

    final isDescending = ref.watch(uploadRecordProvider).isDescending;

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
                  isDescending ? Icons.arrow_downward : Icons.arrow_upward,
                  color: Colors.blueAccent,
                  size: 20,
                ),
                onPressed: () {
                  ref.read(uploadRecordProvider.notifier).toggleSort();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.projects.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final project = widget.projects[index];
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
                          projectName: project.projectName),
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
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "record_gensub.title".tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "record_gensub.expand_title".tr(),
              style: const TextStyle(color: Colors.black54),
              textAlign: TextAlign.center,
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
                      // รีเซ็ตเวลาเมื่อกดถังขยะทิ้ง
                      _recordSeconds = 0;
                      _timer?.cancel();
                    });
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
                const SizedBox(width: 40),
                IconButton(
                  iconSize: 64,
                  onPressed: () => controller.togglePlay(_safeSetState),
                  icon: Icon(
                    controller.isPlaying
                        ? Icons.stop_circle
                        : Icons.play_circle,
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
            if (widget.projects.isNotEmpty) _buildProjectList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsUI() {
    final fileName = controller.recordedFilePath != null
        ? controller.recordedFilePath!.split('/').last
        : "";

    // --- 3. คำนวณ Point ---
    int totalPoints =
        PointCalculator.calculateTotalPoints(controller.audioDuration);

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
                             // รีเซ็ตเวลา
                            _recordSeconds = 0;
                            _timer?.cancel();
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

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
                      Text("text_to_gensub.file_duration".tr()),
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

                  // --- 4. แสดงผล Total Points ---
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.cyan, width: 1.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total points",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/logo/credit-icon.svg',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "$totalPoints",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyan,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ResultScreen(
                                      workspaceId: project.projectId,
                                      userId: project.userId,
                                      filePath: project.filePath,
                                      duration: project.duration,
                                      projectName: project.projectName),
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
          if (widget.projects.isNotEmpty) _buildProjectList(),
        ],
      ),
    );
  }
}