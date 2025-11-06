// upload_record_logic.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart'; // ต้อง import เพื่อใช้ BuildContext ใน methods
import 'package:botnoivoice/screen/drawer/gensub/models/project_model.dart';
import 'package:flutter/foundation.dart'; // สำหรับ debugPrint

// Import Standalone API Functions ใหม่ที่คุณสร้าง
import 'package:botnoivoice/screen/drawer/gensub/service/project_asr_api.dart'; 

/// State class
class UploadRecordState {
  final int selectedIndex;
  final List<ProjectModel> projects;
  final bool loading;
  // final String apiToken; // <<< ลบออก ไม่จำเป็นต้องเก็บ token ใน State อีกแล้ว

  const UploadRecordState({
    this.selectedIndex = 0,
    this.projects = const [],
    this.loading = true,
    // this.apiToken = '', // <<< ลบออก
  });

  UploadRecordState copyWith({
    int? selectedIndex,
    List<ProjectModel>? projects,
    bool? loading,
    // String? apiToken, // <<< ลบออก
  }) {
    return UploadRecordState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      projects: projects ?? this.projects,
      loading: loading ?? this.loading,
      // apiToken: apiToken ?? this.apiToken, // <<< ลบออก
    );
  }
}

/// StateNotifier (แทน ChangeNotifier)
class UploadRecordLogic extends StateNotifier<UploadRecordState> {
  UploadRecordLogic()
      : super(
          // ❌ ลบการใช้ dotenv/apiToken ใน constructor
          const UploadRecordState(),
        );

  // ✅ เพิ่ม BuildContext เป็น Argument
  Future<void> loadProjects(BuildContext context) async {
    state = state.copyWith(loading: true);

    try {
      // final api = ProjectApiService(state.apiToken); // <<< ลบออก

      // ✅ เรียกใช้ฟังก์ชัน Standalone API และส่ง context
      final list = await getAllWorkspaces(context); 
      
      final projects = (list['data'] as List<dynamic>?)?.map((item) {
        // แปลง duration (Logic เดิม)
        Duration parsedDuration = Duration.zero;
        final rawDuration = item['duration']?.toString();
        if (rawDuration != null && rawDuration.isNotEmpty) {
          if (rawDuration.contains(":")) {
            // เช่น "00:08"
            final parts = rawDuration.split(":");
            if (parts.length == 2) {
              final minutes = int.tryParse(parts[0]) ?? 0;
              final seconds = int.tryParse(parts[1]) ?? 0;
              parsedDuration = Duration(minutes: minutes, seconds: seconds);
            }
          } else {
            // เช่น "7"
            final seconds = int.tryParse(rawDuration) ?? 0;
            parsedDuration = Duration(seconds: seconds);
          }
        }

        return ProjectModel(
          projectId: item['project_id'] ?? '',
          projectName: item['project_name'] ?? '',
          createdAt: DateTime.tryParse(item['create_at'] ?? '') ?? DateTime.now(),
          duration: parsedDuration,
          filePath: item['file_path'] ?? '',
          segments: item['segments'] != null
              ? List<Map<String, dynamic>>.from(item['segments'])
              : [],
          userId: item['user_id'] ?? '',
        );
      }).toList() ?? [];

      state = state.copyWith(projects: projects, loading: false);
    } catch (e) {
      debugPrint("Failed to load projects: $e");
      state = state.copyWith(loading: false);
    }
  }

  Future<void> addProject(ProjectModel project) async {
    final updated = [...state.projects, project];
    state = state.copyWith(projects: updated);
  }

  // ✅ เพิ่ม BuildContext เป็น Argument
  Future<void> deleteProject(BuildContext context, ProjectModel project) async {
    try {
      // final api = ProjectApiService(state.apiToken); // <<< ลบออก
      
      // ✅ เรียกใช้ฟังก์ชัน Standalone API และส่ง context
      await deleteAsrWorkspace(context, project.projectId, project.userId); 
      
      final updated =
          state.projects.where((p) => p.projectId != project.projectId).toList();
      state = state.copyWith(projects: updated);
    } catch (e) {
      debugPrint("Failed to delete project: $e");
      // Note: อาจจะต้องเพิ่ม logic จัดการ error ใน UI
    }
  }

  void changeTab(int index) {
    state = state.copyWith(selectedIndex: index);
  }
}

/// Provider (อันนี้เอาไปใช้ใน widget)
final uploadRecordProvider =
    StateNotifierProvider<UploadRecordLogic, UploadRecordState>((ref) {
  return UploadRecordLogic();
});