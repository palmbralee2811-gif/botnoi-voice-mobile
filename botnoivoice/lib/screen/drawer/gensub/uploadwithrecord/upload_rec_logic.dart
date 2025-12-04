import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:botnoivoice/screen/drawer/gensub/models/project_model.dart';
import 'package:botnoivoice/screen/drawer/gensub/service/project_asr_api.dart';

class UploadRecordState {
  final int selectedIndex;
  final List<ProjectModel> projects;
  final bool loading;
  final bool isDescending;

  const UploadRecordState({
    this.selectedIndex = 0,
    this.projects = const [],
    this.loading = true,
    this.isDescending = true,
  });

  UploadRecordState copyWith({
    int? selectedIndex,
    List<ProjectModel>? projects,
    bool? loading,
    bool? isDescending,
  }) {
    return UploadRecordState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      projects: projects ?? this.projects,
      loading: loading ?? this.loading,
      isDescending: isDescending ?? this.isDescending,
    );
  }
}

class UploadRecordLogic extends StateNotifier<UploadRecordState> {
  UploadRecordLogic() : super(const UploadRecordState());

  /// ✅ ฟังก์ชันช่วยแปลงวันที่ (แก้ปัญหา Timezone/Format ผิด)
  DateTime _parseDate(dynamic dateStr) {
    if (dateStr == null || dateStr.toString().isEmpty) return DateTime.now();
    try {
      // ลบ 'Z' ออกเพื่อป้องกันปัญหา UTC/Local ตีกัน
      String cleanStr = dateStr.toString().replaceAll('Z', '');
      return DateTime.tryParse(cleanStr) ?? DateTime.now();
    } catch (e) {
      return DateTime.now();
    }
  }

  Future<void> loadProjects(WidgetRef ref) async {
    state = state.copyWith(loading: true);

    try {
      final list = await getAllWorkspaces(ref);

      final projects = (list['data'] as List<dynamic>?)?.map((item) {
            Duration parsedDuration = Duration.zero;
            final rawDuration = item['duration']?.toString();
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
              projectId: item['project_id'] ?? '',
              projectName: item['project_name'] ?? '',
              // ✅ ใช้วิธี parse แบบใหม่
              createdAt: _parseDate(item['create_at']),
              duration: parsedDuration,
              filePath: item['file_path'] ?? '',
              segments: item['segments'] != null
                  ? List<Map<String, dynamic>>.from(item['segments'])
                  : [],
              userId: item['user_id'] ?? '',
              audioS3Link: null,
            );
          }).toList() ??
          [];

      // ✅ เรียงลำดับ
      projects.sort((a, b) => state.isDescending
          ? b.createdAt.compareTo(a.createdAt)
          : a.createdAt.compareTo(b.createdAt));

      state = state.copyWith(projects: projects, loading: false);
    } catch (e) {
      debugPrint("Failed to load projects: $e");
      state = state.copyWith(loading: false);
    }
  }

  void toggleSort() {
    final newOrder = !state.isDescending;
    final sortedProjects = [...state.projects];

    sortedProjects.sort((a, b) => newOrder
        ? b.createdAt.compareTo(a.createdAt)
        : a.createdAt.compareTo(b.createdAt));

    state = state.copyWith(isDescending: newOrder, projects: sortedProjects);
  }

  Future<void> addProject(ProjectModel project) async {
    final updated = [project, ...state.projects];
    updated.sort((a, b) => state.isDescending
        ? b.createdAt.compareTo(a.createdAt)
        : a.createdAt.compareTo(b.createdAt));
    state = state.copyWith(projects: updated);
  }

  Future<void> deleteProject(WidgetRef ref, ProjectModel project) async {
    try {
      await deleteAsrWorkspace(ref, project.projectId, project.userId);
      final updated = state.projects
          .where((p) => p.projectId != project.projectId)
          .toList();
      state = state.copyWith(projects: updated);
    } catch (e) {
      debugPrint("Failed to delete project: $e");
    }
  }

  void changeTab(int index) {
    state = state.copyWith(selectedIndex: index);
  }
}

final uploadRecordProvider =
    StateNotifierProvider<UploadRecordLogic, UploadRecordState>((ref) {
  return UploadRecordLogic();
});