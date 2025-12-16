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
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 1. Import ScreenUtil

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
      padding: EdgeInsets.all(16.w), // .w
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h), // .h
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "record_gensub.title".tr(),
                    style: TextStyle(
                      fontSize: 18.sp, // .sp
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h), // .h
                  Text(
                    "record_gensub.expand_title".tr(),
                    style: TextStyle(
                      fontSize: 12.sp, // .sp
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h), // .h
                  GestureDetector(
                    onTap: _handleRecordingToggle,
                    child: CircleAvatar(
                      radius: 45.r, // .r
                      backgroundColor: controller.isRecording
                          ? Colors.red
                          : Colors.lightBlueAccent,
                      child: Icon(
                        controller.isRecording ? Icons.stop : Icons.mic,
                        size: 40.r, // .r
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h), // .h

                  if (controller.isRecording)
                    Text(
                      _formattedTimer,
                      style: TextStyle(
                        fontSize: 20.sp, // .sp
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    )
                  else
                    Text(
                      "record_gensub.press_to".tr(),
                      style: TextStyle(
                        fontSize: 12.sp, // .sp
                        color: Colors.black54,
                      ),
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
          padding:
              EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h), // .w, .h
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8.r), // .r
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "text_to_gensub.project".tr(),
                style: TextStyle(
                  fontSize: 16.sp, // .sp
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              IconButton(
                icon: Icon(
                  isDescending ? Icons.arrow_downward : Icons.arrow_upward,
                  color: Colors.blueAccent,
                  size: 20.r, // .r
                ),
                onPressed: () {
                  ref.read(uploadRecordProvider.notifier).toggleSort();
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h), // .h
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.projects.length,
          separatorBuilder: (_, __) => SizedBox(height: 8.h), // .h
          itemBuilder: (context, index) {
            final project = widget.projects[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r), // .r
              ),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.audiotrack,
                    color: Colors.blue, size: 36.r), // .r
                title: Text(
                  project.projectName,
                  style: TextStyle(
                    fontSize: 12.sp, // .sp (ตามต้นแบบ)
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${"text_to_gensub.create_at".tr()} ${formatDate(project.createdAt)}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ), // .sp
                    ),
                    SizedBox(height: 2.h), // .h
                    Row(
                      children: [
                        Icon(
                          Icons.timer,
                          size: 14.r,
                          color: Colors.grey,
                        ), // .r
                        SizedBox(width: 4.w), // .w
                        Text(
                          formatDuration(project.duration),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ), // .sp
                        ),
                        if (project.segments.isNotEmpty) ...[
                          SizedBox(width: 12.w), // .w
                          Icon(Icons.text_snippet,
                              size: 14.r, color: Colors.grey), // .r
                          SizedBox(width: 4.w), // .w
                          Text(
                            "${project.segments.length}",
                            style: TextStyle(fontSize: 12.sp), // .sp
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 24.h,
                      ), // .h
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(
                              "dialog.delete_project_title".tr(),
                              style: TextStyle(fontSize: 16.sp), // .sp
                            ),
                            content: Text(
                              "dialog.delete_project_content".tr(),
                              style: TextStyle(fontSize: 14.sp), // .sp
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(
                                  "dialog.cancel".tr(),
                                  style: TextStyle(fontSize: 14.sp), // .sp
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(
                                  "dialog.delete".tr(),
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14.sp, // .sp
                                  ),
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
                    Icon(Icons.arrow_forward_ios, size: 16.r), // .r
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
      padding: EdgeInsets.all(16.w), // .w
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 20.h), // .h
            Text(
              "record_gensub.title".tr(),
              style: TextStyle(
                fontSize: 18.sp, // .sp
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h), // .h
            Text(
              "record_gensub.expand_title".tr(),
              style: TextStyle(
                fontSize: 12.sp, // .sp
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h), // .h
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 64.r, // .r
                  onPressed: () {
                    _safeSetState(() {
                      controller.recordedFilePath = null;
                      controller.audioDuration = null;
                      _confirmed = false;
                      _recordSeconds = 0;
                      _timer?.cancel();
                    });
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
                SizedBox(width: 40.w), // .w
                IconButton(
                  iconSize: 64.r, // .r
                  onPressed: () => controller.togglePlay(_safeSetState),
                  icon: Icon(
                    controller.isPlaying
                        ? Icons.stop_circle
                        : Icons.play_circle,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 40.w), // .w
                IconButton(
                  iconSize: 64.r, // .r
                  onPressed: () => _safeSetState(() => _confirmed = true),
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                ),
              ],
            ),
            SizedBox(height: 20.h), // .h
            Text(
              "record_gensub.press_correct".tr(),
              style: TextStyle(
                fontSize: 12.sp, // .sp
                color: Colors.black54,
              ),
            ),
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

    int totalPoints =
        PointCalculator.calculateTotalPoints(controller.audioDuration);

    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r)), // .r
            elevation: 3,
            margin: EdgeInsets.all(20.w), // .w
            child: Padding(
              padding: EdgeInsets.all(24.w), // .w
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.mic, color: Colors.blue),
                      SizedBox(width: 8.w), // .w
                      Expanded(
                        child: Text(
                          fileName,
                          style: TextStyle(
                            fontSize: 12.sp, // .sp
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red, size: 24.r,),
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
                  SizedBox(height: 16.h), // .h

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "text_to_gensub.audio_language".tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.sp), // .sp
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

                  SizedBox(height: 12.h), // .h

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "text_to_gensub.file_duration".tr(),
                        style: TextStyle(fontSize: 12.sp), // .sp
                      ),
                      Text(
                        controller.audioDuration != null
                            ? "${controller.audioDuration!.inMinutes.toString().padLeft(2, '0')}:${(controller.audioDuration!.inSeconds % 60).toString().padLeft(2, '0')} ${'units.minutes'.tr()}"
                            : "text_to_gensub.duration_auto_calculate".tr(),
                        style: TextStyle(
                          fontSize: 12.sp, // .sp
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h), // .h

                  ExpansionTile(
                    title: Text(
                      "text_to_gensub.segmentation_settings".tr(),
                      style: TextStyle(fontSize: 12.sp), // .sp
                    ),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "text_to_gensub.max_segment_duration".tr(),
                            style: TextStyle(fontSize: 12.sp), // .sp
                          ),
                          DropdownButton<int>(
                            value: _maxSegmentDuration,
                            items: [
                              for (var sec in [1, 2, 5, 10, 15, 20, 25, 30])
                                DropdownMenuItem(
                                  value: sec,
                                  child: Text(
                                    "$sec ${'units.seconds'.tr()}",
                                    style: TextStyle(fontSize: 12.sp), // .sp
                                  ),
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
                          Text(
                            "text_to_gensub.max_silence_duration".tr(),
                            style: TextStyle(fontSize: 12.sp), // .sp
                          ),
                          DropdownButton<double>(
                            value: _maxSilenceDuration,
                            items: [
                              for (var sec in [0.1, 0.3, 0.5, 0.7, 0.9, 1.5])
                                DropdownMenuItem(
                                  value: sec,
                                  child: Text(
                                    "$sec ${'units.seconds'.tr()}",
                                    style: TextStyle(fontSize: 12.sp), // .sp
                                  ),
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

                  SizedBox(height: 16.h), // .h

                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 16.h, horizontal: 20.w), // .w, .h
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.cyan, width: 1.5.w), // .w
                      borderRadius: BorderRadius.circular(16.r), // .r
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total points",
                          style: TextStyle(
                            fontSize: 18.sp, // .sp
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/logo/credit-icon.svg',
                              width: 20.w, // .w
                              height: 20.h, // .h
                            ),
                            SizedBox(width: 8.w), // .w
                            Text(
                              "$totalPoints",
                              style: TextStyle(
                                fontSize: 18.sp, // .sp
                                fontWeight: FontWeight.bold,
                                color: Colors.cyan,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h), // .h

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
                        ? SizedBox(
                            width: 20.w, // .w
                            height: 20.h, // .h
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.play_arrow),
                    label: Text(
                      _loading
                          ? "text_to_gensub.transcribing".tr()
                          : "text_to_gensub.transcribe_status".tr(),
                      style: TextStyle(fontSize: 16.sp), // .sp
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: Size.fromHeight(50.h), // .h
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r), // .r
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h), // .h
          if (widget.projects.isNotEmpty) _buildProjectList(),
        ],
      ),
    );
  }
}
