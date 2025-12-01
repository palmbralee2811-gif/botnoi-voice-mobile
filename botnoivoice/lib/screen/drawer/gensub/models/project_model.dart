import 'package:flutter/foundation.dart';

class ProjectModel {
  final String projectId;
  final String projectName;
  final DateTime createdAt;
  final Duration duration;
  final String filePath;
  final List<Map<String, dynamic>> segments;
  final String userId;
  final String? audioS3Link; // ✅ เพิ่มฟิลด์ S3 link


  ProjectModel({
    required this.projectId,
    required this.projectName,
    required this.createdAt,
    required this.duration,
    required this.filePath,
    required this.segments,
    required this.userId,
    required this.audioS3Link, // ✅ เพิ่มใน constructor
  });

  ProjectModel copyWith({
    String? projectId,
    String? projectName,
    DateTime? createdAt,
    Duration? duration,
    String? filePath,
    List<Map<String, dynamic>>? segments,
    String? userId,
    String? audioS3Link, // ✅ เพิ่ม copyWith
  }) {
    return ProjectModel(
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      createdAt: createdAt ?? this.createdAt,
      duration: duration ?? this.duration,
      filePath: filePath ?? this.filePath,
      segments: segments ?? this.segments,
      userId: userId ?? this.userId,
      audioS3Link: audioS3Link ?? this.audioS3Link,
    );
  }

  /// helper parse duration
  static Duration _parseDuration(dynamic value) {
    if (value == null) return Duration.zero;

    if (value is int) {
      return Duration(seconds: value);
    }

    if (value is String) {
      if (value.contains(":")) {
        final parts = value.split(":");
        final minutes = int.tryParse(parts[0]) ?? 0;
        final seconds = int.tryParse(parts[1]) ?? 0;
        return Duration(minutes: minutes, seconds: seconds);
      } else {
        return Duration(seconds: int.tryParse(value) ?? 0);
      }
    }

    return Duration.zero;
  }

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

      /// ⭐ รองรับ key จาก API:
      /// - audio_s3_link
      /// - audioS3Link
      audioS3Link: json['audio_s3_link']?.toString()
          ?? json['audioS3Link']?.toString()
          ?? null,
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Map<String, dynamic> toJson() => {
        'project_id': projectId,
        'project_name': projectName,
        'create_at': createdAt.toIso8601String(),
        'duration': _formatDuration(duration),
        'file_path': filePath,
        'segments': segments,
        'user_id': userId,
        'audio_s3_link': audioS3Link, // ⭐ เซฟลง JSON
      };
}
