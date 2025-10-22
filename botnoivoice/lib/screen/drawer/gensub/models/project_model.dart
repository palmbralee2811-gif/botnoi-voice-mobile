import 'package:flutter/foundation.dart';

class ProjectModel {
  final String projectId;
  final String projectName;
  final DateTime createdAt;
  final Duration duration;
  final String filePath;
  final List<Map<String, dynamic>> segments;
  final String userId;

  ProjectModel({
    required this.projectId,
    required this.projectName,
    required this.createdAt,
    required this.duration,
    required this.filePath,
    required this.segments,
    required this.userId,
  });

  ProjectModel copyWith({
    String? projectId,
    String? projectName,
    DateTime? createdAt,
    Duration? duration,
    String? filePath,
    List<Map<String, dynamic>>? segments,
    String? userId,
  }) {
    return ProjectModel(
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      createdAt: createdAt ?? this.createdAt,
      duration: duration ?? this.duration,
      filePath: filePath ?? this.filePath,
      segments: segments ?? this.segments,
      userId: userId ?? this.userId,
    );
  }

  ///  ฟังก์ชันช่วย parse duration
  static Duration _parseDuration(dynamic value) {
    if (value == null) return Duration.zero;

    if (value is int) {
      return Duration(seconds: value);
    }

    if (value is String) {
      if (value.contains(":")) {
        // กรณี "00:08"
        final parts = value.split(":");
        final minutes = int.tryParse(parts[0]) ?? 0;
        final seconds = int.tryParse(parts[1]) ?? 0;
        return Duration(minutes: minutes, seconds: seconds);
      } else {
        // กรณี "7"
        return Duration(seconds: int.tryParse(value) ?? 0);
      }
    }

    return Duration.zero;
  }

  ///  fromJson รองรับ field จาก API
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    debugPrint("RAW project json: $json");
    return ProjectModel(
      projectId: json['project_id']?.toString() ?? '',
      projectName: json['project_name']?.toString() ?? '',
      createdAt: json['create_at'] != null
          ? DateTime.tryParse(json['create_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      duration: _parseDuration(json['duration']),
      filePath: json['file_path']?.toString() ?? '',
      segments: json['segments'] != null
          ? List<Map<String, dynamic>>.from(json['segments'])
          : [],
      userId: json['user_id']?.toString() ?? '',
    );
  }
  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  ///  toJson
  Map<String, dynamic> toJson() => {
        'project_id': projectId,
        'project_name': projectName,
        'create_at': createdAt.toIso8601String(),
        'duration': _formatDuration(duration), // ส่งเป็น "MM:SS"
        'file_path': filePath,
        'segments': segments,
        'user_id': userId,
      };
}
